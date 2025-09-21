return {
  "folke/which-key.nvim",
  opts = {
    -- add obsidian group
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>o", group = "obsidian" },
      },
    },
  },
}
