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
					lualine_c = { "filename", "lsp_status" },
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
			local my_groups = {
				all = {
					DiagnosticError = { fg = "palette.red.dim", style = "italic" },
					DiagnosticWarn = { fg = "palette.yellow.dim", style = "italic" },
					DiagnosticInfo = { fg = "palette.blue.dim", style = "italic" },
					DiagnosticHint = { fg = "palette.magenta.dim", style = "italic" },
				},
			}

			require("nightfox").setup({
				options = {
					transparent = false,
					terminal_colors = true,
					dim_inactive = true,
					styles = {
						comments = "italic",
						keywords = "bold",
						functions = "italic,bold",
					},
				},
				groups = my_groups,
			})
			vim.cmd("colorscheme dayfox")
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			scope = { enabled = true },
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
			indent = {
				highlight = { "Whitespace" },
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
		},
	},
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- Setup mini.hipatterns for hex color previews
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				-- Define highlights (the default has 'hex_color')
				highlighters = {
					-- Highlight hex colors (#rrggbb)
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			-- Function to run when system switches to dark mode
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", { scope = "global" })
				-- Set your desired dark theme (e.g., 'nightfox' or 'nordfox')
				vim.cmd("colorscheme nightfox")
			end,
			-- Function to run when system switches to light mode
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", { scope = "global" })
				-- Set your desired light theme (e.g., 'dayfox')
				vim.cmd("colorscheme dayfox")
			end,
			-- How often to check the system setting (in milliseconds)
			update_interval = 1000, -- Check every second
			-- Fallback mode if detection fails
			fallback = "dark", -- Or "light"
		},
	},
}
