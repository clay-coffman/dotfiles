return {
	-- Lua-scriptable solarized color scheme
	{
		"maxmx03/solarized.nvim",
		opts = {
			palette = "solarized",
			variant = "winter",
			styles = {
				comments = { italic = true },
				keywords = { bold = true },
				functions = { italic = false, bold = true },
				types = { italic = true },
				parameters = { italic = true },
			},
			on_highlights = function(colors, color)
				---@type solarized.highlights
				local groups = {
					SpellBad = { underline = false, strikethrough = false, sp = colors.red, undercurl = true },
					SpellCap = { sp = colors.violet, undercurl = true },
					SpellLocal = { sp = colors.yellow, undercurl = true },
					SpellRare = { sp = colors.cyan, undercurl = true },
				}

				return groups
			end,
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "solarized",
		},
	},
}
