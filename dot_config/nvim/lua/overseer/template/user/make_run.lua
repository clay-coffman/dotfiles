-- generic Make Run Template
return {
  name = "Make Run",
  builder = function()
    return {
      cmd = "make",
      args = { "run" },
      strategy = {
        "jobstart",
        use_terminal = true,
        preserve_output = true,
      },
      components = {
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
}
