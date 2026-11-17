# nvim

Personal Neovim configuration, rebuilt from scratch for **Neovim 0.12+**: the built-in
`vim.pack` plugin manager, native `vim.lsp.config` / `vim.lsp.enable`, and treesitter
from core. It's tuned for Python and Rust, with first-class Lua, TypeScript and Go, and
designed to run inside tmux. AI is built in: Copilot completions and next-edit
suggestions, Claude Code in a side panel, chat and agents with MCP, shell-command help in
the terminal, and commit messages in lazygit.

Every key is documented in **[KEYMAPS.md](KEYMAPS.md)**.

## Install

```sh
git clone https://github.com/victor-iyi/nvim ~/.config/nvim
nvim   # plugins install from nvim-pack-lock.json; Mason installs servers & tools
```

Requirements: Neovim ≥ 0.12, git, make, a C compiler, ripgrep, curl, Node (for Copilot
and some servers), and a Nerd Font. Optional: `lazygit`, a Rust toolchain (`rustfmt`), and
for the AI features:

```sh
curl -fsSL https://claude.ai/install.sh | bash               # Claude Code (`claude`)
npm install -g --omit=optional @agentclientprotocol/claude-agent-acp   # Claude Code agent in chats
```

Then sign in once: `:Copilot setup` in any file, and `claude` → `/login` in a terminal.

To try it next to an existing config, clone it to `~/.config/nvim-v0.12` and run
`NVIM_APPNAME=nvim-v0.12 nvim`. It gets its own data directory, so nothing is shared.

## Layout

```text
init.lua                 load order
filetype.lua             extra filetype detection
nvim-pack-lock.json      pinned plugin revisions (commit it)
KEYMAPS.md               every keymap, documented
lua/config/
  options.lua            editor options
  keymaps.lua            every global keymap, in one place
  autocmds.lua           yank flash, restore cursor, tmux focus reload, ...
  diagnostics.lua        signs, virtual text / virtual lines
  pack.lua               plugin list + build hooks
  lsp.lua                enabled servers + buffer-local LSP keymaps
  dashboard.lua          start screen for a bare `nvim`
lua/plugins/             one file per area (ui, editor, treesitter, telescope, ...)
  copilot.lua            Copilot through Neovim's own LSP client
  ai.lua                 next edits, Claude Code, chat/agents, MCP
lua/ai/
  shell.lua              "how do I ...?" → a shell command in the terminal
  lazygit.lua            opens lazygit's commit box once Claude's message is ready
lazygit/                 extra lazygit config used from Neovim (AI commit messages)
after/lsp/<server>.lua   per-server overrides merged over nvim-lspconfig
after/ftplugin/rust.lua  Rust-only keymaps
lint/                    relaxed base configs for projects that have none
```

## Linting & formatting

The project decides. Every linter and formatter reads the project's own config first;
these defaults apply only where a project has none.

| Language   | Project config that wins                          | Default without one                                           |
| ---------- | ------------------------------------------------- | ------------------------------------------------------------- |
| Python     | `pyproject.toml` / `ruff.toml`, `[tool.pyright]`  | ruff's default rules; basedpyright `standard`, no duplicates  |
| Rust       | `Cargo.toml` `[lints]`, `clippy.toml`, `rustfmt.toml` | clippy defaults; `~/.config/rustfmt/rustfmt.toml`; Cargo edition |
| Lua        | `stylua.toml`, `.luarc.json`                      | 2 spaces, single quotes                                       |
| TS / JS    | `tsconfig.json`, ESLint config, `.prettierrc`     | ESLint only runs when the project has a config                |
| Go         | `.golangci.yml`                                   | gopls + staticcheck; golangci-lint only with a config         |
| Markdown   | `.markdownlint*` (nearest, even in a sub-folder)  | `lint/.markdownlint.yaml`: no line length, table style, HTML  |
| Dockerfile | `.hadolint.yaml`                                  | `lint/hadolint.yaml`: no version-pinning nags                 |

Inline diagnostic text shows warnings and errors only; hints (unused, inactive code)
grey out the code and stay in `<leader>dl`, `]d` and Trouble.

## AI

