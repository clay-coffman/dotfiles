return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, c)
        -- Make all diagnostic virtual text italic
        hl.DiagnosticVirtualTextError = { fg = c.error, italic = true }
        hl.DiagnosticVirtualTextWarn = { fg = c.warning, italic = true }
        hl.DiagnosticVirtualTextInfo = { fg = c.info, italic = true }
        hl.DiagnosticVirtualTextHint = { fg = c.hint, italic = true }

        hl.WinSeparator = { fg = c.blue, bold = true }
      end,
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      dim_inactive = true, -- Add this line to dim inactive windows
      colorscheme = "moon",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
