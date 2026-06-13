-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- use prettier config file in $HOME
vim.g.lazyvim_prettier_needs_config = true

-- Python: use basedpyright (type-aware nav) + ruff (lint/format) via LazyVim's python extra
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- -- set python path
-- vim.g.python3_host_prog = ''

local opt = vim.opt

-- conceallevel relevant for markdown
opt.conceallevel = 2

-- number of spaces tabs count for
opt.tabstop = 2

-- disables dashes for spaces
opt.list = false

--  set hard wrap at 80
opt.textwidth = 80

-- hard wrap
opt.wrap = true

-- wrap at word boundaries
opt.linebreak = true

-- Called by the Claude Code PostToolUse hook (~/.claude/hooks/nvim-reload.sh).
-- Reloads buffers CC changed and, if a Diffview tab is open, refreshes it so the
-- diff updates live as CC writes. Invoked via <Cmd> so it never disturbs the
-- editor mode (safe even mid-insert). Defined here (eager) rather than in
-- autocmds.lua (VeryLazy) so the hook can find it the moment nvim is listening.
function _G.cc_reload()
  vim.cmd("checktime")
  local ok, lib = pcall(require, "diffview.lib")
  if ok and lib.get_current_view() then
    vim.cmd("DiffviewRefresh")
  end
end

-- Listen on a stable RPC socket so that hook (running in a sibling pane of the
-- same tmux window) can reach us. Keyed on tmux window_id: shared by both panes
-- and stable across window renumbering. No-op outside tmux; pcall swallows a
-- collision if a second nvim in the same window already owns the socket.
do
  local pane = vim.env.TMUX_PANE
  if vim.env.TMUX and pane then
    local win = vim.fn.systemlist("tmux display-message -p -t " .. pane .. " '#{window_id}'")[1]
    if win and win ~= "" then
      local rt = vim.env.XDG_RUNTIME_DIR or "/tmp"
      pcall(vim.fn.serverstart, rt .. "/nvim-tmux-" .. win .. ".sock")
    end
  end
end
