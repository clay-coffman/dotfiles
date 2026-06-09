#!/usr/bin/env bash
# Claude Code PostToolUse hook: after CC edits a file, poke the sibling-pane
# nvim (same tmux window) to reload it and refresh any open Diffview, so review
# in the next pane stays live. Inert no-op outside tmux or when no nvim is
# listening, so it's safe to ship globally to every machine/session.
#
# Wired up in dot_claude/settings.json.tmpl (PostToolUse, matcher Edit|Write|…).
# The nvim side defines _G.cc_reload() and listens on the matching socket
# (see dot_config/nvim/lua/config/{autocmds,options}.lua).

[ -n "$TMUX" ] || exit 0

win=$(tmux display-message -p -t "${TMUX_PANE:-}" '#{window_id}' 2>/dev/null) || exit 0
sock="${XDG_RUNTIME_DIR:-/tmp}/nvim-tmux-${win}.sock"
[ -S "$sock" ] || exit 0

# Fire-and-forget: <Cmd>…<CR> runs the lua in any mode without changing it, so a
# reload mid-typing is harmless. Backgrounded so the hook never adds edit latency.
( nvim --server "$sock" --remote-send '<Cmd>lua if _G.cc_reload then cc_reload() end<CR>' >/dev/null 2>&1 & )

exit 0
