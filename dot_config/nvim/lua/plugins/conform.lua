return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        makefile = { "bake" },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        sql = { "sqlfluff" },
      },
    },
  },
}
