# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

`AGENTS.md` in this repo is a symlink to this file, so Codex and Cursor read the
same text. Claude Code does not read `AGENTS.md`, and the other two do not read
`CLAUDE.md`, so the symlink is what keeps one document in front of all three.
Where a section is specifically about Claude Code, the surrounding rule almost
always still applies to whichever agent is reading it. Edit `CLAUDE.md`; never
replace the symlink with a second copy.

## What This Is

Chezmoi-managed dotfiles for Clay Coffman, targeting two daily-driver macOS MacBooks (one work, one personal) plus a couple of Fedora KDE/Wayland remote dev hosts.
Repository: https://github.com/clay-coffman/dotfiles.git (public)

## Critical Rule

**Never edit deployed files directly** (e.g., `~/.zshrc`, `~/.config/nvim/init.lua`).
Always edit the source files here in `~/.local/share/chezmoi/`, then run `chezmoi apply` to deploy.

## Machine detection

Per-machine values are derived at `chezmoi init` time by `.chezmoi.toml.tmpl`, which writes them to `~/.config/chezmoi/chezmoi.toml`. Detection is hostname-based: any short hostname listed in the inline `$workHosts` list **in `.chezmoi.toml.tmpl` itself** is treated as a work Mac; anything else is personal. It is NOT in `.chezmoidata.yaml` — those files are not loaded when the config template renders, so a hostname added there is silently ignored and the machine comes up `personal`.

Available data fields:
- `.role` — `"work"` or `"personal"`
- `.work` — boolean, same info
- `.email` — `clay@carepilot.com` on work, `claymcoffman@gmail.com` on personal
- `.op_account` — `carepilot.1password.com` on work, `my.1password.com` on personal
- `.gh_user` — `clay-coffman` (single GitHub account, two verified emails)
- `.hostname` — short hostname

After hostname changes or onboarding a new work Mac, re-run `chezmoi init` to refresh the resolved data.

## 1Password routing

Default `onepasswordRead` calls use whichever 1P account is signed in. To pin a lookup to a specific account regardless of which Mac is rendering, pass the account as the second arg:

```
{{ onepasswordRead "op://Employee/work ssh config/notesPlain" "carepilot.1password.com" }}
```

The work Mac has both `carepilot.1password.com` and `my.1password.com` signed in. The personal Mac will normally only need `my.1password.com`.

## Secrets

**Never `export` a secret from a shell config file.** Not from
`private_dot_zshrc.tmpl`, not from `dot_bashrc`, `dot_bash_profile`, or
`dot_profile`, and not from any other template that renders into `$HOME`.

The reason is specific to this repo. `onepasswordRead` runs when you run
`chezmoi apply`, not when the shell starts, so a line like

```
export SOME_API_KEY="{{ onepasswordRead "op://Private/Thing/credential" }}"
```

renders the literal secret into the deployed file. That buys you two standing
exposures instead of none. The value sits in cleartext on disk, where a
file-read tool reaches it without running a single command and no
command-blocking rule ever sees it. And because it is exported, every process
the shell starts inherits a copy, so anything that prints the environment leaks
it. That is exactly how `CONTEXT7_API_KEY` and `LINEAR_API_KEY` ended up in an
agent transcript in August 2026.

### The pattern to use instead

Define a function that fetches the value on demand, and hand it to the one
command that needs it:

```zsh
linear-key() {
    op read --no-newline --account my.1password.com \
        "op://Private/dxwwjmbvipibzfn7qjxntfu6jm/password"
}
```

```bash
LINEAR_API_KEY="$(linear-key)" scripts/integrate-project.sh "<Project Name>"
```

Defining a function costs nothing at shell start and raises no unlock prompt, so
this is free until you actually use it. The secret then exists only inside one
short-lived command substitution, and each use becomes an explicit Touch ID
authorization rather than an ambient inheritance.

### Why not `op run`

