-- Candidate base branches, in case auto-detection is ambiguous. The detector
-- below picks whichever of these you most recently forked from; this list just
-- bounds the search. Per-repo override: `git config diffview.base <branch>`.
local CANDIDATE_BASES = { "dev", "develop", "staging", "main", "master", "trunk" }

-- Buffers that were listed before the current diffview opened (see hooks below).
local listed_before_view = nil

local function git(args)
  local out = vim.fn.systemlist("git " .. args .. " 2>/dev/null")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return out
end

local function ref_exists(ref)
  return git("rev-parse --verify --quiet " .. ref) ~= nil
end

-- Resolve the branch this one was forked from.
--  1. explicit `git config diffview.base` wins
--  2. otherwise, among CANDIDATE_BASES that exist, the one whose merge-base
--     with HEAD is the most recent commit (i.e. the closest fork point)
--  3. fall back to the repo's default branch, then "main"
local function detect_base()
  local cfg = git("config --get diffview.base")
  if cfg and cfg[1] and cfg[1] ~= "" then
    return cfg[1]
  end

  local cur = git("rev-parse --abbrev-ref HEAD")
  cur = cur and cur[1]
  local head = git("rev-parse HEAD")
  head = head and head[1]

  local best, best_ts = nil, -1
  for _, name in ipairs(CANDIDATE_BASES) do
    if name ~= cur then
      local ref = (ref_exists("refs/remotes/origin/" .. name) and ("origin/" .. name))
        or (ref_exists("refs/heads/" .. name) and name)
        or nil
      if ref then
        local mb = git("merge-base " .. ref .. " HEAD")
        mb = mb and mb[1]
        -- skip refs that are descendants of HEAD (merge-base == HEAD)
        if mb and mb ~= "" and mb ~= head then
          local ts = git("show -s --format=%ct " .. mb)
          ts = ts and tonumber(ts[1]) or -1
          if ts > best_ts then
            best, best_ts = ref, ts
          end
        end
      end
    end
  end
  if best then
    return best
  end

  local def = git("symbolic-ref --short refs/remotes/origin/HEAD")
  if def and def[1] then
    return (def[1]:gsub("^origin/", ""))
  end
  return "main"
end

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history (current)" },
    { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: file history (repo)" },
    {
      "<leader>gb",
      function()
        vim.ui.input({ prompt = "Base branch: ", default = detect_base() }, function(base)
          if base and base ~= "" then
            vim.cmd("DiffviewOpen " .. base .. "...HEAD")
          end
        end)
      end,
      desc = "Diffview: branch vs base (prompt)",
    },
    {
      "<leader>gR",
      function()
        vim.cmd("DiffviewOpen " .. detect_base() .. "...HEAD")
      end,
      desc = "Review: branch vs fork base (no prompt)",
    },
    { "<leader>gl", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Review: last commit" },
  },
  opts = {
    enhanced_diff_hl = true,
    default_args = {
      -- When a range ends at HEAD (e.g. main...HEAD), show the local file on
      -- that side instead of a read-only git blob: editable, with LSP attached.
      DiffviewOpen = { "--imply-local" },
    },
    hooks = {
      -- --imply-local makes the HEAD side a real file buffer, and diffview
      -- force-lists it — so cycling files would pile every visited file into
      -- the bufferline. Unlist buffers the view pulled in itself; buffers that
      -- were already open (i.e. listed before the view) are left alone.
      view_opened = function()
        listed_before_view = {}
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[b].buflisted then
            listed_before_view[b] = true
          end
        end
      end,
      diff_buf_win_enter = function(bufnr)
        if listed_before_view and not listed_before_view[bufnr] then
          vim.bo[bufnr].buflisted = false
        end
      end,
      view_closed = function()
        listed_before_view = nil
      end,
    },
    view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
  },
}
