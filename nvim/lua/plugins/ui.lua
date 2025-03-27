return {
	-- Web Devicons (icons for various plugins)
	"nvim-tree/nvim-web-devicons",

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},

	-- nightfox theme
	{
		"EdenEast/nightfox.nvim",
		config = function()
			require("nightfox").setup({
				options = {
					transparent = false,
					terminal_colors = true,
					styles = {
						comments = "italic",
						keywords = "bold",
						types = "italic,bold",
					},
				},
			})
			vim.cmd("colorscheme dayfox")
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					"dashboard",
					"neo-tree",
					"Trouble",
					"mason",
					"lazy",
					"notify",
					"lazyterm",
					"help",
					"toggleterm",
				},
				buftypes = {
					"nofile",
					"prompt",
					"quickfix",
					"terminal",
				},
			},
		},
	},

	-- git-signs
	{
		"lewis6991/gitsigns.nvim",
	},

	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "hyper",
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		-- ---@type render.md.UserConfig
		ft = { "markdown", "copilot-chat", "codecompanion" },
		opts = {
			render_modes = true,
			anti_conceal = {
				enabled = true,
				ignore = { code_background = true, sign = true },
				above = 1,
				below = 1,
			},
			file_types = { "markdown", "md", "markdown.mdx", "Avante", "copilot-chat", "codecompanion" },
			links = {
				enabled = true,
				conceal = true,
			},
			highlights = {
				heading = "Title",
				bold = "Bold",
				italic = "Italic",
				code = "CursorLine",
			},
			-- bullet = {
			-- 	enabled = true,
			-- 	right_pad = 1,
			-- },
		},
	},
}
