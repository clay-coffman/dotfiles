vim.g.mapleader = " "

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

vim.o.winborder = "rounded"

vim.g.python3_host_prog = "$HOME/.asdf/installs/python/3.11.9/bin/python"

vim.diagnostic.config({
	signs = true,
	virtual_text = false,
	virtual_lines = {
		current_line = true,
	},
	severity_sort = true,
})
