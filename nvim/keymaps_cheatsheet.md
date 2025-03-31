# Neovim Keymap Cheat Sheet

## General Navigation / Window / Buffer Management

* `<C-h>`: Navigate Left (Tmux/Nvim Integration) [cite: 7]
* `<C-k>`: Navigate Up (Tmux/Nvim Integration) [cite: 7]
* `<C-l>`: Navigate Right (Tmux/Nvim Integration) [cite: 7]
* `<C-\>`: Navigate Last Active (Tmux/Nvim Integration) [cite: 7]
* `<C-Space>`: Navigate Next Pane (Tmux/Nvim Integration) [cite: 7]
* `<leader>bd`: Close current buffer (`:bd`) [cite: 14]
* `<leader>bn`: Go to next buffer (`:bnext`) [cite: 14]
* `<leader>bp`: Go to previous buffer (`:bprevious`) [cite: 14]
* `<leader>w`: Save file (`:w`) [cite: 14]
* `<leader>e`: Toggle Neo-tree file explorer [cite: 7]

## Editing / Formatting

* `<leader>h`: Toggle search highlight off (`:nohlsearch`) [cite: 14]
* `<leader>d` (Normal Mode): Delete without yanking (`"_d`) [cite: 14]
* `<leader>d` (Visual Mode): Delete without yanking (`"_d`) [cite: 14]
* `<C-a>` (Normal Mode): Select all (`gg<S-v>G`) [cite: 14]
* `<leader>gf`: Format buffer (using Conform -> Black for Python) [cite: 18]

## Searching / Finding (Telescope)

* `<leader>ff`: Find files [cite: 1]
* `<leader>fg`: Live grep (search file contents) [cite: 1]
* `<leader>fb`: Find open buffers [cite: 1]
* `<leader>fh`: Search help tags [cite: 1]
* `<leader>ft`: Find TODO comments (`:TodoTelescope`) [cite: 16]
* `<C-h>` (Insert Mode in Telescope): Show keymap help (which_key) [cite: 1]

## LSP (Language Server Protocol) Features

*These assume you added them to your `on_attach` function as recommended.*
* `K` (Normal Mode): Show Hover Information (types, docs)
* `gd` (Normal Mode): Go to Definition
* `gr` (Normal Mode): Find References
* `gi` (Normal Mode): Go to Implementation
* `<leader>ca` (Normal Mode): Show Code Actions (for refactoring, fixing warnings)
* `<leader>rn` (Normal Mode): Rename symbol under cursor

## Diagnostics (Errors/Warnings)

* `<C-j>` (Normal Mode): Go to Next Diagnostic (Cursor move only) [cite: 14] - *NOTE: This conflicts with your Tmux Down navigation.* You may need to remap one of these.
* `<leader>d` (Normal Mode): Show diagnostic message popup for line under cursor (*Assumes you added this*)
* `<leader>xx`: Toggle Trouble panel for all diagnostics [cite: 9]
* `<leader>xX`: Toggle Trouble panel for current buffer diagnostics [cite: 9]
* `<leader>xL`: Toggle Trouble panel for Location List [cite: 9]
* `<leader>xQ`: Toggle Trouble panel for Quickfix List [cite: 9]

## Testing (Neotest)

* `<leader>tn`: Run nearest test [cite: 14]
* `<leader>tf`: Run tests in current file [cite: 15]
* `<leader>td`: Debug nearest test (Requires DAP setup) [cite: 15]
* `<leader>ts`: Stop Neotest run [cite: 15]
* `<leader>to`: Show Neotest output panel [cite: 15]
* `<leader>tS`: Toggle Neotest summary window [cite: 15]

## Debugging (DAP)

*These assume you added the DAP configuration successfully.*
* `<F5>`: Continue execution
* `<F10>`: Step Over
* `<F11>`: Step Into
* `<F12>`: Step Out
* `<leader>b`: Toggle breakpoint
* `<leader>B`: Set conditional breakpoint (prompts for condition)
* `<leader>lp`: Set log point (prompts for message)
* `<leader>dr`: Open DAP REPL
* `<leader>dl`: Run last DAP configuration
* `<leader>du`: Toggle DAP UI
* `<leader>de` (Normal/Visual): Evaluate expression under cursor / visual selection

## Code Outline / Symbols

* `{` (Normal Mode): Go to previous code block/symbol (Aerial) [cite: 7]
* `}` (Normal Mode): Go to next code block/symbol (Aerial) [cite: 7]
* `<leader>a`: Toggle Aerial code outline panel [cite: 7]
* `<leader>cs`: Toggle Trouble panel for document/workspace symbols [cite: 9]
* `<leader>cl`: Toggle Trouble panel for LSP definitions, references, etc. [cite: 9]
* `<leader>fd`: Telescope LSP definitions for symbol under cursor [cite: 1]
* `<leader>fs`: Telescope LSP workspace symbols [cite: 1]

## Completion (Insert Mode - nvim-cmp)

* `<C-b>`: Scroll completion documentation up [cite: 17]
* `<C-f>`: Scroll completion documentation down [cite: 17]
* `<C-Space>`: Trigger completion menu [cite: 17]
* `<C-e>`: Abort/close completion menu [cite: 17]
* `<CR>`: Confirm completion (without selecting if menu item not explicitly chosen) [cite: 17]
* `<Tab>`: Select next item in completion menu [cite: 17]
* `<S-Tab>`: Select previous item in completion menu [cite: 17]

## Obsidian

* `<leader>os`: Obsidian Search [cite: 16]
* `<leader>oq`: Obsidian Quick Switch [cite: 16]
* `<leader>ot`: Obsidian Template [cite: 16]
* `<leader>on`: Obsidian New From Template [cite: 16]
* `<leader>od`: Obsidian Today (Daily Note) [cite: 16]
* `<leader>of`: Obsidian Follow Link [cite: 16]
* `<leader>ob`: Obsidian Backlinks [cite: 16]
* `<leader>ch`: Toggle Checkbox (in Markdown buffer) [cite: 12]
* `gf`: Follow link under cursor (Obsidian enhanced) [cite: 12]
* `<CR>`: Smart action (follow link, toggle checkbox) [cite: 13]

## Miscellaneous

* `<leader>i`: Toggle Inlay Hints (`require("craftzdog.lsp")`) - *NOTE: This might be broken if `craftzdog.lsp` doesn't exist in your config.* [cite: 14]
