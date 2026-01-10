-- CMake Configure Template
return {
  name = "CMake Configure",
  builder = function()
    local cwd = vim.fn.getcwd()
    return {
      cmd = { "cmake" },
      args = {
        "-B", "build",
        "-DCMAKE_BUILD_TYPE=Debug",
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
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
      return vim.fn.filereadable("CMakeLists.txt") == 1
    end,
  },
  tags = { "cmake", "configure" },
  desc = "Configure CMake project (cmake -B build)",
}
