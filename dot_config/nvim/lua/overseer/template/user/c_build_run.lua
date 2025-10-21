-- C Build and Run Template
return {
  name = "C Build & Run",
  builder = function()
    local file = vim.fn.expand("%:p") -- Get full path of current file
    local file_dir = vim.fn.expand("%:p:h") -- Get directory of current file
    local file_base = vim.fn.expand("%:t:r") -- Get base name without extension
    local output_file = file_dir .. "/" .. file_base -- Output executable path
    
    return {
      -- Compile and then run the C file
      cmd = { "sh", "-c" },
      args = {
        string.format(
          "gcc -Wall -Wextra -g '%s' -o '%s' && echo '=== Compilation successful ===' && echo '' && '%s'",
          file,
          output_file,
          output_file
        )
      },
      cwd = file_dir,
      strategy = {
        "toggleterm",
        open_on_start = true,
        close_on_exit = false, -- Keep terminal open to see output
        auto_scroll = true,
      },
      components = {
        { "on_output_quickfix", open = false }, -- Capture compilation errors
        { "on_exit_set_status" },
        { "on_complete_notify", system = "unfocused" },
        { "unique" }, -- Only allow one instance at a time
      },
    }
  end,
  condition = {
    filetype = { "c" }, -- Only show for C files
  },
  tags = { "c", "build", "run" },
  desc = "Compile and run the current C file",
}
