-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- use prettier config file in $HOME
vim.g.lazyvim_prettier_needs_config = true

-- diagnostics
-- Make diagnostic virtual text italic
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { italic = true })

local opt = vim.opt

opt.conceallevel = 3 -- conceallevel relevant for markdown
opt.tabstop = 2 -- number of spaces tabs count for
