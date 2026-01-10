-- CMake Build and Run Template
return {
  name = "CMake Build & Run",
  params = {
    executable = {
      type = "string",
      name = "Executable name",
      desc = "Name of the executable to run (in build/)",
      optional = true,
    },
  },
  builder = function(params)
    local cwd = vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(cwd, ":t")
    local exe = params.executable or project_name

    return {
      cmd = { "sh", "-c" },
      args = {
        string.format(
          "cmake --build build --parallel && echo '\\n=== Build successful, running %s ===' && ./build/%s",
          exe, exe
        ),
      },
      cwd = cwd,
      strategy = {
        "jobstart",
        use_terminal = true,
        preserve_output = true,
      },
      components = {
        { "on_output_quickfix", open = false },
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
  tags = { "cmake", "build", "run" },
  desc = "Build and run CMake project",
}
