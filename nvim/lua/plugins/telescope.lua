return {
	-- Telescope (fuzzy finder)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-h>"] = "which_key",
						},
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Telescope symbol definition" })
			vim.keymap.set(
				"n",
				"<leader>fs",
				builtin.lsp_dynamic_workspace_symbols,
				{ desc = "Telescope workspace symbols" }
			)
		end,
	},
}
