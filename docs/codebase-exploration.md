# Exploring a large codebase

File trees are useful for orientation, but they rarely explain how a large
repository works. Start with the parts that reveal behavior: the code's shape,
the build and test entry points, recent activity, and symbol relationships.

This guide is written for a pnpm and Turbo TypeScript monorepo, but the method
applies to most large repositories.

## First 30 minutes

1. Start a scratch note with the question you are trying to answer, the terms
   you encounter, and conclusions with links to their evidence. The durable
   result of exploration is a map, not a list of files you opened.
2. Measure the repository before reading it. Language mix and line counts show
   where its mass lives; repeat the command for the largest top-level areas.
3. Read the CI configuration and root package scripts. They reveal the commands
   that must work, test entry points, checks, and deployment boundaries. Compare
   the README against them rather than treating either as the whole story.
4. Find recently active files and the people who have worked in an area.
5. Open Neovim and navigate by symbol, definition, and reference rather than
   opening every plausible file from the tree.

## Measure shape and activity

Run these from the repository root:

```sh
tokei .
tokei apps packages tools

git log --since=6.months --name-only --pretty=format: \
  | sed '/^$/d' \
  | sort \
  | uniq -c \
  | sort -rn \
  | head -30

git who tree -d 2
git who hist
```

The change-frequency list is a lead, not a definition of importance: generated
files, migrations, and churny integrations can distort it. Use it to choose
where to inspect next, then validate the story against CI, tests, and callers.

`git who tree -d 2` is especially useful when joining an unfamiliar project. It
aggregates authorship by directory, making it easier to find an appropriate
person for subsystem context.

## Use Broot for structure

Run `br` from the repository root. It keeps the tree visible while filtering,
which makes it better for answering “where does this thing live?” than
opening directories one at a time.

- Type a partial name to narrow the tree without losing hierarchy.
- Use `Ctrl-Right` to open Broot's preview panel.
- Use Broot's size mode when generated output or a large package is obscuring
  the repository's real shape.
- `:h` toggles hidden files; `:gi` toggles ignored files. These replace Broot's
  default Option bindings, which are reserved by the window manager here.
- Use Option-Enter or `:cd` to exit Broot with the selected directory as the
  current shell directory.

Broot is a structural view, not a replacement for symbol navigation. Once you
have found a likely area, switch to search and language-server navigation.

## Use Neovim without creating buffer clutter

The fzf-lua picker is the default discovery tool. Its preview lets you inspect
candidate files before pressing Enter, so a glance does not become a buffer.

| Keymap | Use |
| --- | --- |
| `<leader>ff` | Find files from the Git repository root |
| `<leader>fF` | Find files from the current directory |
| `<leader>sg` | Live grep from the Git repository root |
| `<leader>sG` | Live grep from the current directory |
| `<leader>ss` | Document symbols |
| `<leader>sS` | Workspace symbols |
| `Ctrl-R` in a picker | Toggle repository root and current directory |
| `Option-.` / `Option-G` in a file or grep picker | Toggle hidden / ignored files |
| `<leader>cs` | Symbol outline in Trouble |
| `<leader>cS` | References, definitions, and related LSP results in Trouble |
| `gd` / `gr` / `Ctrl-O` | Definition / references / jump back |
| `<leader>bi` | Delete buffers not visible in a window |
| `<leader>bo` / `<leader>bd` | Delete other buffers / current buffer |

The root-oriented picker commands intentionally use the Git root. A TypeScript
language server may attach to an individual workspace package, but that should
not stop a repository exploration query from seeing sibling packages.

Neo-tree remains useful for a deliberate directory operation. Yazi is better
for quickly reading a file beside its directory: its preview wraps long lines,
`J` and `K` scroll it, and `<Tab>` opens the full-window spot view.

## Search structurally when text search is too broad

Use `rg` for names, strings, comments, and broad discovery. Use `ast-grep` when
the question is about code syntax rather than text, such as “where is this
method called with a literal argument?”

```sh
# Find a TypeScript call regardless of the receiver or argument names.
ast-grep --lang ts -p '$OBJECT.$METHOD($ARG)' packages apps

# Find calls whose first argument is a string literal.
ast-grep --lang ts -p '$FUNCTION("$VALUE", $$$REST)' packages apps
```

Prefer the full `ast-grep` command name in documentation and scripts. `sg` is
also provided, but it collides with a system command on some Linux hosts.

## A compact loop

1. Form a question and record it in the scratch note.
2. Use `tokei`, Broot, CI, and package scripts to identify the likely area.
3. Use the picker preview, `rg`, or `ast-grep` to locate a concrete symbol.
4. Use the document outline, `gd`, and `gr` to follow the execution path.
5. Record the conclusion, the evidence, and the next unanswered question.
6. Run `<leader>bi` whenever the buffer list stops representing active work.

That loop favors evidence and relationships over broad file browsing, while
still giving the tree a useful role when hierarchy actually matters.
