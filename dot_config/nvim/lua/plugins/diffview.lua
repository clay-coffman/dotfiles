return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history (current)" },
    { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: file history (repo)" },
    {
      "<leader>gb",
      function()
        local default = vim.fn.systemlist("git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null")[1]
        if default then
          default = default:gsub("^origin/", "")
        end
        vim.ui.input({ prompt = "Base branch: ", default = default or "main" }, function(base)
          if base and base ~= "" then
            vim.cmd("DiffviewOpen " .. base .. "...HEAD")
          end
        end)
      end,
      desc = "Diffview: branch vs HEAD",
    },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
  },
}
