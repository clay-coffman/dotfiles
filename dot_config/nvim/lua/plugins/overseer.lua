return {
  "stevearc/overseer.nvim",
  dependencies = {
    "akinsho/toggleterm.nvim",
    "folke/which-key.nvim",
  },
  opts = {
    templates = { "builtin", "user" }, -- Include user templates
    strategy = {
      "toggleterm",
      use_shell = true,
      close_on_exit = false,
    },
  },

  keys = {
    { "<leader>o", group = "Overseer", desc = "Overseer" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build task" },
    { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer info" },

    -- Quick compile and run for C files (when in a C file)
    {
      "<F5>",
      function()
        vim.cmd("OverseerRun C Build & Run")
      end,
      desc = "Build & Run C",
      ft = "c",
    },

    {
      "<F6>",
      function()
        vim.cmd("OverseerRun C Build")
      end,
      desc = "Build C",
      ft = "c",
    },

    {
      "<F7>",
      function()
        vim.cmd("OverseerRun C Run")
      end,
      desc = "Run C",
      ft = "c",
    },
  },
}
