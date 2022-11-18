# `nvim` configuration

My wacky `nvim` configuration. I have a [former `.vimrc`] configuration on my
[Github gist]

## Requirements

- Terminal + [zsh] (iTerm recommended)
- `nvim` v0.8+
- `pynvim` & `neovim` - `pip install pynvim neovim`
- `lua` & `luarocks` for telescope. - `brew install lua luarocks`

## Usage

Clone repo into `~/.config/nvim/` directory.

```sh
$ gh repo clone victor-iyi/nvim ~/.config/nvim

# Or

$ git clone https://github.com/victor-iyi/nvim ~/.config/nvim
```

## TODO

- [ ] Use a good commenter with convinent file association.
  - [nerdcommenter]
  - [kommentary]
  - [vim-commentary]

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

[former `.vimrc`]: https://gist.github.com/victor-iyi/f30b8f8a46a6e3711e4ade16a8179a01
[Github gist]: https://gist.github.com/victor-iyi/
[zsh]: https://github.com/ohmyzsh/ohmyzsh
[nerdcommenter]: https://github.com/preservim/nerdcommenter
[kommentary]: https://github.com/b3nj5m1n/kommentary
[vim-commentary]: https://github.com/tpope/vim-commentary
[original repository]: https://github.com/victor-iyi/nvim
[issues]: https://github.com/victor-iyi/nvim/issues
