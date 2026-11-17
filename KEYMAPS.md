# Keymaps

Every key this config defines, grouped by where it works. Leader is `<Space>`; `<leader>a`
means Space then `a`. Modes: `n` normal, `i` insert, `v`/`x` visual, `o` operator-pending,
`t` terminal. Global keys live in [`lua/config/keymaps.lua`](lua/config/keymaps.lua);
buffer-local and plugin-internal ones are listed with the file that sets them.

Inside Neovim, `:map <leader>c` (or any prefix) lists what is bound, with descriptions.

## Contents

- [General](#general) (and [editing plugins](#editing-plugins-their-defaults))
- [Windows, tabs, tmux](#windows-tabs-tmux)
- [Files & search](#files--search)
- [LSP & diagnostics](#lsp--diagnostics)
- [Completion & snippets](#completion--snippets)
- [Copilot](#copilot)
- [AI: Claude Code, chat, agents](#ai-claude-code-chat-agents)
- [Terminal & lazygit](#terminal--lazygit)
- [Git hunks](#git-hunks)
- [Treesitter text objects & motions](#treesitter-text-objects--motions)
- [Debugging](#debugging)
- [Rust](#rust)
- [Start screen](#start-screen)
- [Inside plugin windows](#inside-plugin-windows)

## General

| Keys                      | Mode    | Action                                     |
| ------------------------- | ------- | ------------------------------------------ |
| `<C-j>`                   | i, v    | Escape                                     |
| `<C-k>`                   | v       | Escape (insert-mode `<C-k>` is Copilot's)  |
| `<leader>w`               | n       | Save file                                  |
| `<leader>r`               | n       | Reload file (`:e!`)                        |
| `H` / `L`                 | n, v, o | Start / end of line                        |
| `<leader>y`               | v       | Yank to system clipboard                   |
| `<leader>p` / `<leader>P` | n       | Paste from system clipboard (after/before) |
| `p`                       | v       | Paste without yanking the selection        |
| `P`                       | v       | Paste the last yank                        |
| `x`                       | n       | Delete character without yanking          |
| `<leader><leader>`        | n       | Alternate buffer                           |
| `<Left>` / `<Right>`      | n       | Previous / next buffer                     |
| `J` / `K`                 | v       | Move selection down / up                   |
| `<leader>nh`              | n       | Clear search highlight                     |
| `<leader>+` / `<leader>-` | n       | Increment / decrement number               |
| `n N * # g* <C-d> <C-u>`  | n       | As usual, and centre the cursor            |
| `<leader>u`               | n       | Undo tree                                  |
| `q`                       | n       | Close help, quickfix, man, checkhealth, …  |

Arrow keys are off in insert mode (`<Up>`/`<Down>` also in normal mode), and `<F1>` does
nothing.

### Editing plugins (their defaults)

| Keys                      | Mode | Action                                        |
| ------------------------- | ---- | --------------------------------------------- |
| `ys{motion}{char}`        | n    | Surround (e.g. `ysiw"`)                       |
| `ds{char}` / `cs{old}{new}` | n  | Delete / change surrounding pair              |
| `S{char}`                 | v    | Surround the selection                        |
| `gcc` / `gc{motion}`      | n    | Toggle line / motion comment                  |
| `gbc` / `gb{motion}`      | n    | Toggle block comment                          |
| `gc` / `gb`               | v    | Comment selection (line / block)              |
| `<C-n>`                   | n, v | Multi-cursor: select word, then next match    |
| `%`                       | n    | Jump between matching pairs (vim-matchup)     |

## Windows, tabs, tmux

| Keys                    | Mode | Action                                             |
| ----------------------- | ---- | -------------------------------------------------- |
| `<C-h/j/k/l>`           | n    | Move between splits **and tmux panes**             |
| `<C-\>`                 | n    | Previous split / tmux pane                         |
| `<leader>sv`            | n    | Split vertically                                   |
| `<leader>sh`            | n    | Split horizontally                                 |
| `<leader>se`            | n    | Equalize splits                                    |
| `<leader>sx`            | n    | Close split                                        |
| `<leader>sm`            | n    | Maximize / restore split                           |
| `<leader>=`             | v    | Equalize windows                                   |
| `<leader>v+` / `v-`     | n    | Widen / narrow split                               |
| `<leader>vr`            | n    | Reset split width (30 columns)                     |
| `<leader>to` / `tx`     | n    | New / close tab                                    |
| `<leader>tn` / `tp`     | n    | Next / previous tab                                |

## Files & search

| Keys         | Mode | Action                       |
| ------------ | ---- | ---------------------------- |
| `<leader>e`  | n    | File tree (nvim-tree)        |
| `<leader>pt` | n    | NERDTree                     |
| `<leader>ff` | n    | Find files                   |
| `<leader>fs` | n    | Find text in project (grep)  |
| `<leader>fc` | n    | Find word under cursor       |
| `<leader>fb` | n    | Find buffers                 |
| `<leader>fh` | n    | Find help                    |

## LSP & diagnostics

Buffer-local, set when a language server attaches ([`lua/config/lsp.lua`](lua/config/lsp.lua)).

| Keys                | Mode | Action                                           |
| ------------------- | ---- | ------------------------------------------------ |
| `K`                 | n    | Hover documentation                              |
| `gd`                | n    | Go to declaration (falls back to definition)     |
| `gD`                | n    | Peek definition                                  |
| `gi`                | n    | Go to implementation                             |
| `gf`                | n    | Finder: definition, references, implementations  |
| `<leader>a`         | n, v | Code action                                      |
| `<leader>rn`        | n    | Rename                                           |
| `<leader>o`         | n    | Outline                                          |
| `<leader>ih`        | n    | Toggle inlay hints (when the server has them)    |
| `<leader>dl`        | n    | Line diagnostics                                 |
| `<leader>dc`        | n    | Cursor diagnostics                               |
| `[d` / `]d`         | n    | Previous / next diagnostic                       |
| `[e` / `]e`         | n    | Previous / next **error**                        |
| `<leader>dv`        | n    | Toggle inline diagnostics ↔ full virtual lines   |
| `<leader>f`         | n    | Format buffer                                    |
| `<leader>F`         | n    | Format and write                                 |
| `<leader>xx`        | n    | Trouble: workspace diagnostics                   |
| `<leader>xX`        | n    | Trouble: buffer diagnostics                      |
| `<leader>xq` / `xl` | n    | Trouble: quickfix / location list                |

Neovim 0.12's own defaults also work: `grr` references, `gra` code action, `grn` rename,
`grt` type definition, `gO` document symbols, `<C-s>` signature help (insert).

## Completion & snippets

In insert mode while the completion menu (nvim-cmp) is open or a snippet is active.

| Keys                | Action                                       |
| ------------------- | -------------------------------------------- |
| `<Tab>` / `<S-Tab>` | Next / previous item, or jump through snippet |
| `<C-n>` / `<C-p>`   | Next / previous item                         |
| `<CR>`              | Confirm                                      |
| `<C-Space>`         | Open the menu                                |
| `<C-e>`             | Close the menu                               |
| `<C-b>` / `<C-f>`   | Scroll documentation                         |

## Copilot

Ghost-text suggestions appear as you type; "next edit" suggestions (multi-line changes
Copilot expects you to make next) appear after you pause, as an inline diff.

| Keys         | Mode | Action                                                          |
| ------------ | ---- | --------------------------------------------------------------- |
| `<C-l>`      | i    | Accept suggestion (newline when none is showing)                |
| `<C-]>`      | i    | Next suggestion                                                 |
| `<C-[>`      | i    | Previous suggestion; Escape when none is showing                |
| `<C-k>`      | i    | Dismiss suggestion; Escape when none is showing                 |
| `<Tab>`      | n    | Jump to the next edit, then apply it; plain `<Tab>` when none   |
| `<leader>cn` | n    | Turn next-edit suggestions on / off                             |

`:Copilot setup` signs in, `:Copilot status` shows the state, `:Copilot disable` /
`enable` turns ghost text off and on.

## AI: Claude Code, chat, agents

All under `<leader>c`. `<leader>a` stays code action.

### Claude Code panel

Claude Code runs in a split on the right and sees your open file and selection. Hiding the
panel keeps Claude running.

| Keys         | Mode | Action                                               |
| ------------ | ---- | ---------------------------------------------------- |
| `<leader>cc` | n    | Show / hide the Claude panel                         |
| `<leader>cf` | n    | Jump into the Claude panel                           |
| `<C-h>`      | t    | In the Claude panel: back to your code               |
| `<leader>cr` | n    | Resume an earlier Claude session (picker)            |
| `<leader>cC` | n    | Continue the last Claude session                     |
| `<leader>cm` | n    | Choose the Claude model                              |
| `<leader>cb` | n    | Add the current file to Claude's context             |
| `<leader>cs` | v    | Send the selection to Claude                         |
| `<leader>cs` | n    | In the file tree: add the file under the cursor      |
| `<leader>cy` | n    | Accept Claude's proposed diff (`:w` in it does too)  |
| `<leader>cd` | n    | Reject Claude's proposed diff                        |

### Chat, inline edits, prompts (CodeCompanion)

Chats use Copilot's models by default; `ga` in a chat switches model or provider.

| Keys         | Mode | Action                                                    |
| ------------ | ---- | --------------------------------------------------------- |
| `<leader>ca` | n    | Show / hide the chat                                      |
| `<leader>ca` | v    | Add the selection to the chat                             |
| `<leader>cA` | n    | New chat with the Claude Code agent                       |
| `<leader>ci` | n, v | Inline edit: type a request, review the diff              |
| `<leader>ce` | v    | Explain the selection                                     |
| `<leader>cx` | v    | Fix the selection                                         |
| `<leader>cp` | n, v | All prompts and actions                                   |
| `<leader>c:` | n    | Describe a Neovim command in words, get the command       |

### Shell commands and other AI tools

| Keys         | Mode | Action                                                                   |
| ------------ | ---- | ------------------------------------------------------------------------ |
| `<leader>c?` | n    | Describe a shell task; the command is typed into the `<leader>ft` terminal |
| `<C-g>`      | t    | Same, inside the `<leader>ft` terminal (also reads its recent output)    |
| `<leader>ct` | n    | Open another AI CLI (Codex, Gemini, OpenCode, …) if installed            |

Suggested commands are typed, never run: press `<Enter>` yourself.

## Terminal & lazygit

| Keys         | Mode    | Action                                      |
| ------------ | ------- | ------------------------------------------- |
| `<leader>ft` | n, i, t | Floating terminal (toggle)                  |
| `<leader>gg` | n       | Lazygit (floating)                          |
| `<C-\><C-n>` | t       | Leave terminal typing mode (Neovim default) |

In lazygit's **Files** panel:

| Keys    | Action                                                                     |
| ------- | -------------------------------------------------------------------------- |
| `<c-a>` | Claude writes a commit message for the staged changes into the commit box; `<enter>` commits, `<esc>` keeps it as a draft |

It follows the repository's own commit convention, or Conventional Commits with a bulleted
body when there is none. Also listed under `?` in lazygit.

## Git hunks

Buffer-local in files tracked by git ([`lua/plugins/git.lua`](lua/plugins/git.lua)).

| Keys          | Mode | Action                                          |
| ------------- | ---- | ----------------------------------------------- |
| `]c` / `[c`   | n    | Next / previous hunk (native meaning in diffs)  |
| `<leader>hp`  | n    | Preview hunk inline                             |
| `<leader>hs`  | n    | Stage hunk                                      |
| `<leader>hr`  | n    | Reset hunk                                      |
| `<leader>hd`  | n    | Diff against the index                          |
| `ih`          | o, x | Select hunk                                     |

## Treesitter text objects & motions

| Keys          | Mode    | Action                               |
| ------------- | ------- | ------------------------------------ |
| `af` / `if`   | x, o    | Around / inside function             |
| `ac` / `ic`   | x, o    | Around / inside class                |
| `aa` / `ia`   | x, o    | Around / inside parameter            |
| `]m` / `[m`   | n, x, o | Next / previous function start       |
| `]M` / `[M`   | n, x, o | Next / previous function end         |

## Debugging

| Keys                   | Action                      |
| ---------------------- | --------------------------- |
| `<F5>`                 | Start / continue            |
| `<S-F5>`               | Stop                        |
| `<F9>` / `<leader>db`  | Toggle breakpoint           |
| `<leader>dB`           | Conditional breakpoint      |
| `<F10>`                | Step over                   |
| `<F11>` / `<S-F11>`    | Step into / out             |
| `<leader>du`           | Toggle the debug UI         |

## Rust

Buffer-local in Rust files ([`after/ftplugin/rust.lua`](after/ftplugin/rust.lua)).

| Keys                  | Action                                |
| --------------------- | ------------------------------------- |
| `<leader>rr`          | Runnables                             |
| `<leader>rd`          | Debuggables                           |
| `<leader>rt`          | Testables                             |
| `<leader>rm`          | Expand macro                          |
| `<leader>re`          | Explain error                         |
| `<leader>rc`          | Open Cargo.toml                       |

## Start screen

On a bare `nvim` ([`lua/config/dashboard.lua`](lua/config/dashboard.lua)).

| Keys        | Action          | Keys | Action         |
| ----------- | --------------- | ---- | -------------- |
| `f`         | Find file       | `a`  | Claude Code    |
| `s`         | Find text       | `c`  | Config files   |
| `r`         | Recent files    | `u`  | Update plugins |
| `e`         | File tree       | `m`  | Mason          |
| `n`         | New file        | `q`  | Quit           |
| `g`         | Lazygit         | `1`–`8` | Open a recent file |

`j` / `k` move between entries, `<CR>` opens the one under the cursor.

## Inside plugin windows

### Telescope (prompt)

| Keys              | Action                           |
| ----------------- | -------------------------------- |
| `<C-j>` / `<C-k>` | Next / previous result           |
| `<C-q>`           | Send results to the quickfix list |
| `<Esc>`           | Close                            |

### File tree (nvim-tree)

The previous config's layout; `?` or `g?` shows them all.

| Keys                  | Action                          |
| --------------------- | ------------------------------- |
| `<CR>` / `o`          | Open                            |
| `s` / `<C-v>`         | Open in a vertical split        |
| `i` / `<C-x>`         | Open in a horizontal split      |
| `<C-t>`               | Open in a new tab               |
| `<Tab>` / `go`        | Preview                         |
| `a`                   | Create file or folder (end with `/`) |
| `r` / `e`             | Rename / rename basename        |
| `d` / `D`             | Delete / move to trash          |
| `x` / `c` / `p`       | Cut / copy / paste              |
| `y` / `Y` / `gy`      | Copy name / relative / absolute path |
| `cd` / `<C-]>`        | Make folder the root            |
| `u` / `-`             | Root up one level               |
| `P` / `<BS>`          | Parent folder / close folder    |
| `<C-j>` / `<C-k>`     | Next / previous sibling         |
| `J` / `K`             | Last / first sibling            |
| `E` / `W` / `X`       | Expand all / collapse all       |
| `]c` / `[c`           | Next / previous git change      |
| `]e` / `[e`           | Next / previous diagnostic      |
| `f` / `F`             | Filter / clear filter           |
| `H` / `I` / `U` / `B` / `C` | Toggle dotfiles / ignored / hidden / no-buffer / git-clean |
| `m` / `bmv`           | Bookmark / move bookmarked      |
| `S`                   | Search                          |
| `R`                   | Refresh                         |
| `.`                   | Run a command on the file       |
| `q`                   | Close                           |
| `<leader>cs`          | Add the file to Claude's context |

### AI chat (CodeCompanion)

| Keys                  | Mode | Action                                    |
| --------------------- | ---- | ----------------------------------------- |
| `<CR>` / `<C-s>`      | n / i | Send                                     |
| `q`                   | n    | Stop the current request                  |
| `<C-c>`               | n, i | Close the chat                            |
| `ga`                  | n    | Change model / provider                   |
| `gr`                  | n    | Regenerate the last answer                |
| `gx`                  | n    | Clear the chat                            |
| `gy`                  | n    | Yank the last code block                  |
| `{` / `}`             | n    | Previous / next chat                      |
| `[[` / `]]`           | n    | Previous / next message                   |
| `g1` `g2` `g3` `g4`   | n    | Tool approval: always / once / reject / cancel all |
| `gty`                 | n    | Stop asking for tool approval in this chat |
| `?`                   | n    | All chat keys                             |

In a chat, `#` adds editor context (`#{buffer}`, `#{selection}`, `#{diagnostics}`, …), `@`
adds tools (`@{files}`, `@{agent}`), and `/` runs slash commands (`/mcp` starts an MCP server).

### Claude Code panel (terminal)

| Keys          | Action                                     |
| ------------- | ------------------------------------------ |
| `<C-h>`       | Back to your code (Claude keeps running)   |
| `<C-\><C-n>`  | Leave typing mode, stay in the panel       |
| `<C-z>`       | Suspend Neovim (as anywhere else)          |

### Other AI CLI panel (`<leader>ct`)

| Keys                  | Mode | Action                                  |
| --------------------- | ---- | --------------------------------------- |
| `<C-.>`               | n, t | Hide the panel                          |
| `q` / `<C-q>`         | n    | Hide the panel                          |
| `<C-z>`               | n, t | Back to the previous window, panel stays |
| `<C-p>`               | t    | Insert a prompt or editor context       |
| `<C-b>` / `<C-f>`     | n, t | Pick buffers / files to send            |
| `<C-h/j/k/l>`         | t    | Move to the window in that direction    |
