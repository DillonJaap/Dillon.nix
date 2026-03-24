# AGENTS.md — Dillon.nix

Personal Nix/home-manager dotfiles targeting macOS (`aarch64-darwin`, user `DJaap`)
and Linux (`x86_64-linux`, user `dillon`). Manages packages, shell, editor, terminal,
and scripts declaratively via a single home-manager module.

---

## Repo Structure

```
flake.nix                   # Flake inputs + mkHome factory + homeConfigurations outputs
module/home-manager.nix     # The single home-manager module (all config lives here)
config/
  bash/bashrc               # Aliases, prompt, utility functions
  bash/bash_profile         # Nix bootstrap, PATH, sources bashrc
  nushell/config.nu         # Nushell settings, commands, prompt
  nushell/env.nu            # PATH + env vars for nushell
  nushell/git-completions.nu
  nushell/gh-completions.nu
  nvim/                     # Neovim Lua config (lazy.nvim based)
  scripts/                  # shell-launcher, kitty-tab-manager, tmux-session-manager
```

---

## Build / Apply Commands

```bash
# Apply configuration (macOS)
home-manager switch --flake .#mac-aarch64

# Apply configuration (Linux)
home-manager switch --flake .#linux-x86_64

# Apply with automatic backup of conflicting files
home-manager switch --flake .#mac-aarch64 -b backup

# Build without activating
nix build .#homeConfigurations.mac-aarch64.activationPackage

# Evaluate / check the flake
nix flake check
nix flake show

# Update all flake inputs
nix flake update
```

There are no unit tests. Correctness is verified by a successful `home-manager switch`
and manual inspection in a live shell.

---

## Nix Style (`flake.nix`, `module/home-manager.nix`)

- **Indentation:** 2 spaces.
- **Variables:** `camelCase` (`symLink`, `isDarwin`, `nushellConfigDir`, `mkHome`).
- **Flake output keys:** `kebab-case` (`mac-aarch64`, `linux-x86_64`).
- **`let...in` block** at the top of every file for derived values:
  ```nix
  let
    symLink = config.lib.file.mkOutOfStoreSymlink;
    isDarwin = pkgs.stdenv.isDarwin;
  in
  ```
- **Symlinks to repo files** always use `mkOutOfStoreSymlink` so edits are live
  without re-running `home-manager switch`.
- **Platform conditionals** use `if pkgs.stdenv.isDarwin then ... else ...`.
- **Comments:** `#` inline. Group headers use a short descriptive sentence above the block.
  Section banners (`# =====`) only inside embedded `text = ''...''` config strings.
- **All config in one module.** Do not split into sub-modules without a strong reason.
- **`nushell` is managed via `home.file`**, not `programs.nushell`, because the
  home-manager module writes to the wrong path on macOS unless `xdg.enable` is set
  (which causes other issues). Use `home.file` with the `nushellConfigDir` variable.

---

## Nushell Style (`config.nu`, `env.nu`)

- **Indentation:** Tabs in `config.nu`/`env.nu`; 2 spaces in completion files.
- **Commands:** `kebab-case` (`trim-pwd`, `aws-deploy-login`).
- **Variables:** `snake_case` (`$aws_env`, `$selected_dir`).
- **Nu-complete helpers:** quoted string names following `"nu-complete <tool> <subcommand>"` convention.
- **External commands** prefixed with `^` to disambiguate (`^git`, `^gh`, `^nu`).
- **Env vars:** `$env.VAR = value`; PATH extended with `$env.path ++= [...]`.
- **String interpolation:** `$"text ($var) text"`.
- **Completion file exports:**
  ```nushell
  export extern "git checkout" [
      branch?: string@"nu-complete git branches"
      --force(-f)  # force checkout
  ]
  ```
- **Pipelines** preferred over imperative loops; `parse`, `where`, `each`, `insert`.
- **Error handling:** `if (which tool | is-not-empty) { ... }` guards for optional tools.
- **No `source` with absolute paths** — use bare filename (resolved relative to config dir).

