return {

	-- vim-tmux-navigation
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			local nvim_tmux_nav = require("nvim-tmux-navigation")

			nvim_tmux_nav.setup({
				disable_when_zoomed = true, -- defaults to false
			})

			vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
			vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
			vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
			vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
			vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
			vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
		end,
	},

	-- notify.nvim
	{
		"rcarriga/nvim-notify",
	},

	-- neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = true,
				enable_diagnostics = true,
				window = {
					width = 30,
					mappings = {
						["<CR>"] = "open",
						["<Tab>"] = "open",
						["<C-v>"] = "open_vsplit",
						["<C-x>"] = "open_split",
						["<C-t>"] = "open_tabnew",
						["z"] = "close_node",
						["Z"] = "close_all_nodes",
						["a"] = "add",
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
					},
				},
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = {
						enable = true,
					},
				},
			})
			vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
		end,
	},

	-- nvim-autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						runner = "pytest",
					}),
				},
				status = {
					virtual_text = true,
				},
			})
		end,
	},
	-- toggleterm
	{
		{ "akinsho/toggleterm.nvim", version = "*", config = true },
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			opts = {
				-- Basic options (referencing the README and previous suggestions)
				-- size can be a number or function
				size = function(term)
					if term.direction == "horizontal" then
						return 15 -- Adjust as needed
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4 -- Adjust as needed
					end
					-- Add a fallback size if needed, e.g., for float or tab
					return 20
				end,
				-- open_mapping = [[<c-\>]], -- You might want to map this in keymaps.lua instead
				hide_numbers = true, -- Hide numbers in terminal buffer
				shade_terminals = true, -- Use toggleterm's shading
				-- shading_factor = -20, -- Adjust darkness/lightness, negative for darker, positive for lighter
				start_in_insert = true,
				insert_mappings = false, -- Disable default insert mapping '<c-\>' if you map it elsewhere
				terminal_mappings = true, -- Allow mappings defined in `set_terminal_keymaps` (see below)
				persist_size = true,
				persist_mode = true, -- Remember terminal mode (recommended)
				direction = "float", -- Default direction ('vertical', 'horizontal', 'tab', 'float')
				close_on_exit = true, -- Close the terminal window when the process exits
				shell = vim.o.shell, -- Use Neovim's configured shell
				auto_scroll = true, -- Automatically scroll to the bottom on terminal output
				float_opts = {
					border = "curved", -- 'single', 'double', 'shadow', 'curved'
					winblend = 0, -- Adjust transparency (0=opaque, 100=fully transparent)
					-- width = <number_or_function>,
					-- height = <number_or_function>,
					-- row = <number_or_function>,
					-- col = <number_or_function>,
				},
				winbar = {
					enabled = false, -- Set to true if you want the experimental winbar
					name_formatter = function(term)
						return term.name
					end,
				},
				-- Add any other options from the README documentation you want to configure
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {}, -- add add'l config here
	},
}
