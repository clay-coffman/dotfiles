return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },

	config = function()
		local ls = require("luasnip")

		require("luasnip.loaders.from_vscode").lazy_load({
			include = { "tex", "markdown", "python" },
		})

		ls.filetype_extend("markdown", { "tex" })

		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
			end
		end, { silent = true, desc = "LuaSnip expand / next" })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			if ls.jumpable() then
				ls.jump(-1)
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", true)
			end
		end, { silent = true, desc = "LuaSnip jump back" })
	end,
}
