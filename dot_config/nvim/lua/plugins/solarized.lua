return {
  -- add Lua-scriptable solarized color scheme
  {
    "maxmx03/solarized.nvim",
    branch = "main",
    lazy = false,
    name = "solarized",
    main = "solarized",
    priority = 1000,
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
