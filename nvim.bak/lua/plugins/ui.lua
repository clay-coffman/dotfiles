return {
    -- Web Devicons (icons for various plugins)
    "nvim-tree/nvim-web-devicons",

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    theme = "auto",
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 100,
                        tabline = 100,
                        winbar = 100,
                    },
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                return str:sub(1, 1)
                            end,
                        },
                    },
                    lualine_b = {
                        { "filename", path = 1, symbols = { modified = "●", readonly = "" } },
                    },
                    lualine_c = {
                        { "branch", icon = "" },
                        { "diff",   symbols = { added = "+", modified = "~", removed = "-" } },
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                        },
                    },
                    lualine_x = {
                        {
                            function()
                                local clients = vim.lsp.get_clients()
                                if next(clients) == nil then
                                    return ""
                                end
                                local names = {}
                                for _, client in ipairs(clients) do
                                    table.insert(names, client.name)
                                end
                                return table.concat(names, " ")
                            end,
                            icon = "LSP:",
                        },
                    },
                    lualine_y = {
                        { "filetype", colored = true },
                        "progress",
                    },
                    lualine_z = {
                        "ObsessionStatus",
                    },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },

    -- catppuccin theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "auto", -- latte, frappe, macchiato, mocha
                background = {
                    light = "latte",
                    dark = "macchiato",
                },
                transparent_background = false,
                show_end_of_buffer = false, -- show the '~' characters after the end of buffers
                term_colors = true,
                dim_inactive = {
                    enabled = true,
                    shade = "dark",
                    percentage = 0.15,
                },
                no_italic = false,    -- Force no italic
                no_bold = false,      -- Force no bold
                no_underline = false, -- Force no underline
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = { "bold" },
                    keywords = { "bold" },
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                integrations = {
                    aerial = true,
                    cmp = true,
                    dashboard = true,
                    dap = true,
                    dap_ui = true,
                    fzf = true,
                    gitsigns = true,
                    indent_blankline = {
                        enabled = true,
                        scope_color = "",
                        colored_indent_levels = false,
                    },
                    neotree = true,
                    nvimtree = true,
                    telescope = {
                        enabled = true,
                    },
                    notify = true,
                    mini = true,
                    mason = true,
                    markdown = true,
                    render_markdown = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        -- underlines = {
                        -- 	errors = { "underline" },
                        -- 	hints = { "underline" },
                        -- 	warnings = { "underline" },
                        -- 	information = { "underline" },
                        -- },
                        inlay_hints = {
                            background = true,
                        },
                    },
                    treesitter = true,
                    lsp_trouble = true,
                    which_key = true,
                },
            })
            local sign = vim.fn.sign_define

            -- define signs for nvim-dap
            sign("DapBreakpoint", {
                text = "",
                texthl = "DapBreakpoint",
                linehl = "",
                numhl = "",
            })
            sign("DapBreakpointCondition", {
                text = "",
                texthl = "DapBreakpointCondition",
                linehl = "",
                numhl = "",
            })
            sign("DapLogPoint", {
                text = "",
                texthl = "DapLogPoint",
                linehl = "",
                numhl = "",
            })
            sign("DapStopped", {
                text = "",
                texthl = "DapStopped",
                linehl = "",
                numhl = "",
            })
            sign("DapBreakpointRejected", {
                text = "",
                texthl = "DapBreakpointRejected",
                linehl = "",
                numhl = "",
            })

            -- setup must be called before loading
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Indent guides

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            exclude = {
                filetypes = {
                    "help",
                    "notify",
                    "mason",
                    "lazy",
                    "dashboard",
                    "packer",
                    "NvimTree",
                    "Trouble",
                    "TelescopePrompt",
                    "Float",
                },
                buftypes = { "terminal", "prompt", "quickfix", "nofile", "telescope" },
            },
            scope = {
                enabled = true,
                show_start = false,
            },
        },
    },

    -- -- git-signs
    {
        "lewis6991/gitsigns.nvim",
    },

    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("dashboard").setup({
                theme = "hyper",
            })
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ---@module 'render-markdown'
        ft = { "markdown", "copilot-chat", "codecompanion" },
        opts = {
            render_modes = true,
            anti_conceal = {
                enabled = true,
                ignore = { code_background = true, sign = true },
            },
            file_types = { "markdown", "md", "markdown.mdx", "Avante", "copilot-chat", "codecompanion" },
            links = {
                enabled = true,
                conceal = true,
            },
            highlights = {
                heading = "Title",
                bold = "Bold",
                italic = "Italic",
                code = "CursorLine",
            },
        },
    },
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            -- Setup mini.hipatterns for hex color previews
            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({
                -- Define highlights (the default has 'hex_color')
                highlighters = {
                    -- Highlight hex colors (#rrggbb)
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            set_dark_mode = function()
                vim.api.nvim_set_option_value("background", "dark", {})
                vim.cmd.colorscheme("catppuccin")
            end,

            set_light_mode = function()
                vim.api.nvim_set_option_value("background", "light", {})
                vim.cmd.colorscheme("catppuccin")
            end,
            update_interval = 3000,
            fallback = "dark",
        },

        config = function(_, opts)
            require("auto-dark-mode").setup(opts)
            require("auto-dark-mode").init()
        end,
    },

    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },
    { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' }
}
