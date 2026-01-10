return {
  "stevearc/overseer.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  opts = {
    templates = { "builtin", "user" },
    strategy = {
      "jobstart",
      use_terminal = true,
      preserve_output = false,
    },
    task_list = {
      direction = "bottom",
      min_height = 15,
      max_height = 25,
      default_detail = 1,
      bindings = {
        q = "Close",
        ["<cr>"] = "Open",
        o = "Open",
        ["<C-s>"] = "OpenSplit",
        ["<C-v>"] = "OpenVSplit",
        ["<C-f>"] = "OpenFloat",
      },
    },
  },

  keys = {
    { "<leader>o", group = "Overseer", desc = "Overseer" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build task" },
    { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer info" },
    { "<leader>oc", "<cmd>OverseerClose<cr>", desc = "Close Overseer output" },
  },
}
