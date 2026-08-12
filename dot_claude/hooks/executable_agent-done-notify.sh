#!/usr/bin/env bash
# Stop hook: desktop-notify WHICH agent finished, and only when you're not
# already looking at it.
#
# With 3-4 concurrent Claude Code panes, the built-in notification says
# "Claude Code" and nothing else — it tells you something finished but not where
# to go. This puts the tmux session:window.pane and the repo/branch in the
# notification, so it reads as a routing instruction: `prefix + o` to that
# session, or `prefix + g` to yank the window in as a pane.
#
# Stays quiet when the CC pane is the active pane of the current window in an
# attached session — i.e. exactly when you can already see it. That's what keeps
# this from firing on every turn of a foreground conversation.
#
# THIS REPLACES the built-in task-complete notification rather than adding to it:
# `taskCompleteNotifEnabled: false` in settings.json turns that one off, because
# hooks run ALONGSIDE built-in notifications, not instead of them, and leaving
# both on double-notifies exactly the background panes this exists for.
#
# `inputNeededNotifEnabled` stays TRUE on purpose. Needing input or a permission
# doesn't end the turn, so Stop never fires for it — this hook structurally
# cannot cover that case, and the built-in is what still alerts you. Don't
# "clean up" by disabling it too.
#
# Nothing here touches Codex: it notifies through its own `notify` program and
# `notifications-turn-mode` in ~/.codex/config.toml. Separate binary, no overlap.
#
# Best-effort throughout: any failure exits 0 so the hook never blocks Claude.
# Inert outside tmux. Source: dot_claude/hooks/executable_agent-done-notify.sh

set -uo pipefail

# Outside tmux there's no location worth naming, and the built-in notification
# already covers the single-window case.
[[ -z ${TMUX:-} || -z ${TMUX_PANE:-} ]] && exit 0

# Are you looking at this pane right now? active pane + current window +
# attached session. `session_attached` is a client count, so 0 reads as false.
looking=$(tmux display -p -t "$TMUX_PANE" \
    '#{&&:#{pane_active},#{&&:#{window_active},#{session_attached}}}' 2>/dev/null) || exit 0
[[ $looking == 1 ]] && exit 0

loc=$(tmux display -p -t "$TMUX_PANE" '#S:#I.#P' 2>/dev/null) || exit 0
[[ -z $loc ]] && exit 0

# Repo + branch if we're in a git tree, otherwise the directory name.
if root=$(git rev-parse --show-toplevel 2>/dev/null); then
    body=$(basename "$root")
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) && body="$body @ $branch"
    # Worktrees are the parallel-agent case — worth calling out explicitly.
    [[ $(git rev-parse --git-dir 2>/dev/null) == *"/worktrees/"* ]] && body="$body (worktree)"
else
    body=$(basename "$PWD")
fi

case "$(uname -s)" in
    Darwin)
        # Pass strings as argv rather than interpolating into AppleScript, so a
        # branch name containing a quote can't break (or inject into) the script.
        osascript - "$loc" "$body" <<'APPLESCRIPT' >/dev/null 2>&1
on run argv
    display notification (item 2 of argv) with title ("Claude Code done — " & item 1 of argv)
end run
APPLESCRIPT
        ;;
    Linux)
        command -v notify-send >/dev/null 2>&1 &&
            notify-send "Claude Code done — $loc" "$body" >/dev/null 2>&1
        ;;
esac

exit 0
