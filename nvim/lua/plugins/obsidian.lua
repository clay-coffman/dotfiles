return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		ui = {
			enable = false,
		},
		workspaces = {
			{
				name = "personal",
				path = "~/Documents",
			},
		},

		completion = {
			nvim_cmp = false,
			min_chars = 2,
		},

		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			substitutions = {
				yesterday = function()
					return os.date("%Y-%m-%d", os.time() - 86400)
				end,
			},
		},

		picker = {
			name = "telescope.nvim",
			note_mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
		},

		mappings = {
			-- ["gf"] = {
			-- 	action = function()
			-- 		return require("obsidian").util.gf_passthrough()
			-- 	end,
			-- 	opts = { noremap = false, expr = true, buffer = true },
			-- },
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},

		daily_notes = {
			folder = "notes/dailies",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily" },
			template = "daily.md",
		},

		attachments = {
			img_folder = "assets/imgs",
			img_name_func = function()
				return string.format("%s-", os.time())
			end,
			img_text_func = function(client, path)
				path = client:vault_relative_path(path) or path
				return string.format("![%s](%s)", path.name, path)
			end,
		},

		sort_by = "modified",
		sort_reversed = true,
	},
}
