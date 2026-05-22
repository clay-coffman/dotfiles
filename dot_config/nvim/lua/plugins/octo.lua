return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    picker = "fzf-lua",
    enable_builtin = true,
    default_merge_method = "squash",
    suppress_missing_scopes = true,
  },
  keys = {
    { "<leader>gP", "<cmd>Octo pr list<cr>", desc = "Octo: PR list" },
    { "<leader>gI", "<cmd>Octo issue list<cr>", desc = "Octo: Issue list" },
    { "<leader>gS", "<cmd>Octo search<cr>", desc = "Octo: Search" },
  },
}
