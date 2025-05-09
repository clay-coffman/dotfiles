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
			require("mason-lspconfig").setup({})
		end,
	},

	-- nvim-lspconfig for configuring LSPs
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- clients should ONLY use utf-16 for position encoding
			capabilities.offsetEncoding = { "utf-16" }

			local lspconfig = require("lspconfig")

			-- Define on_attach() (for diagnostics)
			local on_attach = function(client, bufnr)
				if client.name == "texlab" then
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

			-- LSP servers
			local servers = { "pyright", "ruff", "clangd", "lua_ls", "texlab" }

			-- Loop through the servers and set them up
			for _, server_name in ipairs(servers) do
				local server_opts = {
					on_attach = on_attach, -- Use the common on_attach
					capabilities = capabilities, -- Use the common capabilities
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
								},
							},
						},
					})
				end
				-- Add other 'if server_name == "..." then' blocks here for other
				-- servers that need unique settings beyond on_attach/capabilities

				-- Set up the server using the combined options
				lspconfig[server_name].setup(server_opts)
			end
		end,
	},
	--Formatting with conform
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		config = function()
			local conform = require("conform")
			conform.setup({
				default_format_opts = {
					lsp_fallback = "false",
				},
				format_on_save = {
					timeout_ms = 3000,
					lsp_format = "false",
				},
				formatters_by_ft = {
					c = { "clang-format" },
					lua = { "stylua" },
					python = { "docformatter", "black" },
					tex = { "latexindent" },
				},
				formatters = {
					["clang-format"] = {
						command = "clang-format",
						prepend_args = { "--style=Google" },
					},
				},
			})
		end,

		keys = {
			{
				"<leader>gf",
				function()
					require("conform").format({ async = true })
				end,
				desc = "format buffer",
			},
		},
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
					-- { name = "render-markdown" },
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
}
