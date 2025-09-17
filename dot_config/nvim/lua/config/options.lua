-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- use prettier config file in $HOME
vim.g.lazyvim_prettier_needs_config = true

local opt = vim.opt

opt.conceallevel = 3 -- conceallevel relevant for markdown
opt.tabstop = 2 -- number of spaces tabs count for
