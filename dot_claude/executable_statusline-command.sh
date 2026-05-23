#!/usr/bin/env bash
# Claude Code statusLine command
# Mirrors key elements of Clay's Starship prompt

input=$(cat)

# Directory: use cwd from JSON, truncate to last 3 segments with ⋯ /
raw_dir=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
if [ -n "$raw_dir" ]; then
  # Replace $HOME with ⌂
  home_dir="$HOME"
  display_dir="${raw_dir/#$home_dir/⌂}"
  # Truncate to last 3 path segments
  IFS='/' read -ra parts <<< "$display_dir"
  count="${#parts[@]}"
  if [ "$count" -gt 3 ]; then
    truncated="${parts[$((count-3))]}/${parts[$((count-2))]}/${parts[$((count-1))]}"
    display_dir="⋯ /$truncated"
  fi
else
  display_dir="$(pwd)"
fi

# Git branch + status using git directly (no lock contention)
git_info=""
git_branch=$(git -C "$raw_dir" branch --show-current 2>/dev/null)
if [ -n "$git_branch" ]; then
  git_info=" $git_branch"
  # Quick status summary
  status_output=$(git -C "$raw_dir" status --porcelain 2>/dev/null)
  modified=$(echo "$status_output" | grep -c '^ M\|^M ' 2>/dev/null || echo 0)
  untracked=$(echo "$status_output" | grep -c '^??' 2>/dev/null || echo 0)
  staged=$(echo "$status_output" | grep -c '^[MADRC]' 2>/dev/null || echo 0)
  flags=""
  [ "$staged" -gt 0 ] && flags="${flags}+${staged}"
  [ "$modified" -gt 0 ] && flags="${flags}!${modified}"
  [ "$untracked" -gt 0 ] && flags="${flags}?${untracked}"
  [ -n "$flags" ] && git_info="${git_info} [${flags}]"
fi

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Context remaining
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
ctx_str=""
[ -n "$remaining" ] && ctx_str=" ctx:$(printf '%.0f' "$remaining")%"

printf "%s%s  %s%s" "$display_dir" "$git_info" "$model" "$ctx_str"
