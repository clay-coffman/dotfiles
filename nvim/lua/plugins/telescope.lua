return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local utils = require("telescope.utils")
			local themes = require("telescope.themes")
			local builtin = require("telescope.builtin")

			local opts = { winblend = 10 }

			telescope.setup({
				defaults = {
					mappings = { i = { ["<C-h>"] = "which_key" } },
				},
			})

			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({ hidden = true })
			end, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope commands" })
			vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Telescope definitions" })
			vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Telescope references" })
			vim.keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "Telescope symbols (via treesitter)" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
			vim.keymap.set("n", "<leader>fx", builtin.diagnostics, { desc = "Telescope diagnostics" })
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

	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			local telescope = require("telescope")
			local themes = require("telescope.themes")

			telescope.setup({
				extensions = {
					["ui-select"] = {
						-- use your dropdown theme (you can pass winblend, previewer, etc)
						themes.get_dropdown({
							winblend = 10,
							-- previewer = false,
							-- width     = 0.5,
						}),
					},
				},
			})

			-- this actually overrides vim.ui.select behind the scenes
			telescope.load_extension("ui-select")
		end,
	},
}
