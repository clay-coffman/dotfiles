return {
  "stevearc/overseer.nvim",
  -- Add dependencies to ensure which-key is loaded
  dependencies = {
    "akinsho/toggleterm.nvim",
  },
  opts = {
    templates = { "builtin", "user" }, -- Include user templates
    strategy = {
      "toggleterm",
      use_shell = true,
      close_on_exit = false,
    },
  },
}
