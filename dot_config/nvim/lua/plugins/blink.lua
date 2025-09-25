return {
  "saghen/blink.cmp",
  opts = {
    appearance = {
      nerd_font_variant = "normal",
    },
    completion = {
      menu = {
        draw = {
          -- We don't need label_description now because label and label_description are already
          -- combined together in label by colorful-menu.nvim.
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
      -- ghost_text displays preview of selected it on current line
      ghost_text = { enabled = false },
    },

    -- disables completion for strings and comments
    enabled = function()
      local node = vim.treesitter.get_node()
      local filetype = vim.bo.filetype

      -- disable on markdown files
      if vim.tbl_contains({ "markdown" }, filetype) then
        return false
      end

      -- Check if we're in a comment or string using treesitter
      if node then
        local node_type = node:type()
        -- Common node types for comments and strings across languages
        if node_type == "comment" or node_type == "string" or node_type == "string_literal" then
          return false
        end
      end
      return true
    end,
    keymap = {
      preset = "default", -- or "enter" or "super-tab"
      ["<C-Space>"] = { "show" }, -- Changed from <D-c> since that won't work in terminal
      ["<S-CR>"] = { "hide" },
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<PageDown>"] = { "scroll_documentation_down" },
      ["<PageUp>"] = { "scroll_documentation_up" },
    },
  },
}
