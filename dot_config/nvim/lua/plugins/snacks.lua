return {
  {
    "folke/snacks.nvim",
    keys = function(_, keys)
      -- Reclaim explorer keys for neo-tree and git keys for diffview/octo,
      -- which the LazyVim snacks_explorer / snacks_picker extras otherwise claim.
      local strip = {
        "<leader>e", "<leader>E", "<leader>fe", "<leader>fE",
        "<leader>gd", "<leader>gD", "<leader>gf", "<leader>gF",
        "<leader>gb", "<leader>gR", "<leader>gl",
        "<leader>gP", "<leader>gI", "<leader>gS",
      }
      local out = {}
      for _, k in ipairs(keys or {}) do
        local lhs = type(k) == "table" and (k[1] or k.lhs) or k
        if not vim.tbl_contains(strip, lhs) then
          table.insert(out, k)
        end
      end
      return out
    end,
    opts = {
      explorer = { enabled = false },
      picker = {
        sources = {
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
