# `nvim` configuration

My wacky `nvim` configuration. I have a [former `.vimrc`] configuration on my
[Github gist]

## Versions

I maintain [two versions] of this configuration. One version is configured with
older vim script, while the other is configured in the modern Lua (only works
with modern versions of Neovim).

- Lua Script - [main]
- Vim Script - [vim-config]

## Requirements

- Terminal + [zsh] (iTerm recommended)
- `nvim` v0.8+ - `brew install neovim`
- `lua` & `luarocks` - `brew install lua luarocks`
- `npm` v8.15  - `brew install node`
- `tree-sitter` v0.20+ - `npm i -g tree-sitter`
- `pynvim` & `neovim` - `pip install pynvim neovim` (optional)

## Usage

Clone repo into `~/.config/nvim/` directory.

```sh
git clone https://github.com/victor-iyi/nvim ~/.config/nvim
```

...or install use the [GitHub CLI][gh] to clone it, if you have that setup.

```sh
gh repo clone victor-iyi/nvim ~/.config/nvim
```

## Contribution

You are very welcome to modify and use them in your own projects.

Please keep a link to the [original repository]. If you have made a fork with
substantial modifications that you feel may be useful, then please
[open a new issue on GitHub][issues] with a link and short description.

## License (Apache 2.0)

This project is opened under the [Apache 2.0] which allows very broad use for
both private and commercial purposes.

A few of the images used for demonstration purposes may be under copyright.
These images are included under the "fair useage" laws.

[two versions]: https://github.com/victor-iyi/nvim/branches
[main]: https://github.com/victor-iyi/nvim
[vim-config]: https://github.com/victor-iyi/nvim/tree/vim-config
[gh]: https://docs.github.com/en/github-cli
[former `.vimrc`]: https://gist.github.com/victor-iyi/f30b8f8a46a6e3711e4ade16a8179a01
[Github gist]: https://gist.github.com/victor-iyi/
[zsh]: https://github.com/ohmyzsh/ohmyzsh
[original repository]: https://github.com/victor-iyi/nvim
[issues]: https://github.com/victor-iyi/nvim/issues
[Apache 2.0]: ./LICENSE
