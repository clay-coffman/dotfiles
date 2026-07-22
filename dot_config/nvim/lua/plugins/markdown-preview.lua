-- Browser-based markdown preview, bound to <leader>cp (toggle).
--
-- This was previously provided by the LazyVim `lang.markdown` extra, but that
-- lives in lazyvim.json, which is per-machine runtime state and not tracked by
-- chezmoi -- so it silently reset and the keymap disappeared. Declaring the
-- plugin here keeps it version-controlled and synced across machines.
--
-- First run after `chezmoi apply` builds a small Node app:
--   :Lazy build markdown-preview.nvim   (or just let Lazy auto-build on load)
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>cp",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
  config = function()
    vim.cmd([[do FileType]])
  end,
}
