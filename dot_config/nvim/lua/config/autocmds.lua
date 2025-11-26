-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

local map = vim.keymap.set

-- C / C++: open C library manpage for symbol under cursor
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    map("n", "gm", function()
      -- Try section 3 (C library) first: man 3 fflush
      local word = vim.fn.expand("<cword>")
      if word and #word > 0 then
        vim.cmd("Man 3 " .. word)
      end
    end, { buffer = true, desc = "Man page for C symbol" })
  end,
})
