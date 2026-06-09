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

-- Keep buffers in sync with files Claude Code edits in the sibling tmux pane.
-- LazyVim already runs :checktime on FocusGained; these add BufEnter/CursorHold
-- so an already-focused nvim (e.g. watching a diffview) also notices external
-- writes, and a notification so a change you didn't make is never silent.
vim.opt.autoread = true
local cc = vim.api.nvim_create_augroup("cc_autoreload", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = cc,
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = cc,
  callback = function()
    vim.notify("Reloaded (changed on disk)", vim.log.levels.INFO)
  end,
})
-- (_G.cc_reload, called by the same workflow's CC hook, is defined eagerly in
-- config/options.lua so it's available before this VeryLazy file even loads.)
