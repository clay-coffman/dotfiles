return {
  "f-person/auto-dark-mode.nvim",
  opts = {
    set_dark_mode = function()
      vim.cmd("colorscheme github_dark_high_contrast")
    end,
    set_light_mode = function()
      vim.cmd("colorscheme github_light_high_contrast")
    end,
  },
}
