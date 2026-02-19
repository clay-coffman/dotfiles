return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = { hidden = true },
          files = { hidden = true },
        },
      },
      terminal = {
        win = {
          position = "float",
        },
      },
      zen = {
        ---@type table<string, boolean>
        toggles = {
          dim = true,
          git_signs = false,
          mini_diff_signs = false,
          diagnostics = false,
          inlay_hints = false,
        },
        center = true, -- center the window
        show = {
          statusline = false, -- can only be shown when using the global statusline
          tabline = false,
        },
        ---@type snacks.win.Config
        win = {
          style = "zen",
          wo = {
            number = false,
            relativenumber = false,
          },
        },
        --- Callback when the window is opened.
        ---@param win snacks.win
        on_open = function(win) end,
        --- Callback when the window is closed.
        ---@param win snacks.win
        on_close = function(win) end,
        --- Options for the `Snacks.zen.zoom()`
        ---@type snacks.zen.Config
        zoom = {
          toggles = {},
          center = false,
          show = { statusline = true, tabline = true },
          win = {
            backdrop = false,
            width = 0, -- full width
          },
        },
      },
    },
  },
}
