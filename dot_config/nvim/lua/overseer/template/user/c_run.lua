-- C Run Template (runs already compiled binary)
return {
  name = "C Run",
  builder = function()
    local file_dir = vim.fn.expand("%:p:h") -- Get directory of current file
    local file_base = vim.fn.expand("%:t:r") -- Get base name without extension
    local output_file = file_dir .. "/" .. file_base -- Output executable path
    
    return {
      cmd = { output_file },
      args = {},
      cwd = file_dir,
      strategy = {
        "jobstart",
        use_terminal = true,
        preserve_output = false,
      },
      components = {
        { "open_output", direction = "horizontal", on_start = "always", focus = true }, -- Open output window
        { "on_exit_set_status" },
        { "on_complete_notify", system = "unfocused" },
      },
    }
  end,
  condition = {
    filetype = { "c" }, -- Only show for C files
    callback = function(search)
      -- Check if the compiled binary exists
      local file_base = vim.fn.expand("%:t:r")
      local binary_path = vim.fn.expand("%:p:h") .. "/" .. file_base
      return vim.fn.filereadable(binary_path) == 1
    end,
  },
  tags = { "c", "run" },
  desc = "Run the compiled C executable",
}
