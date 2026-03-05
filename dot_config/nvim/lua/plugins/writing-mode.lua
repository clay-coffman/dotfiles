return {
  {
    "preservim/vim-pencil",
    cmd = { "SoftPencil", "HardPencil", "NoPencil", "TogglePencil" },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>uW",
        function()
          require("util.writing-mode").toggle()
        end,
        desc = "Toggle Writing Mode",
      },
    },
  },
}
