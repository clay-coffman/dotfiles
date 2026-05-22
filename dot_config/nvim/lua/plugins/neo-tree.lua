return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("neotree_dir_hijack", { clear = true }),
      desc = "Load Neo-tree when nvim is started on a directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        end
        local stats = vim.uv.fs_stat(vim.fn.argv(0))
        if stats and stats.type == "directory" then
          require("neo-tree")
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
  },
  opts = {
    window = {
      position = "left",
      width = 30,
    },
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          -- '.git',
          -- 'thumbs.db',
          ".DS_Store",
        },
        never_show = {},
        never_show_by_pattern = { -- uses glob style patterns
          ".null-ls_*",
        },
      },
    },
  },
}
