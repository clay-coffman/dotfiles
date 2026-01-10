-- CMake Build Template
return {
  name = "CMake Build",
  builder = function()
    local cwd = vim.fn.getcwd()
    return {
      cmd = { "cmake" },
      args = {
        "--build", "build",
        "--parallel",
      },
      cwd = cwd,
      strategy = {
        "jobstart",
        use_terminal = true,
        preserve_output = true,
      },
      components = {
        { "on_output_quickfix", open = true },
        { "on_exit_set_status" },
        { "on_complete_notify", system = "unfocused" },
      },
    }
  end,
  condition = {
    callback = function()
      return vim.fn.isdirectory("build") == 1
    end,
  },
  tags = { "cmake", "build" },
  desc = "Build CMake project (cmake --build build)",
}
