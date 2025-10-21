-- C Build Only Template
return {
  name = "C Build",
  builder = function()
    local file = vim.fn.expand("%:p") -- Get full path of current file
    local file_dir = vim.fn.expand("%:p:h") -- Get directory of current file
    local file_base = vim.fn.expand("%:t:r") -- Get base name without extension
    local output_file = file_dir .. "/" .. file_base -- Output executable path
    
    return {
      cmd = { "gcc" },
      args = {
        "-Wall",
        "-Wextra",
        "-g",
        file,
        "-o",
        output_file
      },
      cwd = file_dir,
      strategy = {
        "toggleterm",
        open_on_start = true,
        close_on_exit = true,
        auto_scroll = true,
      },
      components = {
        { "on_output_quickfix", open = true }, -- Open quickfix on errors
        { "on_exit_set_status" },
        { "on_complete_notify", system = "unfocused" },
        { "unique" },
      },
    }
  end,
  condition = {
    filetype = { "c" }, -- Only show for C files
  },
  tags = { "c", "build" },
  desc = "Compile the current C file",
}
