# Git Tools Reference

A single place to remember which tool to reach for and how to drive it. Everything below is already installed and configured.

---

## Decision table — "which tool when"

| I want to… | Reach for |
|---|---|
| Read a diff of uncommitted changes | nvim → `<leader>gd` (diffview) |
| Read a diff of my whole branch vs main | nvim → `<leader>gR` |
| Read a diff of the last commit | nvim → `<leader>gl` |
| See a sidebar of just the changed files | nvim → `<leader>ge` (neo-tree git_status) |
| Jump between changed hunks inline | nvim → `]h` / `[h` (gitsigns) |
| Preview a hunk inline / see line blame | nvim → `<leader>ghp` / `<leader>ghb` |
| Stage individual hunks | nvim diffview (`s`) or lazygit (`space`) |
| Review a GitHub PR (browse, comment, approve) | nvim → `<leader>gP` (octo) |
| Squash / reorder / fixup commits (interactive rebase) | `lazygit` |
| Stash management | `lazygit` |
| Cherry-pick or reflog recovery | `lazygit` |
| Commit / amend / push | `lazygit` or plain `git` |
| Open a PR from CLI | `gh pr create` |
| Look at PR status / checks | `gh pr status` / `gh pr checks` |
| Checkout someone's PR locally | `gh pr checkout <num>` |

Rule of thumb: **nvim plugins for reading**, **lazygit for mutating**, **`gh` for GitHub-side actions outside review**.

---

## The tools

### `git`

Plain git. Signing is enabled via 1Password's `op-ssh-sign` (configured in `private_dot_gitconfig.tmpl`). Default branch is `main`. Diff tool is `nvimdiff`.

Nothing special — fall back to it when none of the wrappers help.

### `gh` (GitHub CLI)

Authenticated. Useful outside the nvim review flow:

| Command | What |
|---|---|
| `gh pr create` | Open a PR for the current branch |
| `gh pr status` | PRs assigned, authored, requested-of-me |
| `gh pr checkout <num>` | Check out a PR locally |
| `gh pr checks` | CI status for current PR |
| `gh pr view --web` | Open in browser |
| `gh issue list` | Issues |
| `gh repo clone <owner/repo>` | Clone |
| `gh run watch` | Tail a workflow run |

For *reviewing* PRs prefer `octo.nvim` (below). For *opening* PRs and *checking CI* prefer `gh`.

### `lazygit`

TUI for everything git mutates. Launch with `lazygit` in any repo. Cheat sheet for the keys you'll actually use:

| Key | Action |
|---|---|
| `space` | Stage/unstage file or hunk |
| `c` | Commit (opens editor) |
| `A` | Amend last commit |
| `P` | Push |
| `p` | Pull |
| `s` | Stash |
| `f` | Fetch |
| `r` (on a commit) | Reword |
| `s` (on a commit) | Squash into commit below |
| `f` (on a commit) | Fixup into commit below |
| `e` (on a commit) | Edit (interactive rebase stop) |
| `d` (on a commit) | Drop |
| `g` | Cherry-pick menu |
| `?` | Help (always) |

Panels: `1`-`5` (files, branches, commits, stash, status). `[` / `]` cycles panels.

### `octo.nvim` — GitHub PR review in nvim

Uses your `gh` auth. Driven by `:Octo …` commands.

| Keymap / cmd | Action |
|---|---|
| `<leader>gP` | List PRs (fzf picker) |
| `<leader>gI` | List issues |
| `<leader>gS` | Search |
| `:Octo pr checkout` | Check out the current PR |
| `:Octo pr diff` | Open PR diff in diffview |
| `:Octo review start` | Begin a review session (required before line comments) |
| `<space>ca` | Add comment on selection (visual mode in review) |
| `<space>sa` | Add suggestion on selection |
| `]t` / `[t` | Next / prev review thread |
| `:Octo review submit` | Approve / comment / request changes |
| `:Octo thread resolve` | Resolve thread |
| `:Octo pr merge squash` | Squash-merge |

See `:h octo-mappings` for the full table. Defaults live under `<space>` (leader) + `c|r|p|i|s` (comment, reaction, pr, issue, suggestion).

### `diffview.nvim` — diffs and history in nvim