On by default, out of the way until you reach for it. All keys are under `<leader>c`
(`<leader>a` stays code action); see [KEYMAPS.md](KEYMAPS.md#ai-claude-code-chat-agents).

| Feature | How | Powered by |
| --- | --- | --- |
| Ghost-text completions | As you type; `<C-l>` accepts, `<C-]>`/`<C-[>` cycle, `<C-k>` dismisses | Copilot, through Neovim's built-in `vim.lsp.inline_completion` |
| Next-edit suggestions | After you pause, multi-line edits show as a diff; `<Tab>` jumps, then applies | Copilot via [sidekick.nvim](https://github.com/folke/sidekick.nvim) |
| Claude Code in the editor | `<leader>cc` side panel; Claude sees your file and selection, its edits open as diffs (`<leader>cy` accept, `<leader>cd` reject); `<C-h>` back to code | [claudecode.nvim](https://github.com/coder/claudecode.nvim) |
| Chat and inline edits | `<leader>ca` chat, `<leader>ci` edit in place, `<leader>cp` prompts (explain, fix, tests, …) | [CodeCompanion](https://github.com/olimorris/codecompanion.nvim), Copilot's models |
| Agents | `<leader>cA` chats with the Claude Code agent; `<leader>ct` opens other AI CLIs (Codex, Gemini, …) | CodeCompanion over ACP, sidekick |
| MCP | Chats get the stdio servers you add to Claude Code (`claude mcp add …`, a project's `.mcp.json`); Context7 docs via `/mcp` | CodeCompanion |
| Shell-command help | `<C-g>` in the `<leader>ft` terminal (or `<leader>c?` anywhere): describe the task, the command is typed in for you to run | `claude -p` (Haiku) |
| Commit messages | lazygit Files panel `<c-a>`: the message lands in lazygit's commit box, following the repo's own convention, or Conventional Commits with a bulleted body | `claude -p` (Sonnet 5.5) |

Notes:

- The Copilot language server comes from the `copilot.vim` plugin, which is installed and
  updated but never loaded: no separate download, and `vim.pack.update()` keeps it current.
- Claude Code's local IDE server starts with Neovim, so a `claude` in another tmux pane
  can connect too (`/ide`). The status line shows **Claude** while one is connected, and a
  Copilot icon (red when it needs attention).
- The commit-message model is set by `AI_COMMIT_MODEL` (default `claude-sonnet-5-5`).
  The lazygit key is in `lazygit/config.yml`, loaded on top of your own lazygit config only
  when lazygit is opened with `<leader>gg`.

## Start screen

`nvim` with no file opens the file tree and a welcome screen: single-key actions
(`f` find file, `s` find text, `r` recent, `e` tree, `n` new, `g` lazygit, `a` Claude Code,
`c` config, `u` update plugins, `m` Mason, `q` quit) and recent files on `1`–`8`. `j` / `k`
move between entries, `<CR>` opens one. `nvim <file>`, `nvim .` and piped input skip it.

## Maintenance

| Task                    | Command                                         |
| ----------------------- | ----------------------------------------------- |
| Update plugins          | `:lua vim.pack.update()` (or `u` on the start screen) → review → `:write` |
| Match the lockfile      | `:lua vim.pack.update(nil, { target = 'lockfile' })` (after a `git pull`) |
| Roll back an update     | `git checkout nvim-pack-lock.json` → `:restart` |
| Remove a dropped plugin | `:lua vim.pack.del({ 'name' })`                 |
| Servers & tools         | `:Mason`                                        |
| Parsers                 | `:TSUpdate`, `:TSInstall <lang>`                |
| LSP status              | `:checkhealth vim.lsp`, `:lsp`                  |
| Copilot                 | `:Copilot setup` / `status` / `enable` / `disable` |
| AI health               | `:checkhealth sidekick codecompanion claudecode` |
| Recent messages         | `g<`                                            |

## Keymaps

Leader is `<Space>`. Everything from the previous (packer) config is unchanged; new keys
were only added where nothing was bound. **[KEYMAPS.md](KEYMAPS.md)** lists every key,
including those inside the file tree, Telescope, the AI chat and the Claude panel.

The ones you'll reach for most:

| Keys                  | Action                      | Keys                | Action                  |
| --------------------- | --------------------------- | ------------------- | ----------------------- |
| `<leader>ff` / `fs`   | Find files / text           | `<leader>e`         | File tree               |
| `<leader>w`           | Save                        | `<leader><leader>`  | Alternate buffer        |
| `<C-h/j/k/l>`         | Splits and tmux panes       | `<leader>sv` / `sh` | Split                   |
| `gd` / `K` / `gf`     | Definition / hover / finder | `<leader>a` / `rn`  | Code action / rename    |
| `[d` `]d` / `[e` `]e` | Diagnostics / errors        | `<leader>f`         | Format                  |
| `<leader>ft`          | Terminal                    | `<leader>gg`        | Lazygit                 |
| `<C-l>` (insert)      | Accept Copilot              | `<Tab>` (normal)    | Apply next edit         |
| `<leader>cc`          | Claude Code panel           | `<leader>ca`        | AI chat                 |
| `<leader>ci`          | AI inline edit              | `<C-g>` (terminal)  | Suggest a shell command |

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
