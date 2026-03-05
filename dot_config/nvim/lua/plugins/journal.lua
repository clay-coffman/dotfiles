return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Auto-enable writing mode for journal files
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "**/journal/**", "*.jrnl", "/tmp/jrnl*" },
        callback = function()
          vim.defer_fn(function()
            local wm = require("util.writing-mode")
            if not wm.writing_active then
              wm.toggle()
            end
          end, 100)
        end,
      })
      return opts
    end,
  },
}
