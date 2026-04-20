return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history (current)" },
    { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: file history (repo)" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
  },
}
