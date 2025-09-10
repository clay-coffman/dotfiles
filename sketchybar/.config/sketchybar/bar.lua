local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 40,
  color = colors.bar.bg,
  padding_right = 2,
  padding_left = 2,
  topmost = "window", -- Keep bar above all windows
  sticky = "on",      -- Keep visible when switching spaces
  margin = 5,         -- Add margin to prevent overlap
  y_offset = 0,       -- Can adjust this if needed
})
