return {
  -- add gruvbox
  { "altercation/vim-colors-solarized" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized",
    },
  },
}
