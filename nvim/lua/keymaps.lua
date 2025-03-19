local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap.set("n", "<leader>h", ":nohlsearch<CR>", opts) -- Toggle search highlight
keymap.set("n", "<leader>bd", ":bd<CR>", opts) -- Close buffer
keymap.set("n", "<leader>w", ":w<CR>", opts) -- Save file

-- Random stuff
keymap.set("n", "<leader>d", '"_d', { noremap = true })
keymap.set("x", "<leader>d", '"_d', { noremap = true })

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

-- Toggle hints
keymap.set("n", "<leader>i", function()
	require("craftzdog.lsp").toggleInlayHints()
end)
