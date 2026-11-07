# nvim

Personal Neovim configuration, rebuilt from scratch for **Neovim 0.12+**: the built-in
`vim.pack` plugin manager, native `vim.lsp.config` / `vim.lsp.enable`, and treesitter
from core. It's tuned for Python and Rust, with first-class Lua, TypeScript and Go, and
designed to run inside tmux.

## Install

```sh
git clone https://github.com/victor-iyi/nvim ~/.config/nvim
nvim   # plugins install from nvim-pack-lock.json; Mason installs servers & tools
```

Requirements: Neovim ≥ 0.12, git, make, a C compiler, ripgrep, Node (for Copilot and
some servers), and a Nerd Font. Optional: `lazygit`, a Rust toolchain (`rustfmt`).

To try it next to an existing config, clone it to `~/.config/nvim-v0.12` and run
`NVIM_APPNAME=nvim-v0.12 nvim`. It gets its own data directory, so nothing is shared.

## Layout

```
init.lua                 load order
filetype.lua             extra filetype detection
nvim-pack-lock.json      pinned plugin revisions (commit it)
lua/config/
  options.lua            editor options
  keymaps.lua            every global keymap, in one place
  autocmds.lua           yank flash, restore cursor, tmux focus reload, ...
  diagnostics.lua        signs, virtual text / virtual lines
  pack.lua               plugin list + build hooks
  lsp.lua                enabled servers + buffer-local LSP keymaps
lua/plugins/             one file per area (ui, editor, treesitter, telescope, ...)
after/lsp/<server>.lua   per-server overrides merged over nvim-lspconfig
after/ftplugin/rust.lua  Rust-only keymaps
```

## Maintenance

| Task                    | Command                                         |
| ----------------------- | ----------------------------------------------- |
| Update plugins          | `:lua vim.pack.update()` → review → `:write`    |
| Roll back an update     | `git checkout nvim-pack-lock.json` → `:restart` |
| Remove a dropped plugin | `:lua vim.pack.del({ 'name' })`                 |
| Servers & tools         | `:Mason`                                        |
| Parsers                 | `:TSUpdate`, `:TSInstall <lang>`                |
| LSP status              | `:checkhealth vim.lsp`, `:lsp`                  |
| Recent messages         | `g<`                                            |

## Keymaps

Leader is `<Space>`. Everything from the previous (packer) config is unchanged.

### General

| Keys                      | Mode  | Action                                  |
| ------------------------- | ----- | --------------------------------------- |
| `<C-j>` / `<C-k>`         | i, v  | Escape                                  |
| `<leader>w` / `<leader>r` | n     | Save / reload file (`:e!`)              |
| `H` / `L`                 | n v o | Start / end of line                     |
| `<leader>y`               | v     | Yank to system clipboard                |
| `<leader>p` / `<leader>P` | n     | Paste from system clipboard             |
| `p` / `P`                 | v     | Paste without yanking / paste last yank |
| `x`                       | n     | Delete char without yanking             |
| `<leader><leader>`        | n     | Alternate buffer                        |
| `<Left>` / `<Right>`      | n     | Previous / next buffer                  |
| `J` / `K`                 | v     | Move selection down / up                |
| `<leader>nh`              | n     | Clear search highlight                  |
| `<leader>+` / `<leader>-` | n     | Increment / decrement number            |
| `n N * # g* <C-d> <C-u>`  | n     | ...and centre the cursor                |

### Windows, tabs, tmux

| Keys                        | Action                                 |
| --------------------------- | -------------------------------------- |
| `<C-h/j/k/l>`, `<C-\>`      | Move between splits **and tmux panes** |
| `<leader>sv` / `<leader>sh` | Split vertically / horizontally        |
| `<leader>se` / `<leader>sx` | Equalize / close split                 |
| `<leader>sm`                | Maximize / restore split               |
| `<leader>v+ v- vr`          | Widen / narrow / reset split width     |
| `<leader>to tx tn tp`       | New / close / next / previous tab      |
| `<leader>ft`                | Floating terminal (toggle)             |
| `<leader>gg`                | Lazygit (floating)                     |

