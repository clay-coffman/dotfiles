return {

    -- vim-tmux-navigation
    {
        "alexghergh/nvim-tmux-navigation",
        config = function()
            local nvim_tmux_nav = require("nvim-tmux-navigation")

            nvim_tmux_nav.setup({
                disable_when_zoomed = true, -- defaults to false
            })

            vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end,
    },

    -- notify.nvim
    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 2000
        }
    },

    -- neo-tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                enable_git_status = true,
                enable_diagnostics = true,
                window = {
                    width = 30,
                    mappings = {
                        ["<CR>"] = "open",
                        ["<Tab>"] = "open",
                        ["<C-v>"] = "open_vsplit",
                        ["<C-x>"] = "open_split",
                        ["<C-t>"] = "open_tabnew",
                        ["z"] = "close_node",
                        ["Z"] = "close_all_nodes",
                        ["a"] = "add",
                        ["d"] = "delete",
                        ["r"] = "rename",
                        ["y"] = "copy_to_clipboard",
                        ["x"] = "cut_to_clipboard",
                        ["p"] = "paste_from_clipboard",
                    },
                },
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                    follow_current_file = {
                        enable = true,
                    },
                },
            })
            vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
        end,
    },

    -- oil.nvim - Edit filesystem like a buffer
    {
        "stevearc/oil.nvim",
        dependencies = { "echasnovski/mini.icons" },
        config = function()
            require("oil").setup({
                default_file_explorer = false, -- Keep neo-tree as default, oil as alternative
                columns = {
                    "icon",
                    "permissions",
                    "size",
                },
                view_options = {
                    show_hidden = true,
                    natural_order = "fast",
                    case_insensitive = false,
                },
                float = {
                    padding = 2,
                    max_width = 120,
                    max_height = 40,
                    border = "rounded",
                    preview_split = "right",
                },
                preview_win = {
                    update_on_cursor_moved = true,
                    preview_method = "fast_scratch",
                },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                    ["<C-t>"] = { "actions.select", opts = { tab = true } },
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = { "actions.cd", opts = { scope = "tab" } },
                    ["gs"] = "actions.change_sort",
                    ["gx"] = "actions.open_external",
                    ["g."] = "actions.toggle_hidden",
                    ["g\\"] = "actions.toggle_trash",
                },
                use_default_keymaps = false, -- Use custom keymaps above
            })

            -- Vim-vinegar style mapping
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

            -- Additional oil keymaps with auto-preview
            vim.keymap.set("n", "<leader>o", function()
                require("oil").open_float()
                -- Auto-open preview after a short delay
                vim.defer_fn(function()
                    require("oil").open_preview()
                end, 100)
            end, { desc = "Open Oil in float with preview" })
        end,
    },

    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },

    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-jest",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        runner = "pytest",
                    }),
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                        jestConfigFile = "custom.jest.config.ts",
                        env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                    }),
                },
                status = {
                    enabled = true,
                    virtual_text = true,
                    signs = true,
                },
            })
        end,
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {}, -- add add'l config here
    },

    -- Aerial - Code outline window
    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("aerial").setup({
                backends = { "treesitter", "lsp" },
                layout = {
                    default_direction = "prefer_right",
                    min_width = 20,
                },
                close_on_select = false,
                show_guides = true,
                filter_kind = {
                    "Class",
                    "Constructor",
                    "Enum",
                    "Function",
                    "Interface",
                    "Module",
                    "Method",
                    "Struct",
                },
            })
            vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>", { desc = "Toggle Aerial" })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            preset = "modern",
        },
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15                              -- rows
                elseif term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4) -- cols
                end
                return 20                                  -- fallback
            end,
        },
    },
    {
        -- tim pope obsession to persist sessions
        "tpope/vim-obsession",
        event = "VeryLazy",
    },

    {
        "mistweaverco/kulala.nvim",
        keys = {
            { "<leader>Rs", desc = "Send request" },
            { "<leader>Ra", desc = "Send all requests" },
            { "<leader>Rb", desc = "Open scratchpad" },
        },
        ft = { "http", "rest" },
        opts = {
            -- your configuration comes here
            global_keymaps = false,
            global_keymaps_prefix = "<leader>R",
            kulala_keymaps_prefix = "",
        },
    },

    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            provider = "openrouter",
            providers = {
                openrouter = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    api_key_name = "AVANTE_OPENROUTER_API_KEY",
                    model = "google/gemini-2.5-pro",
                    max_tokens = 1000000,
                },
                -- gemini_flash = {
                --     __inherited_from = 'openai',
                --     endpoint = 'https://openrouter.ai/api/v1',
                --     api_key_name = "AVANTE_OPENROUTER_API_KEY",
                --     model = "google/gemini-2.5-flash",
                --     max_tokens = 1000000,
                -- },

            },

        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            {
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                    },
                },
            },
            {
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
        config = function()
            require("mcphub").setup()
        end
    },
    {
        "olimorris/codecompanion.nvim",
        opts = {
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        make_vars = true,
                        make_slash_commands = true,
                        show_result_in_chat = true
                    }
                }
            },
            strategies = {
                chat = {
                    adapter = "anthropic",
                },
                inline = {
                    adapter = "copilot",
                },
                cmd = {
                    adapter = "deepseek",
                }
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "ravitemer/mcphub.nvim"
        },
    }
}
