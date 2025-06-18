-- Define on_attach() (for diagnostics)
local on_attach = function(client, bufnr)
	if client.name == "texlab" or client.name == "ruff" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
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

-- TS/TSX: organize imports and remove unused on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx" },
	callback = function()
		-- Organize imports
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports.ts" } },
			apply = true,
		})
		-- Remove unused symbols
		vim.lsp.buf.code_action({
			context = { only = { "source.removeUnused" } },
			apply = true,
		})
	end,
})

-- TS/TSX: organize imports and remove unused on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx" },
	callback = function()
		vim.lsp.buf.code_action({ context = { only = { "source.organizeImports.ts" } }, apply = true })
		vim.lsp.buf.code_action({ context = { only = { "source.removeUnused" } }, apply = true })
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

	-- Mason-LSPConfig bridge
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright",
					"lua_ls",
					"bashls",
					"texlab",
					"ruff",
					"ts_ls",
				},
				automatic_enable = false,
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
			local servers = { "pyright", "clangd", "lua_ls", "texlab", "ruff", "ts_ls" }

			-- Loop through the servers and set them up
			for _, server_name in ipairs(servers) do
				local server_opts = {
					on_attach = on_attach,
					capabilities = capabilities,
				}

				-- Add server-specific settings ONLY if needed
				if server_name == "lua_ls" then
					-- Deep merge lua_ls specific settings
					server_opts = vim.tbl_deep_extend("force", server_opts, {
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								telemetry = { enable = false },
							},
						},
					})
				end
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
						lsp_fallback = true,
					}
				end,
			})

			vim.keymap.set("n", "<leader>gf", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format buffer (Conform)" })
		end,
	},

	-- nvim-cmp (Completion Plugin)
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"micangl/cmp-vimtex",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "vimtex" },
					{ name = "path" },
					{ name = "lazydev", group_index = 0 },
				}, {
					{ name = "buffer" },
				}),
			})

			-- Setup cmdline completion for `/` and `?`
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})

			-- Setup cmdline completion for `:`
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
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

	{
		"lervag/vimtex",
		lazy = false, -- Recommended not to lazy-load VimTeX
		-- tag = "v2.15", -- Optionally pin to a specific release
		init = function()
			-- VimTeX configuration goes here BEFORE it loads
			-- Most importantly, set your PDF viewer:
			vim.g.vimtex_view_method = "skim" -- Or 'skim', 'sumatrapdf', etc.

			-- Optional: Enable continuous compilation (uses latexmk)
			vim.g.vimtex_compiler_continuous = 1

			-- Optional: Enable folding if desired (disabled by default)
			-- vim.g.vimtex_fold_enabled = 1

			-- Optional: Configure ignored warnings/errors for quickfix list
			-- vim.g.vimtex_quickfix_ignore_filters = { ... }
		end,
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
		ft = { "javascriptreact", "typescriptreact", "javascript", "typescript" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
				},
			})
		end,
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
		opts = {}, -- your configuration
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},
	{
		"esmuellert/nvim-eslint",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("eslint").setup({
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"vue",
					"astro",
				},
			})
		end,
	},
}
