local function system_uses_dark()
  -- should return whatever the system is using rn
  local ok, output = pcall(vim.fn.system, {
    "gsettings",
    "get",
    "org.gnome.desktop.interface",
    "color-scheme",
  })

  if not ok then
    -- fallback
    return true
  end

  output = (output or ""):gsub("%s+", "")

  if output:match("dark") then
    return true
  end

  return false
end

local function set_theme_based_on_system()
  local dark = system_uses_dark()

  if dark then
    vim.o.background = "dark"
    vim.cmd.colorscheme("github_dark")
  else
    vim.o.background = "light"
    vim.cmd.colorscheme("github_light")
  end
end

return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,
    lazy = false,
    opts = {
      options = {
        darken = {
          sidebars = {
            enable = true,
            list = { "neo-tree" },
          },
        },
        dim_inactive = true,
        inverse = {
          match_paren = true,
          search = true,
        },
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
        transparent = true,
      },
    },
  },
  { "LazyVim/LazyVim", opts = {

    colorscheme = function()
      set_theme_based_on_system()
    end,
  } },
}
