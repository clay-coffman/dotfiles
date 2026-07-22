# Claude Code ↔ Neovim diff-review workflow

How I drive Claude Code (CC) and review its output without leaving the terminal.
CC and Neovim live side by side in one tmux window; edits CC makes show up live
in nvim, and I review the accumulated diff there before moving on.

> This file is reference, not a deployed config (`.chezmoiignore` skips `*.md`).
> The behavior it describes is wired up in `dot_tmux.conf.tmpl`,
> `dot_config/nvim/lua/config/{autocmds,options}.lua`, `dot_claude/settings.json.tmpl`,
> and `dot_claude/hooks/executable_nvim-reload.sh`.

---

## The layout

```
┌─ nvim (left) ────────────────┐   ┌─ Claude Code (right) ──────────┐
│ source buffers / diffview     │   │ prompt CC (auto-approve mode)  │
│ <leader>gd → review the diff  │ ◄─┤ CC edits files                 │
│ buffers + diffview refresh    │   │ PostToolUse hook pings nvim    │
│ LIVE as CC writes             │   │                                │
└───────────────────────────────┘   └────────────────────────────────┘
         Ctrl-h / Ctrl-l to hop panes (vim-tmux-navigator)
```

- **Split the window**: tmux prefix is `C-a`. `C-a v` = vertical split (CC beside
  nvim), `C-a s` = horizontal. New panes inherit the current directory.
- **Move between panes**: `Ctrl-h/j/k/l` — vim-tmux-navigator makes this seamless
  across nvim splits *and* tmux panes, so it's one motion whether the next thing
  over is a nvim window or the CC pane.
- **Zoom**: `C-a z` to fullscreen the pane you're in (e.g. blow up the diffview),
  `C-a z` again to restore.

---

## The loop

1. **Prompt CC** in the right pane. CC runs in auto-approve mode
   (`permissions.defaultMode: auto`), so it edits files without stopping to ask.
2. **CC edits.** Each `Edit`/`Write` fires a PostToolUse hook that pokes nvim;
   open buffers reload and an open diffview refreshes **live** — no action needed.
3. **`Ctrl-h` into nvim** and **`<leader>gd`** to review everything uncommitted —
   that diff *is* CC's output for this session.
4. **Decide per change:**
   - Good → move on, prompt the next thing.
   - Needs work → `Ctrl-l` back to CC and refine the prompt.
   - Wrong → revert (below), then re-prompt.

Because edits land automatically, review is **post-hoc on the accumulated diff**.
The safety nets are per-hunk reset in nvim and CC's `/rewind` checkpoints.

---

## Reviewing CC's output (Neovim)

All of these are already configured (`lua/plugins/diffview.lua`); diffview
auto-detects the branch you forked from.

| Keymap | What it shows |
|---|---|
| `<leader>gd` | **Everything uncommitted vs HEAD** — the default "what did CC just do" view |
| `<leader>gR` | The **whole branch vs its fork base** (auto-detected, no prompt) — review a feature end to end |
| `<leader>gb` | Same, but prompt for the base branch first |
| `<leader>gl` | The **last commit** (`HEAD~1`) |
| `<leader>gf` | File history of the current file |
| `<leader>gF` | File history of the whole repo |
| `<leader>gD` | Close diffview |

Inside diffview:
- The **file panel** (left) lists every changed file. `<Tab>` / `Shift-Tab` cycle
  through them; `Enter` opens the one under the cursor.
- `g?` shows diffview's own keymap help.
- Per-repo base override (for `<leader>gR`/`<leader>gb`): `git config diffview.base <branch>`.

### Editing while you review (the PR-review loop)

All `DiffviewOpen` views run with `--imply-local` (set via `default_args` in
`lua/plugins/diffview.lua`): when a range ends at `HEAD` — as in the
`<leader>gb`/`<leader>gR` branch views — the right-hand side of each diff is the
**actual working-tree file**, not a read-only git blob. So the review loop is:

1. Spot a line you don't like → edit it **right in the diff pane** → `:w`.
   The diff refreshes in place, LSP and gitsigns work as usual.
2. Commit + push from the CC/shell pane. The view is `base...HEAD`, so
   committing doesn't change what it shows — nothing to reopen.
3. Need more context than the diff pane? `gf` opens the real file in the
   previous tabpage, `<C-w>gf` in a new tab, `<C-w><C-f>` in a split.

