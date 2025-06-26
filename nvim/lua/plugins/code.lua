-- Define on_attach() (for diagnostics)
local on_attach = function(client, bufnr)
	if client.name == "ruff" or client.name == "typescript-tools" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- Existing mappings
	vim.keymap.set(
		"n",
		"<leader>d",
		vim.diagnostic.open_float,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Show Line Diagnostics" }
	)
	vim.keymap.set(
		"n",
		"K",
		vim.lsp.buf.hover,
		{ noremap = true, silent = true, buffer = bufnr, desc = "LSP Hover Info" }
	)

	-- Add these LSP actions:
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Find References" })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to Implementation" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Actions" })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
	vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
end

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf, timeout_ms = 3000 })
	end,
})

return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({
				PATH = "prepend",
			})
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				-- a list of all tools you want to ensure are installed upon
				-- start
				ensure_installed = {
					"html-lsp",
					"pyright",
					"clangd",
					"ruff",
					"lua-language-server",
				},

				-- if set to true this will check each tool for updates. If updates
				-- are available the tool will be updated. This setting does not
				-- affect :MasonToolsUpdate or :MasonToolsInstall.
				-- Default: false
				auto_update = true,

				-- automatically install / update on startup. If set to false nothing
				-- will happen on startup. You can use :MasonToolsInstall or
				-- :MasonToolsUpdate to install tools and check for updates.
				-- Default: true
				run_on_start = true,

				-- set a delay (in ms) before the installation starts. This is only
				-- effective if run_on_start is set to true.
				-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
				-- Default: 0
				start_delay = 3000, -- 3 second delay

				-- Only attempt to install if 'debounce_hours' number of hours has
				-- elapsed since the last time Neovim was started. This stores a
				-- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
				-- This is only relevant when you are using 'run_on_start'. It has no
				-- effect when running manually via ':MasonToolsInstall' etc....
				-- Default: nil
				debounce_hours = 5, -- at least 5 hours between attempts to install/update

				-- By default all integrations are enabled. If you turn on an integration
				-- and you have the required module(s) installed this means you can use
				-- alternative names, supplied by the modules, for the thing that you want
				-- to install. If you turn off the integration (by setting it to false) you
				-- cannot use these alternative names. It also suppresses loading of those
				-- module(s) (assuming any are installed) which is sometimes wanted when
				-- doing lazy loading.
				integrations = {
					["mason-lspconfig"] = true,
					-- ['mason-null-ls'] = true,
					-- ['mason-nvim-dap'] = true,
				},
			})
		end,
	},

	-- nvim-lspconfig for configuring LSPs
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- LSP servers
			local servers = { "pyright", "clangd", "lua_ls", "ruff", "html" }

			-- Loop through the servers and set them up
			for _, server_name in ipairs(servers) do
				local server_opts = {
					on_attach = on_attach,
					capabilities = capabilities,
				}

				if server_name == "pyright" then
					server_opts = vim.tbl_deep_extend("force", server_opts, {
						settings = {
							python = {
								analysis = {
									autoSearchPaths = true,
									diagnosticMode = "workspace",
									useLibraryCodeForTypes = true,
								},
							},
						},
					})
				end
				lspconfig[server_name].setup(server_opts)
			end
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" }, -- lazy-load on first lintable event
		config = function()
			local lint = require("lint")

			-- 1. Associate filetypes → linters
			lint.linters_by_ft = {
				html = { "htmlhint" }, -- npm i -g htmlhint
				javascript = { "eslint_d" }, -- npm i -g eslint_d
				typescript = { "eslint_d" },
				python = { "ruff" }, -- already installed via mason
				sh = { "shellcheck" }, -- brew install shellcheck (or pacman/apt…)
			}

			-- 2. Run them automatically
			local aug = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = aug,
				callback = function()
					-- try_lint() runs linters configured for the current buffer’s filetype
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		dependencies = { "mason-org/mason.nvim" }, -- so :Mason can install binaries
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff", "docformatter" },
					sh = { "shfmt" },
					json = { "prettier" },
					jsonc = { "prettier" }, -- JSON with comments
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					markdown = { "prettier" },
					yaml = { "prettier" },
				},

				format_on_save = function(bufnr)
					return {
						timeout_ms = 1000,
						lsp_format = "fallback",
					}
				end,
			})

			vim.keymap.set("n", "<leader>gf", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format buffer (Conform)" })
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },

		config = function()
			local luasnip = require("luasnip")
			luasnip.config.setup({
				history = true,
				updateevents = "TextChanged,TextChangedI",
			})
			require("luasnip.loaders.from_vscode").lazy_load()

			-- key-maps ---------------------------------------------------------------
			local map = vim.keymap.set
			local opts = { silent = true }

			-- Expand snippet OR jump to next placeholder
			map({ "i", "s" }, "<C-n>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				end
			end, vim.tbl_extend("keep", { desc = "LuaSnip expand / next" }, opts))

			-- Jump to previous placeholder
			map({ "i", "s" }, "<C-p>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, vim.tbl_extend("keep", { desc = "LuaSnip jump back" }, opts))

			-- Cycle through choice nodes
			map("i", "<C-l>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, vim.tbl_extend("keep", { desc = "LuaSnip next choice" }, opts))
		end,
	},

	{ "onsails/lspkind.nvim", event = "VeryLazy" },

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({
				check_ts = true, -- Check treesitter for better behavior
				ts_config = {
					lua = { "string" },
					javascript = { "template_string" },
					java = false,
				},
			})
			-- This is needed for nvim-cmp to play nicely with autopairs
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	-- nvim-cmp (Completion Plugin)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lsp_kind = require("lspkind")

			lsp_kind.init()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end,
					["<S-Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						select = true,
					}),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "path" },
					{ name = "buffer" },
				},
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},

	{
		"David-Kunz/cmp-npm",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = "json",
		config = function()
			require("cmp-npm").setup({
				sources = {
					{ name = "npm", keyword_length = 4 },
				},
			})
		end,
	},

	{
		"willothy/flatten.nvim",
		config = true,
		-- or pass configuration with
		-- opts = {  }
		-- Ensure that it runs first to minimize delay when opening file from terminal
		lazy = false,
		priority = 1001,
		integrations = {
			kitty = true,
		},
		window = {
			open = "current",
		},
	},
	-- TS & React utility plugins
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({
				server = {
					on_attach = on_attach,
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
				},
			})
		end,
	},
}
