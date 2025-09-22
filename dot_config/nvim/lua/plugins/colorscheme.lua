return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      light_style = "day",
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
      -- on_highlights = function(hl, c)
      --   -- Make all diagnostic virtual text italic
      --   hl.DiagnosticVirtualTextError = { fg = c.error, italic = true }
      --   hl.DiagnosticVirtualTextWarn = { fg = c.warning, italic = true }
      --   hl.DiagnosticVirtualTextInfo = { fg = c.info, italic = true }
      --   hl.DiagnosticVirtualTextHint = { fg = c.hint, italic = true }
      -- end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