`op run` resolves `op://` references into a child process's environment, and it
is the right tool in CI or for a one-off command. It is the wrong tool for
anything that starts automatically here. 1Password's app-integration
authorization is scoped to the TTY — the session credential is an ID derived
from the current `tty` plus its start time. It expires after 10 minutes of
inactivity with a hard 12-hour cap. A new tmux pane is therefore a new
authorization. Wrapping a long-running process such as an MCP server in `op run`
means a Touch ID prompt every single time you open a pane and start an agent,
which is unusable on a machine that runs 3–4 concurrent agent panes.

### Never pass a secret as a command-line argument

Arguments are visible in the process table, so `ps` exposes them to anything
running as this user, including agents that list processes for entirely innocent
reasons. Environment variables at least have to be asked for; arguments leak to
casual observation. When a tool accepts both a `--api-key` flag and an
environment variable, use the variable and set it only on the invoking command.
The deleted `dot_config/mcp/base-servers.json.tmpl` got this wrong.

### Removing an export is not enough on a live machine

Deleting the `export` and re-applying only fixes shells started from then on. A
running tmux server keeps its own copy of the global environment and seeds every
newly created pane from it, so the variable survives the edit and keeps
appearing in fresh panes indefinitely. This is unlike `PATH`, which
`private_dot_zshrc.tmpl` rebuilds from scratch on every shell start, so its
stale copy is harmless. Nothing rebuilds a secret.

Clear it in place rather than killing the server, which would take all your
sessions with it:

```bash
tmux set-environment -gu SOME_API_KEY
```

Processes that are already running keep their inherited copy until they restart.
That is one more reason rotation is the real fix and removal is only the
cleanup.

### Checklist for adding a new credential

