return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,
    lazy = false,
    opts = {
      options = {
        darken = {
          sidebars = {
            enable = true,
            list = { "neo-tree" },
          },
        },
        dim_inactive = true,
        inverse = {
          match_paren = true,
          search = true,
        },
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
        transparent = true,
      },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "github_dark" } },
}