Because the right side is a real buffer, diffview would normally add every file
you `<Tab>` through to the buffer list — flooding the bufferline with "tabs". A
pair of hooks in `diffview.lua` prevents that: buffers the view pulls in itself
are unlisted; anything you already had open stays in the bufferline.

Caveat: with `--imply-local` the branch views really show "merge-base vs. what's
on disk" — saved-but-uncommitted edits appear immediately. That's the point, but
to review *only* committed state, run `:DiffviewOpen <base>...HEAD` by hand
without the flag.

### Spot-checking and reverting inline (gitsigns)

For quick line-level review without opening the full diffview — and to **reject
individual changes** CC made:

| Keymap | Action |
|---|---|
| `]h` / `[h` | Jump to next / previous changed hunk |
| `<leader>ghp` | Preview the hunk under the cursor inline |
| `<leader>ghr` | **Reset the hunk** — discards that one change CC made |
| `<leader>ghs` | Stage the hunk |
| `<leader>ghb` | Blame the current line |

The gutter signs (`┃` add/change, `▁` delete, `┆` untracked) flag changed lines
as you scroll.

### Reverting larger swaths

- **`git restore <file>`** / `git restore -p` — drop a whole file or pick hunks.
- **CC `/rewind`** (in the CC pane) — restores code to an automatic checkpoint
  taken at each prompt; checkpoints persist ~30 days. It restores *files*, but
  **cannot undo shell side effects** (installs, `git push`, migrations) — use git
  for those.

---

## Why nvim stays in sync (the plumbing)

- **`set -s extended-keys on` + `terminal-features 'xterm*:extkeys'`** (tmux) —
  lets Shift+Enter insert a newline in CC's prompt while inside tmux. (`C-j` and
  `\`+Enter` also insert newlines anywhere.)
- **`focus-events on`** (tmux, already set) + LazyVim's `checktime`-on-`FocusGained`
  autocmd — switching *into* the nvim pane reloads anything CC changed.
- **`cc_autoreload` autocmds** (`lua/config/autocmds.lua`) — add `BufEnter` /
  `CursorHold` so an *already-focused* nvim notices external writes too, and
  notify on reload so a surprise change is never silent.
- **Push reload** — nvim listens on `$XDG_RUNTIME_DIR/nvim-tmux-<window_id>.sock`
  (`lua/config/options.lua`); the CC PostToolUse hook
  (`~/.claude/hooks/nvim-reload.sh`) sends `<Cmd>lua cc_reload()<CR>` to it after
  every edit. `cc_reload()` runs `:checktime` and refreshes diffview if open, so
  the diff updates the instant CC writes — even while you're typing in nvim.

The hook is keyed on the tmux `window_id` shared by the CC and nvim panes, and is
an inert no-op outside tmux or when no nvim is listening — safe on every machine.

---

## Claude Code ergonomics

- **Vim editing in the prompt**: `editorMode: "vim"` — `Esc` for normal mode,
  `hjkl` / `v` / `d` / `c` / `y` + text objects. (Enter still submits in insert
  mode; use `o`/`O` or `C-j` for a newline.)
- **Know when CC is done**: Ghostty surfaces CC's finish/permission notifications
  as native desktop notifications with no setup. For a sound, add a `Notification`
  hook, e.g. `afplay /System/Library/Sounds/Glass.aiff`.
- **Theme**: CC, tmux, Ghostty, bat, and nvim all follow the macOS light/dark
  setting, so the split matches end to end.

---

## Alternatives considered (and why I stayed config-only)

- **[`coder/claudecode.nvim`](https://github.com/coder/claudecode.nvim)** — runs
  CC *inside* nvim with native, pre-write accept/reject diffs (Cursor-style) over
  the same WebSocket/MCP protocol as the VS Code extension; depends on snacks.nvim
  (already installed). Genuinely good, but it wants nvim to own the Claude
  terminal, which trades away the two-pane layout I prefer. Revisit if I want
  inline accept/reject before edits hit disk.
- **[`folke/sidekick.nvim`](https://github.com/folke/sidekick.nvim)** — AI-CLI
  terminal + "next edit suggestions," but NES needs a Copilot LSP subscription I
  don't use, and its CLI integration overlaps what the two-pane setup already does.

The config-only path above needs no new plugins and keeps the workflow I already
know — it just makes diffview update itself as CC works.
