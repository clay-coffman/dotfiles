return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent_background = true,
      float = {
        transparent = true,
        solid = true,
      },
      flavour = "auto",
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
        auto_integrations = true,
      },
    },
  },
}
