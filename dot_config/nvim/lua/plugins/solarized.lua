return {
  -- Lua-scriptable solarized color scheme
  {
    "maxmx03/solarized.nvim",
    opts = {
      palette = "solarized",
      variant = "winter",
      styles = {
        enabled = true,
        functions = { bold = true },
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
