return {
    -- Treesitter (better syntax highlighting)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "astro",
                    "c",
                    "cpp",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                    "markdown_inline",
                    "dockerfile",
                    "html",
                    "latex",
                    "java",
                    "javascript",
                    "json",
                    "python",
                    "rust",
                    "sql",
                    "tmux",
                    "typescript",
                    "tsx",
                    "xml",
                    "yaml",
                },
                highlight = { enable = true, disable = { "latex" } },
                indent = {
                    enable = true
                },
                sync_install = false,
                auto_install = true,
                modules = {},
                ignore_install = {},
            })
        end,
    },
    -- ts grammar plugin for astro
    { "virchau13/tree-sitter-astro" },
}
