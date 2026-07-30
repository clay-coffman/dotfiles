--- dir-info.yazi — show each directory's git branch and any agent process
--- running in it (claude, codex, …) as a linemode in the file list.
---
--- Branches are read straight from .git/HEAD (following the `gitdir:` pointer
--- for linked worktrees) rather than by spawning git, so a page of 30 repos
--- costs 30 small file reads instead of 30 subprocesses.
---
--- Running processes come from `tmux list-panes -a`, which already knows every
--- pane's cwd and foreground command — one subprocess for the whole page.

--- Commands that are never worth showing.
local IGNORE = {
	zsh = true,
	bash = true,
	sh = true,
	fish = true,
	tmux = true,
	yazi = true,
	ya = true,
	nvim = true,
	git = true,
	less = true,
	man = true,
}

--- Claude Code sets its process name to its own version ("2.1.220"), so it
--- arrives from tmux looking like a version string rather than a command.
---@param cmd string
---@return string
local function normalize(cmd)
	if cmd:match("^%d+%.%d+%.%d+") then
		return "claude"
	end
	return cmd
end

---@param path string
---@return string?
local function first_line(path)
	local file = io.open(path)
	if not file then
		return nil
	end
	local line = file:read("*l")
	file:close()
	return line
end

--- Resolve a directory's checked-out branch, or a short SHA when detached.
---@param url Url
---@return string?
local function branch_of(url)
	local dot = url:join(".git")
	local cha = fs.cha(dot)
	if not cha then
		return nil
	end

	local gitdir
	if cha.is_dir then
		gitdir = tostring(dot)
	else
		-- Linked worktree: .git is a file holding "gitdir: <path>"
		local pointer = first_line(tostring(dot))
		gitdir = pointer and pointer:match("^gitdir:%s*(.+)$")
		if not gitdir then
			return nil
		end
		if not gitdir:match("^/") then
			gitdir = tostring(url:join(gitdir))
		end
	end

	local head = first_line(gitdir .. "/HEAD")
	if not head then
		return nil
	end
	return head:match("^ref:%s*refs/heads/(.+)$") or head:sub(1, 7)
end

--- Map every tmux pane's cwd to the set of commands running there.
---@return table<string, table<string, boolean>>
local function panes()
	local out = Command("tmux")
		:arg({ "list-panes", "-a", "-F", "#{pane_current_path}\t#{pane_current_command}" })
		:output()
	if not out or not out.stdout then
		return {}
	end

	local map = {}
	for line in out.stdout:gmatch("[^\r\n]+") do
		local path, cmd = line:match("^(.-)\t(.+)$")
		if path and cmd then
			map[path] = map[path] or {}
			map[path][normalize(cmd)] = true
		end
	end
	return map
end

--- Commands running in `dir` or anywhere beneath it.
---@param dir string
---@param map table<string, table<string, boolean>>
---@return string?
local function procs_in(dir, map)
	local found, seen = {}, {}
	local prefix = dir .. "/"
	for path, cmds in pairs(map) do
		if path == dir or path:sub(1, #prefix) == prefix then
			for cmd in pairs(cmds) do
				if not IGNORE[cmd] and not seen[cmd] then
					seen[cmd] = true
					found[#found + 1] = cmd
				end
			end
		end
	end
	if #found == 0 then
		return nil
	end
	table.sort(found)
	return table.concat(found, " ")
end

--- Publish a page's results, clearing whatever those directories held before.
local publish = ya.sync(function(st, keys, branches, procs)
	for _, key in ipairs(keys) do
		st.branch[key] = branches[key]
		st.proc[key] = procs[key]
	end
	ui.render()
end)

---@param st State
local function setup(st, opts)
	st.branch = {}
	st.proc = {}

	opts = opts or {}
	local order = opts.order or 2000
	local branch_icon = opts.branch_icon or " "
	local branch_style = opts.branch_style or ui.Style():fg("cyan")
	local proc_style = opts.proc_style or ui.Style():fg("magenta"):bold()

	Linemode:children_add(function(self)
		local file = self._file
		if not file.in_current or not file.cha.is_dir then
			return ""
		end

		local key = tostring(file.url)
		local branch, proc = st.branch[key], st.proc[key]
		if not branch and not proc then
			return ""
		end

		local spans = {}
		if proc then
			local text = " " .. proc
			spans[#spans + 1] = file.is_hovered and ui.Span(text) or ui.Span(text):style(proc_style)
		end
		if branch then
			local text = " " .. branch_icon .. branch
			spans[#spans + 1] = file.is_hovered and ui.Span(text) or ui.Span(text):style(branch_style)
		end
		return ui.Line(spans)
	end, order)
end

---@type UnstableFetcher
local function fetch(_, job)
	local keys, urls = {}, {}
	for _, file in ipairs(job.files) do
		if file.cha.is_dir then
			local key = tostring(file.url)
			keys[#keys + 1] = key
			urls[key] = file.url
		end
	end
	if #keys == 0 then
		return true
	end

	local map = panes()
	local branches, procs = {}, {}
	for _, key in ipairs(keys) do
		branches[key] = branch_of(urls[key])
		procs[key] = procs_in(key, map)
	end

	publish(keys, branches, procs)
	return true
end

return { setup = setup, fetch = fetch }
