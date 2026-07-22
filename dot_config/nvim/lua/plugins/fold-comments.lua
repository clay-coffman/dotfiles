-- Fold contiguous blocks of comments longer than 3 lines (>= 4 lines).
-- Implemented as a non-destructive toggle: turning it on swaps the window's
-- foldexpr to a comment-only one and closes the folds; turning it off restores
-- LazyVim's normal treesitter code-folding. Costs nothing while off.

local MIN_LINES = 3 -- a block must be strictly longer than this to fold

local M = {}

-- bufnr -> { tick = changedtick, levels = { [1-indexed lnum] = foldlevel str } }
local cache = {}

local function is_comment(node_type)
  return node_type:find("comment", 1, true) ~= nil
end

-- Collect the set of 1-indexed lines that are inside a comment node.
local function comment_lines(bufnr)
  local lines = {}
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return lines
  end

  local function walk(node)
    if is_comment(node:type()) then
      local sr, _, er, ec = node:range() -- 0-indexed rows
      local last = (ec == 0) and (er - 1) or er -- end col 0 => comment stops on prev line
      for r = sr, last do
        lines[r + 1] = true
      end
      return -- comments hold nothing we care about
    end
    for child in node:iter_children() do
      walk(child)
    end
  end

  for _, tree in ipairs(parser:parse(true)) do
    walk(tree:root())
  end
  return lines
end

-- Build the per-line foldlevel map, marking only runs longer than MIN_LINES.
local function compute(bufnr)
  local levels = {}
  local comment = comment_lines(bufnr)
  local total = vim.api.nvim_buf_line_count(bufnr)

  local run_start = nil
  local function flush(run_end)
    if run_start and (run_end - run_start + 1) > MIN_LINES then
      levels[run_start] = ">1"
      for l = run_start + 1, run_end do
        levels[l] = "1"
      end
    end
    run_start = nil
  end

  for l = 1, total do
    if comment[l] then
      run_start = run_start or l
    elseif run_start then
      flush(l - 1)
    end
  end
  if run_start then
    flush(total)
  end
  return levels
end

-- Our foldexpr, as the literal string vim stores in 'foldexpr'. We detect
-- whether the mode is on by comparing against this, so the toggle can't drift
-- out of sync (module reloads, splits, etc.).
local OUR_EXPR = "v:lua.FoldComments.foldexpr()"

function M.foldexpr()
  local bufnr = vim.api.nvim_get_current_buf()
  local tick = vim.api.nvim_buf_get_changedtick(bufnr)
  local c = cache[bufnr]
  if not c or c.tick ~= tick then
    c = { tick = tick, levels = compute(bufnr) }
    cache[bufnr] = c
  end
  return c.levels[vim.v.lnum] or "0"
end

function M.toggle()
  if vim.wo.foldexpr == OUR_EXPR then
    -- Mode is on -> restore whatever fold setup was active before.
    vim.wo.foldmethod = vim.w.fold_comments_method or "expr"
    vim.wo.foldexpr = vim.w.fold_comments_expr or "v:lua.LazyVim.treesitter.foldexpr()"
    -- Open everything by setting foldlevel directly. zR is unreliable here: it
    -- scans for the deepest fold level, but treesitter hasn't re-parsed yet, so
    -- it would read "0" and leave all code folded once the parse lands.
    vim.wo.foldlevel = vim.w.fold_comments_level or 99
  else
    -- Mode is off -> remember current setup, then fold only comment blocks.
    vim.w.fold_comments_method = vim.wo.foldmethod
    vim.w.fold_comments_expr = vim.wo.foldexpr
    vim.w.fold_comments_level = vim.wo.foldlevel
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = OUR_EXPR
    vim.wo.foldlevel = 0 -- close all folds; our foldexpr only emits comment blocks
    vim.cmd("normal! zx") -- force a fold recompute so they close immediately
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    init = function()
      _G.FoldComments = M
      vim.api.nvim_create_user_command("FoldComments", M.toggle, {
        desc = "Toggle folding of comment blocks >3 lines",
      })
      vim.api.nvim_create_autocmd("BufDelete", {
        callback = function(ev)
          cache[ev.buf] = nil
        end,
      })
    end,
    keys = {
      { "<leader>uC", function() M.toggle() end, desc = "Toggle fold long comment blocks" },
    },
  },
}
