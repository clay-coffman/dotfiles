return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",

      on_highlights = function(hl, c)
        -- Make all diagnostic virtual text italic
        hl.DiagnosticVirtualTextError = { fg = c.error, italic = true }
        hl.DiagnosticVirtualTextWarn = { fg = c.warning, italic = true }
        hl.DiagnosticVirtualTextInfo = { fg = c.info, italic = true }
        hl.DiagnosticVirtualTextHint = { fg = c.hint, italic = true }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
