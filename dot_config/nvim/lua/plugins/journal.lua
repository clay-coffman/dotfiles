return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Auto-enable zen mode for journal files
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "**/journal/**", "*.jrnl", "/tmp/jrnl*" },
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
          vim.defer_fn(function()
            if package.loaded["snacks"] then
              Snacks.zen()
            end
          end, 100)
        end,
      })
      return opts
    end,
  },
}
