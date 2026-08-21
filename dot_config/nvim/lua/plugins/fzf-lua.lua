return {
  {
    "ibhagwan/fzf-lua",
    keys = function(_, keys)
      -- Reclaim git keys for diffview; LazyVim's fzf-lua extra binds these
      -- to FzfLua git_diff / git_commits.
      local strip = { "<leader>gd", "<leader>gl" }
      local out = {}
      for _, k in ipairs(keys or {}) do
        local lhs = type(k) == "table" and (k[1] or k.lhs) or k
        if not vim.tbl_contains(strip, lhs) then
          table.insert(out, k)
        end
      end
      return out
    end,
    opts = function(_, opts)
      local actions = require("fzf-lua").actions
      opts = opts or {}

      opts.oldfiles = vim.tbl_deep_extend("force", opts.oldfiles or {}, {
        -- In Telescope, when I used <leader>fr, it would load old buffers.
        -- fzf lua does the same, but by default buffers visited in the current
        -- session are not included. I use <leader>fr all the time to switch
        -- back to buffers I was just in. If you missed this from Telescope,
        -- give it a try.
        include_current_session = true,
      })

      opts.previewers = opts.previewers or {}
      opts.previewers.builtin = vim.tbl_deep_extend(
        "force",
        opts.previewers.builtin or {},
        {
          -- fzf-lua is very fast, but it really struggled to preview a couple
          -- files in a repo. Those files were very big JavaScript files (1MB,
          -- minified, all on a single line). It turns out it was Treesitter
          -- having trouble parsing the files. With this change, the previewer
          -- will not add syntax highlighting to files larger than 100KB.
          syntax_limit_b = 1024 * 100, -- 100KB
        }
      )

      opts.grep = vim.tbl_deep_extend("force", opts.grep or {}, {
        -- One thing I missed from Telescope was the ability to live_grep and
        -- run a filter on the filenames.
        -- Ex: Find all occurrences of "enable" only in the "plugins" directory.
        -- With this change, I can sort of get the same behaviour in live_grep.
        -- ex: > enable --*/plugins/*
        -- I still find this a bit cumbersome. There's probably a better way.
        rg_glob = true, -- enable glob parsing
        glob_flag = "--iglob", -- case insensitive globs
        glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
      })

      -- Source-controlled dotfiles are useful exploration targets, and the
      -- earlier Snacks picker configuration already opted into them. Start
      -- fzf-lua the same way. Aerospace intercepts Alt-H/Alt-I/Alt-C, so
      -- disable the unreachable inherited aliases. Option-. (dotfiles) and
      -- Option-G (git) replace the visibility toggles; Ctrl-R remains the
      -- reachable root/cwd toggle.
      opts.files = opts.files or {}
      opts.files.hidden = true
      opts.files.actions = vim.tbl_deep_extend(
        "force",
        opts.files.actions or {},
        {
          ["alt-c"] = false,
          ["alt-h"] = false,
          ["alt-i"] = false,
          ["alt-."] = { actions.toggle_hidden },
          ["alt-g"] = { actions.toggle_ignore },
        }
      )
      opts.grep.actions = vim.tbl_deep_extend(
        "force",
        opts.grep.actions or {},
        {
          ["alt-h"] = false,
          ["alt-i"] = false,
          ["alt-."] = { actions.toggle_hidden },
          ["alt-g"] = { actions.toggle_ignore },
        }
      )

      return opts
    end,
  },
}
