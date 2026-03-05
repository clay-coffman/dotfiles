return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
    },
    sections = {
      lualine_x = {
        {
          function()
            return "Words: " .. vim.fn.wordcount().words
          end,
          cond = function()
            return require("util.writing-mode").writing_active
          end,
        },
      },
    },
  },
}
