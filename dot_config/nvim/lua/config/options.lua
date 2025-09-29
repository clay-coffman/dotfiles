-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- use prettier config file in $HOME
vim.g.lazyvim_prettier_needs_config = true

local opt = vim.opt

-- conceallevel relevant for markdown
opt.conceallevel = 2

-- number of spaces tabs count for
opt.tabstop = 2

-- disables dashes for spaces
opt.list = false

--  set hard wrap at 80
opt.textwidth = 80

-- hard wrap
opt.wrap = true

-- wrap at word boundaries
opt.linebreak = true