### Files & search

| Keys         | Action                 |
| ------------ | ---------------------- |
| `<leader>e`  | nvim-tree              |
| `<leader>pt` | NERDTree               |
| `<leader>u`  | Undo tree              |
| `<leader>ff` | Find files             |
| `<leader>fs` | Live grep              |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | Buffers                |
| `<leader>fh` | Help tags              |

In Telescope: `<C-j>` / `<C-k>` move, `<C-q>` send to quickfix, `<Esc>` closes.

### LSP (buffer-local)

| Keys                | Action                                          |
| ------------------- | ----------------------------------------------- |
| `K`                 | Hover docs                                      |
| `gd`                | Go to declaration (falls back to definition)    |
| `gD`                | Peek definition                                 |
| `gi`                | Go to implementation                            |
| `gf`                | Finder: definition, references, implementations |
| `<leader>a`         | Code action (n, v)                              |
| `<leader>rn`        | Rename                                          |
| `<leader>o`         | Outline                                         |
| `<leader>dl` / `dc` | Line / cursor diagnostics                       |
| `[d` / `]d`         | Previous / next diagnostic                      |
| `[e` / `]e`         | Previous / next **error**                       |
| `<leader>f` / `F`   | Format / format and write (also on save)        |

Core 0.12 defaults still work too: `grr` references, `gra` code action, `grn` rename,
`grt` type definition, `gO` document symbols, `<C-s>` signature help (insert).

### Copilot (insert)

| Keys    | Action                                                     |
| ------- | ---------------------------------------------------------- |
| `<C-l>` | Accept suggestion                                          |
| `<C-]>` | Next suggestion                                            |
| `<C-[>` | Previous suggestion — Escape when no suggestion is showing |
| `<C-k>` | Dismiss suggestion — Escape when no suggestion is showing  |

### Completion (insert)

`<Tab>` / `<S-Tab>` (or `<C-n>` / `<C-p>`) select or jump through snippets, `<CR>`
confirms, `<C-Space>` opens, `<C-e>` aborts, `<C-b>` / `<C-f>` scroll docs.

### Added in this rebuild

None of these replace an existing key.

| Keys                        | Action                                          |
| --------------------------- | ----------------------------------------------- |
| `<leader>dv`                | Toggle inline diagnostics ↔ full virtual lines  |
| `<leader>ih`                | Toggle inlay hints                              |
| `<leader>xx` / `xX`         | Trouble: workspace / buffer diagnostics         |
| `<leader>xq` / `xl`         | Trouble: quickfix / location list               |
| `]c` / `[c`                 | Next / previous git hunk (diff mode unchanged)  |
| `<leader>hp hs hr hd`       | Hunk preview / stage / reset / diff             |
| `af if ac ic aa ia`         | Function / class / parameter text objects       |
| `]m [m ]M [M`               | Next / previous function start / end            |
| `<F5>` `<S-F5>`             | Debug: continue / stop                          |
| `<F9>` / `<leader>db`       | Toggle breakpoint                               |
| `<F10>` `<F11>` `<S-F11>`   | Step over / into / out                          |
| `<leader>dB` / `<leader>du` | Conditional breakpoint / toggle debug UI        |
| `<leader>rr rd rt`          | Rust: runnables / debuggables / testables       |
| `<leader>rm re rc`          | Rust: expand macro / explain error / Cargo.toml |

## tmux

`vim-tmux-navigator` must also be in `~/.tmux.conf` (it already is, via TPM). For true
colour, undercurls, focus-reload and clipboard through tmux, add:

```tmux
set -g default-terminal "tmux-256color"
set -as terminal-features ",*:RGB"
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
set -g focus-events on
set -sg escape-time 10
set -s set-clipboard on
set -g allow-passthrough on
```
