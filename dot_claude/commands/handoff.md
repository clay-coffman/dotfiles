---
description: Write a compact handoff brief so the other agent (Codex/CC) can pick this up cold
argument-hint: "[optional: what to focus the handoff on]"
---

Produce a handoff brief for a **different agent starting with zero context** —
typically Codex picking up what Claude Code was doing, or vice versa. I flip
between them, and re-establishing context by hand is the expensive part.

Write it to `HANDOFF.md` at the repo root (or the path I named in `$ARGUMENTS`),
and also print it. Keep it under roughly 60 lines — this is a briefing, not a
transcript.

Include, in this order, skipping any section that would be empty:

1. **Goal** — one or two sentences on what we're actually trying to accomplish,
   not a list of what was done.
2. **State of the tree** — the current branch, whether this is a worktree, and
   the output of `git status --short`. Say plainly whether the working tree is
   clean, mid-change, or broken.
3. **What's done** — the changes already made and why, grouped by intent rather
   than by file. Reference `file:line` so they're clickable.
4. **What's left** — the remaining work, ordered. Be specific enough to act on.
5. **Landmines** — anything that would burn the next agent: failing tests,
   commands that must not be run, side effects already applied (installs,
   migrations, pushes), approaches already tried and rejected *and why*.
6. **Open questions** — decisions that are mine to make, still unanswered.

Rules:

- Report the tree state faithfully. If tests fail, paste the relevant failure
  output; if you never ran them, say so rather than implying they pass.
- Don't restate what the repo's own CLAUDE.md/AGENTS.md already says — the next
  agent reads those too. Only note where reality diverges from them.
- Distinguish what you verified from what you assumed. An assumption presented
  as fact is the main way handoffs go wrong.
- No motivational summary, no "next steps for the team" framing. One engineer
  briefing another.
