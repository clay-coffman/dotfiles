---@type solarized.styles
local styles = {
  comments = { italic = true, bold = false },
  functions = { italic = true },
  variables = { italic = false },
}

return {
  -- Lua-scriptable solarized color scheme
  {
    "maxmx03/solarized.nvim",
    opts = {
      palette = "solarized",
      variant = "winter",
      styles = {
        styles,
        -- enabled = true,
        -- functions = { bold = true },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized",
    },
  },
}
