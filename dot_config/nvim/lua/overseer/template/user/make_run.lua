-- generic Make Run Template
return {
  name = "Make Run (Interactive)",
  builder = function()
    return {
      cmd = "make",
      args = { "run" },
      strategy = {
        "toggleterm",
        open_on_start = true,
        close_on_exit = true,
        auto_scroll = true,
      },
      components = {
        { "display_duration", detail_level = 2 },
        { "on_exit_set_status" },
        { "on_complete_notify", system = "unfocused" },
        { "on_complete_dispose", timeout = 30 },
      },
    }
  end,
  condition = {
    -- only show if Makefile exists and has a 'run' target
    callback = function(search)
      local makefile = vim.fn.findfile("Makefile", search.dir)
      if makefile == "" then
        return false
      end
      -- check if Makefile has a run target
      local content = vim.fn.readfile(makefile)
      for _, line in ipairs(content) do
        if line:match("^run:") then
          return true
        end
      end
      return false
    end,
  },
  tags = { "make", "interactive", "run" },
  desc = "Run 'make run' interactively",
}
