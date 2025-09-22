return {
  "saghen/blink.cmp",
  opts = {
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
