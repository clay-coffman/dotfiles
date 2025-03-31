return {
	-- Treesitter (better syntax highlighting)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				ensure_installed = {
					"c",
					"cpp",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"dockerfile",
					"html",
					"latex",
					"java",
					"javascript",
					"json",
					"python",
					"rust",
					"sql",
					"tmux",
					"typescript",
					"xml",
					"yaml",
				},
				sync_install = false,
				auto_install = true,
				modules = {},
				ignore_install = {},
			})
		end,
	},
}
