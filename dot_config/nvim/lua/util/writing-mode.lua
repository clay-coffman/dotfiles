local M = {}
M.writing_active = false

function M.toggle()
  if M.writing_active then
    Snacks.zen()
    M.writing_active = false
  else
    M.writing_active = true
    Snacks.zen({
      toggles = { dim = true, git_signs = false, diagnostics = false, inlay_hints = false },
      center = true,
      show = { statusline = true, tabline = false },
      win = {
        style = "zen",
        width = 120,
        wo = { number = false, relativenumber = false },
      },
      on_open = function(win)
        vim.cmd("SoftPencil")
        local wo = vim.wo[win.win]
        wo.spell = true
        wo.spelllang = "en_us"
        wo.cursorline = true
        wo.signcolumn = "no"
        wo.foldcolumn = "0"
        vim.opt_local.scrolloff = 8
        vim.opt_local.textwidth = 0
      end,
      on_close = function()
        vim.cmd("NoPencil")
        M.writing_active = false
      end,
    })
  end
end

return M
