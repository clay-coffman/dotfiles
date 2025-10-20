return {
  "saghen/blink.cmp",
  opts = {
    -- path completion from cwd instead of current buffer's dir
    -- sources = {
    --   providers = {
    --     path = {
    --       opts = {
    --         get_cwd = function(_)
    --           return vim.fn.getcwd()
    --         end,
    --       },
    --     },
    --   },
    -- },
    appearance = {
      nerd_font_variant = "normal",
    },
    completion = {
      -- if auto_brackets get annoying in tsx/jsx files uncomment this
      -- accept = {
      --   auto_brackets = {
      --     kind_resolution = {
      --       blocked_filetypes = {
      --         "typescriptreact",
      --         "javascriptreact",
      --       },
      --     },
      --   },
      menu = {
        -- delay before showing menu in ms for markdown files
        auto_show_delay_ms = function(ctx, items)
          return vim.bo.filetype == "markdown" and 1000 or 0
        end,
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
      list = { selection = { preselect = false, auto_insert = true } },

      -- ghost_text displays preview of selected it on current line
      ghost_text = { enabled = false },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 2000,
      },
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
      preset = "enter", -- "default" or "enter" or "super-tab"
      -- these are already defined by preset but leaving here for
      -- reference/customization...
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },

      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },
  },
}
