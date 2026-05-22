# Repository Guidelines

## Project Structure & Module Organization

This repository is a chezmoi-managed dotfiles source tree. Edit files here, not
the deployed copies under `$HOME`.

- Root files such as `dot_bashrc`, `private_dot_zshrc.tmpl`, and
  `dot_tmux.conf.tmpl` map to home-directory dotfiles.
- `dot_config/` maps to `~/.config/` and contains app configs for Neovim, kitty,
  Ghostty, tmux, yazi, KDE Plasma, systemd user services, and related tools.
- `dot_local/` maps to `~/.local/` and contains local scripts, desktop entries,
  and Plasma theme assets.
- `run_once_*.tmpl` and `run_onchange_*.tmpl` are chezmoi scripts executed by
  chezmoi during apply.
- `.chezmoidata.yaml` stores host-specific data, currently remote host names.

## Build, Test, and Development Commands

- `chezmoi diff` previews rendered changes before deployment.
- `chezmoi apply` deploys changes to the live home directory.
- `chezmoi apply --verbose` deploys with detailed output for debugging.
- `chezmoi execute-template < some_file.tmpl` validates template rendering.
- `chezmoi source-path ~/.config/ghostty/config` finds the source file for a
  deployed config.
- `chezmoi add ~/.config/some-tool/config` imports a new managed file.

There is no compile step; validation is mostly rendering templates and reviewing
chezmoi diffs.

## Coding Style & Naming Conventions

Follow chezmoi naming rules: `dot_` becomes `.`, `private_` sets private
permissions, `executable_` sets the executable bit, and `.tmpl` marks Go
templates. Keep template conditionals simple and prefer data in
`.chezmoidata.yaml` when host-specific behavior grows.

Formatting preferences are captured in deployed tool configs: Prettier uses
80-column Markdown wrapping via `dot_prettierrc.yaml`, Lua uses two-space indents
via `dot_config/nvim/stylua.toml`, and TOML uses two-space indentation via
`dot_config/taplo.toml`.

## Testing Guidelines

No formal test suite exists. For changes to templates, run
`chezmoi execute-template` on the edited file and then `chezmoi diff`. For
scripts, inspect rendered output and prefer a dry run or narrow manual execution
before `chezmoi apply`. For Neovim Lua changes, keep files under
`dot_config/nvim/lua/` loadable and consistent with the LazyVim layout.

## Commit & Pull Request Guidelines

Recent commits use short, imperative, lowercase summaries such as
`fix starship -> convert to template` and `update shortcuts, change font size`.
Keep commits focused on one config area when possible.

Pull requests should describe the affected tools, include notable rendered
changes from `chezmoi diff`, mention any host-specific impact, and include
screenshots only for visible UI/theme changes.

## Agent-Specific Instructions

Never edit deployed files directly. Make source changes in this repository,
preserve unrelated local modifications, and avoid running `chezmoi apply` until
the diff has been reviewed.
