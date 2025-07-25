vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.conceallevel = 2
vim.opt.laststatus = 3
vim.opt.cmdheight = 1
vim.o.winborder = "rounded"

-- Set Python host dynamically
-- Priority: 1) ASDF shim, 2) System python3, 3) Fallback to 'python3'
local function find_python_host()
	-- Try ASDF shim first (works with any ASDF-managed Python version)
	local asdf_python = vim.fn.expand("~/.asdf/shims/python3")
	if vim.fn.executable(asdf_python) == 1 then
		return asdf_python
	end

	-- Try system python3
	local system_python = vim.fn.exepath("python3")
	if system_python ~= "" then
		return system_python
	end

	-- Fallback
	return "python3"
end

vim.g.python3_host_prog = find_python_host()

local colors = {
	Error = "#f7768e",
	Warn = "#e0af68",
	Info = "#7aa2f7",
	Hint = "#9ece6a",
}

local neotest_colors = {
	Passed = "#40a02b",
	Failed = "#d20f39",
	Running = "#df8e1d",
	Skipped = "#04a5e5",
}

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		for sev, col in pairs(colors) do
			vim.api.nvim_set_hl(0, "DiagnosticSign" .. sev, { fg = col, bg = "NONE" })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualText" .. sev, { fg = col, bg = "NONE", italic = true })
			vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. sev, { sp = col, undercurl = true })
			vim.api.nvim_set_hl(0, "NeotestPassed", { fg = neotest_colors.Passed, bg = "NONE" })
			vim.api.nvim_set_hl(0, "NeotestFailed", { fg = neotest_colors.Failed, bg = "NONE" })
			vim.api.nvim_set_hl(0, "NeotestRunning", { fg = neotest_colors.Running, bg = "NONE" })
			vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = neotest_colors.Skipped, bg = "NONE" })
		end
	end,
})

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	virtual_text = {
		spacing = 2,
		prefix = "",
	},
	severity_sort = true,
})
