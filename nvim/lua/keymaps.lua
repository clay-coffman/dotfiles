local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap.set("n", "<leader>h", ":nohlsearch<CR>", opts) -- Toggle search highlight
keymap.set("n", "<leader>bd", ":bd<CR>", opts) -- Close buffer
keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true, desc = "Next [B]uffer" })
keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true, desc = "[P]revious [B]uffer" })
keymap.set("n", "<leader>w", ":w<CR>", opts) -- Save file

-- neotest
--
-- Run tests
vim.keymap.set("n", "<leader>tn", function()
	require("neotest").run.run()
end, { desc = "Neotest: Run Nearest" })

-- Run file (_tests file presumably)
vim.keymap.set("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Neotest: Run File" })

-- Debug tests (requires nvim-dap and dap config in neotest-python)
vim.keymap.set("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Neotest: Debug Nearest" })

-- Stop tests
vim.keymap.set("n", "<leader>ts", function()
	require("neotest").run.stop()
end, { desc = "Neotest: Stop" })

-- Show output / summary
vim.keymap.set("n", "<leader>to", function()
	require("neotest").output.open({ enter = true, auto_close = true })
end, { desc = "Neotest: Output" })
vim.keymap.set("n", "<leader>tS", function()
	require("neotest").summary.toggle()
end, { desc = "Neotest: Summary Toggle" })

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Diagnostics
-- ** NOW handled by nvim natively with [d and ]d
-- keymap.set("n", "<C-j>", function()
-- 	vim.diagnostic.jump({ count = 1, float = true })
-- end, opts)
--
-- keymap.set("n", "<C-k>", function()
-- 	vim.diagnostic.jump({ count = -1, float = true })
-- end, opts)

-- Toggle hints
keymap.set("n", "<leader>i", function()
	require("craftzdog.lsp").toggleInlayHints()
end)

-- Todos
keymap.set(
	"n",
	"<leader>ft",
	":TodoTelescope<CR>",
	{ noremap = true, silent = true, desc = "Find TODOs via Telescope" }
)

-- Obsidian
-- search vault
-- Quickly search your Obsidian vault
keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", opts)

-- Quickly switch to or create notes
keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", opts)

-- Insert template easily
keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", opts)

-- Create new note from template
keymap.set("n", "<leader>on", "<cmd>ObsidianNewFromTemplate<CR>", opts)

-- Open daily note quickly
keymap.set("n", "<leader>od", "<cmd>ObsidianToday<CR>", opts)

-- Follow links under cursor
keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>", opts)

-- View backlinks for current note
keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", opts)

--- Termtoggle
-- ToggleTerm mappings (Ensure these don't conflict with <C-h>, <C-j>, <C-k>, <C-l> tmux nav)
keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal (Float)" })
keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle Horizontal Term" })
keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle Vertical Term" })

-- Mapping to easily exit terminal mode (using the method from the README)
-- Add this function somewhere accessible, maybe top of keymaps.lua or in a utils file
function _G.set_terminal_keymaps()
	local term_opts = { buffer = 0, noremap = true, silent = true }
	-- Exit terminal mode with Escape
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], term_opts)
	-- Optional: Map terminal navigation if you want it separate from tmux nav
	-- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], term_opts)
	-- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], term_opts)
	-- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], term_opts)
	-- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], term_opts)
end

-- Autocommand to apply the keymaps when a terminal buffer is opened
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
