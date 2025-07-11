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
-- Toggle inlay hints
keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
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
-- Open daily note quickly
keymap.set("n", "<leader>od", "<cmd>ObsidianToday<CR>", opts)

-- Follow links under cursor
keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>", opts)

-- View backlinks for current note
keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", opts)
