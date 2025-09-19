return {
  {
    -- add codecompanion
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    -- for completion. add source to blink
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
  {
    -- for pasting images
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },
}