---

## Bash Style (`bashrc`, `bash_profile`, scripts)

- **Indentation:** Tabs inside function bodies.
- **Functions:** `camelCase` for helpers (`trimPWD`, `jqve`, `gittag`).
- **Env vars:** `UPPER_CASE`; local script vars `lower_case`.
- **Shebang:** `#!/bin/bash` for feature-rich scripts; `#!/bin/sh` for POSIX-portable ones.
- **Optional file sourcing:** `[[ -f "$file" ]] && source "$file"`.
- **Early-exit guards:** `[[ -z "$selected" ]] && exit 0`.
- **Silence optional commands:** `cmd > /dev/null 2>&1 || true`.
- **Directory search:** use `fd`, not `find`. Fuzzy selection: `fzy`, not `fzf`.
- **Script caching:** expensive directory listings cached in `/tmp/items`; pass `update-list`
  as `$1` to bust the cache.

---

## Lua / Neovim Style (`config/nvim/`)

- **Indentation:** Tabs everywhere (1 tab per level).
- **Filenames:** `snake_case.lua` (e.g. `neo_tree.lua`, `toggle_term.lua`).
- **Module namespace:** `djaap` — all core config lives under `lua/djaap/`.
- **Local variables:** `snake_case` (`local wk`, `local on_attach`, `local float_term`).
- **Intentional globals:** `PascalCase` or `UPPER` (`P`, `Session_dir`, `Run_select`).
- **Requires:** all at the top of each file; no lazy inline `require` mid-function.
  ```lua
  local wk = require("which-key")
  local Terminal = require("toggleterm.terminal").Terminal
  ```
- **Plugin specs** in `lua/plugins/` return a single table; auto-discovered by lazy.nvim.
  Simple dependencies as bare strings; configured plugins as `{ "author/name", config = function() ... end }`.
- **Settings:** alias `vim.o` and `vim.g` to `o` and `g` at top of `settings.lua`.
- **Keymaps:** all go through `which-key`'s `wk.add({})` with a `desc` on every entry.
  Group labels registered at the bottom of the `wk.add` call.
- **LSP:** `vim.lsp.enable("server")` + `vim.lsp.config("server", { on_attach, capabilities, settings })`.
  A `-- Language` comment precedes each server block.
- **Error handling:**
  - `pcall` for optional integrations that may not be installed.
  - Guard at the top of `after/plugin/` files: `if plugin == nil then return nil end`.
  - Feature detection: `if vim.fn.has("feature") == 1 then`.
- **Comments:** `--` inline. Section dividers use 80-char dashes:
  ```lua
  --------------------------------------------------------------------------------
  -- LSP Servers
  --------------------------------------------------------------------------------
  ```
  Commented-out experimental blocks use `--[[ ... --]]`.
- **Autogroups:** `snake_case` with `_augroup` suffix (`term_augroup`, `hs_augroup`).
- **ftplugin files** (`after/ftplugin/`) contain only indent settings; keep them minimal.
- **Tab/indent conventions:**
  | Language | tabstop | expandtab |
  |---|---|---|
  | Go, default | 4 | false (tabs) |
  | Nix, Lua, JS, YAML, Gleam, OCaml, Terraform | 2 | true (spaces) |
  | JSON | 2 | false |

---

## General Conventions

- **Live edits without re-switching:** always use `mkOutOfStoreSymlink` for config files
  that the user edits directly. Never copy files into the nix store for user-facing config.
- **Platform differences** are handled in `module/home-manager.nix` with
  `pkgs.stdenv.isDarwin` — keep platform logic centralised there, not in the config files
  themselves.
- **No README or docs files** — prefer self-documenting config with inline comments.
- **No `.cursorrules`, `.github/copilot-instructions.md`, or other AI rule files** exist;
  this file (`AGENTS.md`) is the sole agent reference.
