return {
  -- add Lua-scriptable solarized color scheme
  {
    "maxmx03/solarized.nvim",
    branch = "main",
    lazy = false,
    name = "solarized",
    main = "solarized",
    priority = 1000,
    opts = {
      styles = {
        enabled = true,
        functions = { bold = true },
      },
      -- Fix transparent backgrounds
      transparent = {
        enabled = false,
        normal = false,
        normalfloat = false,
        neotree = false,
        nvimtree = false,
        whichkey = false,
        telescope = false,
        lazy = false,
      },
    },
    config = function(plugin, opts)
      vim.o.background = "light"
      require(plugin.main).setup(opts)
      vim.cmd.colorscheme = "solarized"

      -- Fix mini.files and other UI backgrounds after colorscheme loads
      local colors = vim.g.solarized_palette
      if colors then
        local bg = colors.base3 -- Light mode background
        local bg_alt = colors.base2 -- Slightly darker for contrast

        -- Fix mini.files background
        vim.cmd(string.format(
          [[
          highlight MiniFilesNormal guibg=%s
          highlight MiniFilesBorder guibg=%s
          highlight MiniFilesTitle guibg=%s
          highlight MiniFilesTitleFocused guibg=%s
          highlight MiniFilesCursorLine guibg=%s
        ]],
          bg,
          bg,
          bg,
          bg,
          bg_alt
        ))

        -- Fix other floating windows
        vim.cmd(string.format(
          [[
          highlight NormalFloat guibg=%s
          highlight FloatBorder guibg=%s guifg=%s
          highlight WinSeparator guibg=NONE guifg=%s
        ]],
          bg,
          bg,
          bg_alt,
          bg_alt
        ))
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized",
    },
  },
}
