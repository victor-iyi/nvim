-- Extra filetype detection (replaces filetype.nvim, which core Neovim made redundant).
vim.filetype.add({
  filename = {
    ['.flake8'] = 'dosini',
    ['aliases'] = 'sh',
    ['.aliases'] = 'sh',
    ['functions'] = 'sh',
    ['.functions'] = 'sh',
    ['tmux.conf'] = 'tmux',
    ['.tmux.conf'] = 'tmux',
    ['.env'] = 'sh',
  },
  pattern = {
    ['%.env%.[%w_.-]+'] = 'sh',
    ['Dockerfile[%w_.-]*'] = 'dockerfile',
    ['[%w_.-]+%.Dockerfile'] = 'dockerfile',
  },
})