1. Store it in 1Password and note its `op://` reference. Pin the account with
   `--account` when it matters which one — see
   [1Password routing](#1password-routing).
2. Add a `<name>-key` accessor function to the "Custom Aliases & Functions"
   section of `private_dot_zshrc.tmpl`. Do **not** add an `export` at the top of
   the file.
3. Pass it per command as `VAR="$(<name>-key)" the-command`.
4. If a long-running process needs it at startup and genuinely cannot be given
   it per invocation, raise that as a design question rather than exporting it.
   There is no settled pattern for that case yet, and the right answer depends
   on how much a prompt at start time actually costs.
5. Never write a secret value into a file in this repo at all. Everything here
   is published to a public `origin`, and a `.chezmoiignore` entry does not stop
   that — see [The public-repo rule](#the-public-repo-rule).

## Cross-machine sync (private hub on cloud-hil-1)

The two Macs auto-sync this repo through a **private bare repo on the Hetzner box** (`cloud-hil-1:/home/git/chezmoi.git`, git remote `hub`), so edits propagate without manual commit/push/pull. The public GitHub `origin` is only ever updated by a manual, secret-scanned publish step. Hub server details live in `~/Dev/hetzner/SERVER.md`.

- **`chezmoi-sync`** (`dot_local/bin/executable_chezmoi-sync`) runs every 30 min and at login via launchd (`com.clay.chezmoi-sync`): commits local edits (unsigned), rebases onto `hub/main`, pushes to `hub`, then best-effort `chezmoi apply` (skipped when 1Password is locked/unavailable). It talks ONLY to `hub`, never to `origin`. On a rebase conflict it aborts and notifies — resolve manually in `~/.local/share/chezmoi`, then re-run `chezmoi-sync`. Logs to `~/Library/Logs/chezmoi-sync.log`.
- **`dotfiles-publish`** is the ONLY path that writes to the public repo: fetches, shows the `origin/main..HEAD` diff, runs a fail-closed `gitleaks` scan, prompts, then does a signed push to `origin`.
- **`dotfiles-publish-check`** + `com.clay.dotfiles-publish-nudge` (weekly) fire a notification when `hub` is ahead of `origin`, nudging you to publish.

**Auth:** a dedicated passphrase-less key (`~/.ssh/chezmoi_sync_ed25519`, per-machine, untracked — see `.chezmoiignore`) authenticates to `hub` via the `chezmoi-hub` SSH alias (defined above `Host *` in `private_dot_ssh/private_config.tmpl`), NOT the 1Password agent — so the unattended timer never trips an unlock prompt. The key only reaches the git-shell-locked `git` user on the hub and cannot push to GitHub.

**Onboarding another machine:** `chezmoi apply` runs `run_once_after_bootstrap-chezmoi-sync.sh`, which generates the key, adds the `hub` remote, and prints the one-time command to authorize the new key on the hub. Then `git push hub main` once if the hub is empty. The launchd agents (`Library/LaunchAgents/com.clay.*.plist`, macOS-only via `.chezmoiignore`) are loaded by `run_onchange_after_load-launchagents.sh`; hub coordinates live in `.chezmoidata.yaml` (`sync_hub`).

## Agent config (Claude Code + Codex)

Both agent CLIs are configured from here, but only their **hand-authored** config
is managed. Both tools rewrite parts of their own config at runtime, and the
`origin` remote is public — those two facts set the whole design.

### The public-repo rule

**`.chezmoiignore` gates deployment, not what gets committed.** Everything in the
source tree is committed and pushed to the public `origin` by `dotfiles-publish`.
So `{{ if .work }}` guards keep personal config from *deploying* onto the work
Mac, but they do **nothing** to keep work content out of the public repo.

Anything naming internal orgs, repos, or services must be excluded in
`.gitignore` (source-tree git) instead. `gitleaks` will not catch these — they
aren't credentials, they're internal names. Currently gitignored:

| Path | Why |
|---|---|
| `dot_claude/rules/carepilot.md` | Work-only Claude rules; internal repo/service names |
| `dot_codex/work.config.toml` | Reserved slot for a work-only Codex profile |

These are machine-local and **not backed up anywhere**.

### Claude Code

| Target | Source | Notes |
|---|---|---|
| `~/.claude/settings.json` | `dot_claude/private_settings.json.tmpl` | See caution below — CC writes here at runtime |
| `~/.claude/CLAUDE.md` | `dot_claude/CLAUDE.md.tmpl` | User-scope instructions, loaded every session in every repo. Role-templated. Keep under ~200 lines |
| `~/.claude/commands/*.md` | `dot_claude/commands/` | Slash commands. Cross-project only — project commands go in that repo's `.claude/commands/` |
| `~/.claude/rules/*.md` | `dot_claude/rules/` | User-level rules, **auto-discovered** — no import line needed, and a machine where a file doesn't exist simply doesn't load it. This is why work-only rules live here rather than as an `@import` from `CLAUDE.md` (a missing import target would be a broken reference) |

Everything else under `~/.claude/` is per-machine runtime state and ignored.

**Caution — `settings.json` is the one managed file the agent also writes.** CC
adds `enabledPlugins`, `extraKnownMarketplaces`, `skillOverrides`, and various
`*Enabled` flags at runtime. Two consequences:

1. **Always `chezmoi diff` before applying.** An unreconciled `chezmoi apply
   --force` silently drops whatever CC added since the last reconcile. Reconcile
   by copying the new keys into the template, then confirm the diff is empty.
2. **It's published.** If you ever add a *private* plugin marketplace (the way
   `~/.codex/config.toml` has a private work marketplace), CC will write that
   repo URL into `settings.json`, and the next reconcile would commit it to the
   public origin. Check `extraKnownMarketplaces` before publishing; move any
   private entry into the ignored `settings.local.json` instead.

It's `private_` because CC writes the file 0600 — a non-private source would
produce a permanent mode diff.

### Notifications (who fires what)

Hooks run **alongside** built-in notifications, never instead of them, so every
built-in that overlaps a hook has to be turned off explicitly or it
double-notifies. Current division of labour:

| Event | Notifier | Setting |
|---|---|---|
| Turn finished, pane **not** visible | `agent-done-notify.sh` (names `session:window.pane` + repo/branch) | `taskCompleteNotifEnabled: false` disables the built-in |
| Turn finished, pane visible | *nothing* — you're looking at it | — |
| Needs input / permission | Built-in Ghostty notification | `inputNeededNotifEnabled: true` |
| Long task done, Remote Control connected | Push to phone | `agentPushNotifEnabled: true` |

`inputNeededNotifEnabled` must stay **true**: needing input doesn't end the turn,
so the `Stop` hook never fires for it and the hook structurally cannot cover that
case. To name the pane for input-needed too, add a `Notification` hook — that
event supports a matcher on notification type (`agent_needs_input`,
`permission_prompt`, `idle_prompt`, `agent_completed`).

Codex is unrelated to all of the above: it notifies via its own `notify` program
and `notifications-turn-mode = "unfocused"` in the app-owned `~/.codex/config.toml`.

### Codex

Codex is **not** managed via `~/.codex/config.toml`. That file is app-owned: it
carries `[marketplaces.*]` revisions, `[projects.*]` trust levels,
`[hooks.state.*]` trust hashes, and an installer-written
`[mcp_servers.node_repl]`. Managing it would dirty `chezmoi diff` on every Codex
launch and revoke project/hook trust on every `chezmoi apply`.

Instead, Codex 0.146+ supports profile layering — `-p <name>` layers
`$CODEX_HOME/<name>.config.toml` over the base config:

| Target | Source | Notes |
|---|---|---|
| `~/.codex/main.config.toml` | `dot_codex/main.config.toml.tmpl` | Managed overlay. Codex never writes to it |
| `~/.codex/config.toml` | *unmanaged, per-machine* | App-owned. Also where work-only Codex settings go — it's untracked, so it can't leak to the public repo |

Use `cx` (alias for `codex -p main`, defined in `private_dot_zshrc.tmpl`) — bare
`codex` reads only the base config and ignores the managed overlay. Profiles do
**not** compose: `-p` layers exactly one file, so a second profile would have to
duplicate `main.config.toml` rather than extend it.

Two verified gotchas:

- **A missing profile is silent.** `codex -p typo_name` exits 0 and just applies
  no overlay — you get base config with no warning. If overlay settings seem not
  to apply, check the filename before anything else. (A malformed overlay *does*
  error loudly with a line/column, so parse failures aren't silent.)
- **`-p` only works on runtime subcommands** — `codex`, `exec`, `review`,
  `resume`, `fork`, `mcp`, `sandbox`, `debug prompt-input`. On others (e.g.
  `codex debug models`) it's a hard error, so don't put `-p` in a blanket
  `codex()` shell wrapper. That's why `cx` is a separate alias.

`[desktop]` settings stay in the app-owned `config.toml`: `-p` is a CLI flag and
the Desktop app doesn't accept it.

## Chezmoi File Naming

| Prefix/Suffix | Meaning | Example |
|---|---|---|
| `dot_` | Becomes `.` | `dot_zshrc` → `.zshrc` |
| `private_` | 600 permissions | `private_dot_zshrc.tmpl` |
| `executable_` | Executable bit set | `executable_chezmoi-sync` |
| `.tmpl` | Go template, rendered by chezmoi | `dot_tmux.conf.tmpl` |
| `exact_` | Directory contents managed exactly | |

## Conventions

Formatting is defined by the deployed tool configs rather than by this document.
Prettier wraps Markdown at 80 columns with `proseWrap: always`
(`dot_prettierrc.yaml`), Lua uses two-space indents
(`dot_config/nvim/stylua.toml`), and TOML uses two-space indents
(`dot_config/taplo.toml`). Older sections of this file predate the 80-column
rule and run long; wrap new prose at 80 rather than matching them.

Keep template conditionals simple. When per-host behaviour grows past a line or
two, move the data into `.chezmoidata.yaml` and branch on that instead — with
the one exception that the work-host list must live inline in
`.chezmoi.toml.tmpl`, since data files are not loaded when the config template
renders.

Commit messages are short, imperative, and lowercase, usually with an area
prefix: `lazygit: drop the stale default-dump config`,
`brew: trust per item rather than per tap`. Keep a commit to one config area
where you can.

There is no test suite. Validate a template edit by rendering it with
`chezmoi execute-template < the_file.tmpl` before you look at `chezmoi diff`,
and read the diff before applying anything. For a script, prefer a dry run or a
narrow manual execution over discovering the behaviour through `chezmoi apply`.

## Essential Commands

```bash
# Preview what chezmoi would change
chezmoi diff

# Apply changes to the system
chezmoi apply

# Apply with verbose output
chezmoi apply --verbose

# Re-render .chezmoi.toml.tmpl after hostname or workHosts changes
chezmoi init

# Show resolved data (role, email, op_account, etc.)
chezmoi data

# Test template rendering
chezmoi execute-template < some_file.tmpl

# Find the source file for a deployed config
chezmoi source-path ~/.config/ghostty/config

# Add a new file to chezmoi management
chezmoi add ~/.config/some-tool/config
```

## Template Syntax (Go templates)

Files ending in `.tmpl` use Go template syntax with chezmoi extensions:

```go
{{ .chezmoi.homeDir }}                                              // home directory
{{ .chezmoi.os }}                                                   // "darwin" or "linux"
{{ if eq .chezmoi.os "linux" }}...{{ end }}                          // OS conditional
{{ if eq .role "work" }}...{{ end }}                                 // machine-role conditional
{{ index .ssh_signing_keys .role }}                                  // pick a value by role
{{ onepasswordRead "op://vault/item/field" "my.1password.com" }}     // 1Password lookup, account-pinned
```

## Key Configs

- **Zsh**: `private_dot_zshrc.tmpl` — 1Password secrets pinned to personal account; OS-conditional blocks
- **Tmux**: `dot_tmux.conf.tmpl` — OS-conditional theme detection
- **Neovim**: `dot_config/nvim/` — LazyVim-based, plain Lua (not templated)
- **Ghostty**: `dot_config/ghostty/config` — primary terminal emulator
- **Git**: `private_dot_gitconfig.tmpl` — SSH signing via 1Password; per-machine signingkey from `ssh_signing_keys` map; work Mac adds HTTPS rewrite + `includeIf` for carepilot repos
- **Carepilot git override**: `private_dot_gitconfig.carepilot.tmpl` — separate SSH signing key for commits inside `~/Dev/carepilot/repos/`
- **SSH**: `private_dot_ssh/private_config.tmpl` — 1Password agent globally; alternate `github-personal-site` host for Linux deploy boxes
- **Aerospace**: `dot_config/aerospace/aerospace.toml` — i3-style alt bindings, JankyBorders for active-window indicator
- **Claude Code**: `dot_claude/private_settings.json.tmpl` + `dot_claude/executable_statusline-command.sh` + hooks in `dot_claude/hooks/` (`nvim-reload.sh` on PostToolUse → live-reloads the sibling-pane nvim; `agent-done-notify.sh` on Stop → names the finished agent's tmux pane, and only when you're not looking at it) — synced; `settings.local.json` and runtime state stay per-machine (see `.chezmoiignore`)
- **Claude Code + Neovim diff-review workflow**: see [`docs/claude-nvim-workflow.md`](docs/claude-nvim-workflow.md) — the documented prompt → edit → review → revert loop across the tmux CC/nvim split, plus the keymap cheatsheet
- **Agent config (Claude Code + Codex)**: see [Agent config](#agent-config-claude-code--codex) below — what's managed, what's deliberately not, and where work-only content lives
- **Brewfile**: `dot_Brewfile` (base) + `dot_Brewfile.work` + `dot_Brewfile.personal`. `run_onchange_brew-bundle.sh.tmpl` applies both base and overlay on every change
- **Runtimes & toolchain**: `dot_config/mise/config.toml` — **mise** pins Go, Node, Python, Ruby, Rust, Lua, Terraform, kubectl, the AWS CLI, uv, Java, plus Maestro, CocoaPods and agent-browser via the `github:`/`gem:`/`npm:` backends (replaced asdf). Activated in `private_dot_zshrc.tmpl` with `mise activate zsh`, which re-resolves `PATH` each prompt, so no shim directory is prepended statically. `run_onchange_node-bootstrap.sh.tmpl` re-runs whenever the config changes, installing the pins and enabling corepack so pnpm and yarn exist. **Nothing else should install a language runtime or versioned CLI** — not the Brewfile, not an upstream installer script. Terraform, uv and Java used to come from untracked `brew install` calls and kubectl from Docker Desktop, which is exactly the drift this centralises. Java is pinned as `temurin-17`, not `17`, because a bare major resolves to the openjdk vendor and openjdk.org only publishes the current GA patch (mise therefore offers only 17.0.0–17.0.2 there). mise exports `JAVA_HOME` under `mise activate`, so nothing should set it by hand; the Maestro block in `.zshrc` documents why it no longer does. Docker Desktop's root-owned `/usr/local/bin/kubectl` symlink is left alone and simply sits behind mise on `PATH`
- **KDE shortcuts**: `dot_config/private_kglobalshortcutsrc` (Linux remotes only)
- **KWin rules**: `dot_config/kwinrulesrc` (Linux remotes only)
- **Starship**: `dot_config/starship.toml.tmpl` — OS-aware palette

## Architecture Notes

- Templates (`.tmpl`) are the only files that need chezmoi rendering — plain config files are copied as-is
- 1Password integration means `chezmoi apply` requires the relevant 1P account to be signed in for any template that references secrets
- The `.chezmoiignore` excludes documentation, IDE configs, plugin data, secrets, and dynamic state files from management; it's a Go template too, so it can conditionally exclude per-host (`remoteHosts` paths skip macOS-only configs like `.config/aerospace` and `.config/ghostty`)
- Neovim plugins are managed by Lazy.nvim (not chezmoi) — `lazy-lock.json` is gitignored
- Tmux plugins are managed by TPM (not chezmoi) — `~/.tmux/plugins/` is gitignored
- Brewfile splits do NOT merge automatically; the run_onchange script runs base then overlay, and `brew bundle` only adds packages (doesn't uninstall), so removing from a Brewfile is a no-op until you `brew bundle cleanup` manually
- **`mise use -g` writes to a chezmoi-managed file.** `~/.config/mise/config.toml` is managed, and `mise use -g <tool>` rewrites it in place, so it carries the same hazard as `~/.claude/settings.json`: run `chezmoi diff` afterwards and copy the change back into `dot_config/mise/config.toml`, or skip the CLI and edit the source then apply. Reading is safe; only `use`, `settings set`, and `unuse` write
- **Never `npm install -g` or `gem install` a tool you want to keep.** Those land inside `~/.local/share/mise/installs/<runtime>/<version>/`, which means they are tracked by nothing, will not reproduce on a new machine, and are abandoned the moment the runtime pin is bumped. The asdf-to-mise migration lost `agent-browser` and CocoaPods exactly that way. Declare them as mise tools instead, using the `npm:` and `gem:` backends (`"npm:agent-browser"`, `"gem:cocoapods"`). Anything distributed only as a GitHub release works via the `github:` backend, which is how Maestro is pinned. Note the npm backend puts executables in `node_modules/.bin/` rather than `bin/`, so an empty `bin/` there is normal, not a broken install
- **A phantom diff on `.config/mise/config.toml` is expected occasionally.** mise rewrites the file when it normalises settings and drops comments attached to keys *inside* a table, so prose belongs above a `[section]` header rather than between the header and its keys. If `chezmoi diff` shows only comments disappearing and no value changes, `chezmoi apply --force` is the correct fix — but confirm there are no deployed-only lines first, since this is the same file `mise use -g` writes to
