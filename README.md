# `nvim` configuration

My wacky `nvim` configuration. I have a [former `.vimrc`] configuration on my
Github gist

[former `.vimrc`]: https://gist.github.com/victor-iyi/f30b8f8a46a6e3711e4ade16a8179a01
[Github gist]: https://gist.github.com/victor-iyi/

## Requirements

- [Alacritty] + [zsh] (recommended)
- `nvim` v0.5+
- `pynvim` & `neovim` - `pip install pynvim neovim`
- `lua` & `luarocks` for telescope. - `brew install lua luarocks`

[Alacritty]: https://github.com/alacritty/alacritty
[zsh]: https://github.com/ohmyzsh/ohmyzsh

## Usage

Clone repo into `~/.config/nvim/` directory.

```sh
$ cd ~/.config/
$ gh repo clone victor-iyi/nvim
# Or
# git clone https://github.com/victor-iyi/nvim
```

Run the [`install`] script.

[`install`]: ./install

```sh
$ ./install
# Creates a symlink to `~/.vimrc`.
```
