return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettier" },
        yaml = { "prettier" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
}
