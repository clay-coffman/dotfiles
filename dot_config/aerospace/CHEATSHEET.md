# AeroSpace Cheatsheet

i3-style alt bindings. Source of truth: `aerospace.toml` in this directory.

> Tip: `alt-;` enters **service mode** (a one-shot meta-mode). After running a service-mode action, you're returned to main mode automatically.

---

## Main mode

### Focus & move

| Key | Action |
|---|---|
| `alt-h` / `alt-j` / `alt-k` / `alt-l` | Focus window left / down / up / right |
| `alt-shift-h/j/k/l` | Move window left / down / up / right |
| `alt-minus` | Shrink window (-50) |
| `alt-equal` | Grow window (+50) |

### Window state

| Key | Action |
|---|---|
| `alt-shift-f` | Toggle floating ↔ tiling |
| `alt-shift-enter` | Fill screen (AeroSpace fullscreen — no macOS space transition) |

### Layout

| Key | Action |
|---|---|
| `alt-slash` | Toggle tiles: horizontal ↔ vertical |
| `alt-comma` | Toggle accordion: horizontal ↔ vertical |

### Workspaces

Hybrid setup: **scratch workspaces** (numbered, flexible) + **dedicated app workspaces** (lettered, auto-routed).

| Key | Workspace | Purpose |
|---|---|---|
| `alt-1` / `alt-2` / `alt-3` / `alt-4` | `1` / `2` / `3` / `4` | Scratch — splits, project work, mixed apps |
| `alt-i` | `I` | Linear (auto-routed) |
| `alt-n` | `N` | Notion (auto-routed) |
| `alt-s` | `S` | Slack (auto-routed, pinned to laptop screen) |
| `alt-p` | `P` | Personal — dotfiles, personal email, ghostty |
| `alt-m` | `M` | Music — Spotify (auto-routed, pinned to laptop screen) |
| `alt-o` | `O` | persOnal-2 — Messages + Reminders (auto-routed, pinned to laptop screen) |
| `alt-shift-<same>` | — | Move focused window to that workspace |
| `alt-tab` | — | Back-and-forth between current and previous workspace |

Apps **not** auto-routed (open wherever focused): Ghostty, Chrome, Windsurf, Cursor, everything else.

### Auto-routing

When a routed app launches anywhere, AeroSpace immediately yanks it to its dedicated workspace. Configured via `[[on-window-detected]]` blocks in `aerospace.toml`.

| App | Bundle ID | Workspace | Default layout |
|---|---|---|---|
| Linear | `com.linear` | `I` | vertical tiles |
| Notion | `notion.id` | `N` | vertical tiles |
| Slack | `com.tinyspeck.slackmacgap` | `S` | vertical tiles |
| Spotify | `com.spotify.client` | `M` | vertical tiles |
| Messages | `com.apple.MobileSMS` | `O` | vertical accordion |
| Reminders | `com.apple.reminders` | `O` | vertical accordion |

**To add another app:**
1. Find its bundle ID for one app: `osascript -e 'id of app "AppName"'`. Or list all running apps: `osascript -e 'tell application "System Events" to get {name, bundle identifier} of every process whose background only is false'`
2. Pick a workspace letter (avoid `h`, `j`, `k`, `l` — those are focus keys; `i`, `n`, `s`, `p`, `m`, `o` are taken)
3. Add a binding: `alt-X = 'workspace X'` and `alt-shift-X = 'move-node-to-workspace X'`
4. Add a routing block at the bottom of the config:
   ```toml
   [[on-window-detected]]
   if.app-id = 'com.example.app'
   run = ['move-node-to-workspace X']
   ```
5. `alt-shift-r` to reload (or restart AeroSpace).

### Multi-monitor

| Key | Action |
|---|---|
| `alt-shift-tab` | Move *entire workspace* to next monitor (wraps) |
| `alt-shift-period` | Focus next monitor |
| `alt-shift-comma` | Focus previous monitor |
| `alt-shift-x` | Move focused window to next monitor (wraps) |
| `alt-shift-r` | Flatten workspace tree + reload config (use after re-docking if layout looks off) |

**Workspace pinning** (auto-applied when both monitors connected; no-ops in laptop-only mode):

| Workspace | Pinned to |
|---|---|
| `S` | Laptop screen (secondary) — Slack on the side monitor |
| `M` | Laptop screen (secondary) — Spotify on the side monitor |
| `O` | Laptop screen (secondary) — Messages + Reminders on the side monitor |

All other workspaces follow the focused monitor (LG when connected).

**Single-monitor mode** (laptop alone, or laptop + portable): all pinning, focus-monitor, and move-to-monitor bindings silently no-op. Auto-routing rules still fire — apps go to their workspaces, which appear on the only screen. Nothing breaks.

**After re-docking the LG**: workspaces that lived on the laptop during the disconnect stay on the laptop until you switch to them. `alt-shift-r` (flatten + reload) clears up any layout weirdness.

### Mode switch

| Key | Action |
|---|---|
| `alt-;` | Enter **service mode** |

---

## Service mode

Enter with `alt-;`. Most actions return to main mode automatically after running.

### Cleanup

| Key | Action |
|---|---|
| `esc` | Reload config, exit to main mode |
| `r` | Flatten workspace tree, exit to main mode |
| `f` | Toggle floating/tiling, exit to main mode |
| `backspace` | Close all windows but current, exit to main mode |

### Join windows into a container

| Key | Action |
|---|---|
| `alt-shift-h/j/k/l` | Join focused window with neighbor on the left / down / up / right, exit to main mode |

### Layout (stays in service mode)

| Key | Action |
|---|---|
| `alt-shift-a` | Set workspace to accordion layout |
| `alt-shift-t` | Set workspace to tiles layout |

### Volume

| Key | Action |
|---|---|
| `up` | Volume up |
| `down` | Volume down |
| `shift-down` | Mute, exit to main mode |

---

## Concepts (quick reference)

- **Tiles vs accordion**: tiles split the screen; accordion stacks windows so only one is fully visible.
- **`fullscreen` vs `macos-native-fullscreen`**: `fullscreen` fills the visible area (no space transition); `macos-native-fullscreen` triggers the macOS native fullscreen mode (separate space). This config uses the former on `alt-shift-enter`.
- **Scratch vs dedicated workspaces**: scratch (1-4, P) are flexible — open anything anywhere. Dedicated (I, N, S, M, O) are auto-claimed by specific apps on launch.
- **JankyBorders** draws the colored outline around the focused window. Configured in the `after-startup-command`.

## Troubleshooting

- **A binding doesn't work**: another tool may have intercepted it before AeroSpace. AeroSpace's bindings take priority over apps but not over global macOS shortcuts (System Settings → Keyboard → Shortcuts).
- **App didn't auto-route on launch**: bundle ID is probably wrong. Run `osascript -e 'id of app "AppName"'` and compare with the `if.app-id` value in `aerospace.toml`. Or run `aerospace list-apps` (with AeroSpace running) to see what AeroSpace actually sees.
- **App routed but a secondary window stayed put**: some apps spawn detached windows (Chrome DevTools, Slack call popups). Add an extra rule with `if.window-title-regex` to handle them.
- **Re-docking left layout weird**: `alt-shift-r` (flatten + reload). Or `alt-;` then `esc`.
- **List monitor names**: `aerospace list-monitors` (useful if you want to swap `'secondary'` for a regex match).
- **Inspect what's bound**: `aerospace list-modes` and check `aerospace.toml` in this directory.