| Keymap | Action |
|---|---|
| `<leader>gd` | Open diff of uncommitted changes |
| `<leader>gD` | Close diffview |
| `<leader>gf` | File history for current file |
| `<leader>gF` | File history for the repo |
| `<leader>gb` | Branch vs HEAD (prompts for base; defaults to `origin/HEAD`) |
| `<leader>gR` | Branch vs `origin/HEAD` (no prompt — quick variant) |
| `<leader>gl` | Last commit (`HEAD~1`) |

Inside diffview:

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / prev file |
| `g<C-x>` | Toggle side-by-side ↔ inline |
| `-` | Stage file |
| `s` | Stage hunk |
| `S` | Stage all |
| `U` | Unstage all |
| `]x` / `[x` | Next / prev merge conflict |

### `gitsigns.nvim` — inline git info (already loaded by LazyVim)

| Key | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame current line |
| `<leader>ghs` | Stage hunk |
| `<leader>ghu` | Undo stage |
| `<leader>ghr` | Reset hunk |
| `<leader>ghd` | Diff against index |

Signs in the gutter (custom — every change type is visible):

| Glyph | Meaning |
|---|---|
| `┃` | Added or changed line |
| `▁` | Deletion *below* this line |
| `▔` | Deletion *above* this line (topdelete) |
| `~` | Add+delete on the same line (changedelete) |
| `┆` | Untracked file |

### `neo-tree` — file explorer (git-aware)

Not strictly a git tool, but its `git_status` source is useful for review:

| Keymap | Action |
|---|---|
| `<leader>e` | Toggle neo-tree at project root |
| `<leader>E` | Toggle neo-tree at cwd |
| `<leader>ge` | Toggle neo-tree showing **only changed files** (git_status source) |

In the normal tree, files get `M` / `A` / `?` badges next to their names so you can see at a glance what's modified.

---

## Workflows

### A. Reviewing local changes (uncommitted, staged, recent commits, or full branch)

Whether the changes are yours or were generated by Claude Code / Codex:

| Step | What | Keys / cmd |
|---|---|---|
| 1. Spot changes inline while reading | gitsigns sign column flags modified lines | `]h` / `[h` to jump, `<leader>ghp` to preview |
| 2. See *which files* changed | Neo-tree git_status sidebar — quick overview before diving in | `<leader>ge` |
| 3. Pick the scope | What do I want to see all at once? | `<leader>gd` uncommitted · `<leader>gl` last commit · `<leader>gR` branch vs main · `<leader>gb` branch vs custom base |
| 4. Walk the diff | File panel left, diff right | `<Tab>` next file · `g<C-x>` toggle layout |
| 5. Accept/reject hunks (uncommitted only) | Stage what's good, discard the rest | `-` / `s` in diffview, or `space` in lazygit |
| 6. Sanity check | Trouble for LSP diagnostics across the change | `<leader>xx` |
| 7. Commit | | `lazygit` (`c`) or `git commit` |

**Mental model**: `<leader>gd` is *"show me what's pending"*; `<leader>gR` is *"show me what this branch did"*. Everything else is a variant of those two.

### B. Reviewing a GitHub PR

| Step | What | Keys / cmd |
|---|---|---|
| 1. Browse open PRs | fzf-lua picker | `<leader>gP` |
| 2. Open a PR | Description + threads in an nvim buffer | `<CR>` on the picked PR |
| 3. Check it out locally | If you want LSP / running tests | `:Octo pr checkout` |
| 4. View the full diff | Reuses diffview against the PR base | `:Octo pr diff` |
| 5. Start review session | Required before line comments stick | `:Octo review start` |
| 6. Comment on lines | Visual-select range in the diff | `<space>ca` comment · `<space>sa` suggestion |
| 7. Navigate existing threads | They appear as virtual lines next to the diff | `]t` / `[t` |
| 8. Submit verdict | Approve / comment / request changes | `:Octo review submit` |
| 9. Merge (if maintainer) | | `:Octo pr merge squash` |

---

## Things deliberately NOT installed

- **neogit** — interactive git UI; overlaps too much with lazygit.
- **fugitive.vim** — overlaps with diffview + gitsigns + lazygit.
- **gh.nvim** — octo is the more polished GitHub plugin.
- **mini.diff** — gitsigns covers it.

If you find a gap that none of the above fills, that's the signal to consider one of these.
