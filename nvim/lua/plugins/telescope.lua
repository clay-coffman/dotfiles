return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = { mappings = { i = { ["<C-h>"] = "which_key" } } },
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Telescope definitions" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope symbols" })
		end,
	},

	{
		"benfowler/telescope-luasnip.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		event = "InsertEnter",
		config = function()
			local telescope = require("telescope")
			telescope.load_extension("luasnip")

			-- <leader>fl → open the LuaSnip picker
			vim.keymap.set(
				"n",
				"<leader>fl",
				telescope.extensions.luasnip.luasnip,
				{ desc = "Telescope LuaSnip picker", silent = true }
			)
		end,
	},
}
