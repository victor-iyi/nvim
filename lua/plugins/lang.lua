-- Language-specific setup: Rust, Python, Markdown.

-- ── Rust ────────────────────────────────────────────────────────────────────────────────

-- rustaceanvim starts rust-analyzer itself (it is deliberately absent from config/lsp.lua);
-- shared LSP keymaps still apply through LspAttach. Rust-only maps are in
-- after/ftplugin/rust.lua.
vim.g.rustaceanvim = {
  tools = {
    float_win_config = { border = 'rounded' },
    enable_clippy = true,
  },
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
        check = { command = 'clippy', extraArgs = { '--no-deps' } },
        procMacro = { enable = true },
        imports = { granularity = { group = 'module' }, prefix = 'self' },
        inlayHints = {
          closureReturnTypeHints = { enable = 'with_block' },
          lifetimeElisionHints = { enable = 'skip_trivial' },
        },
        files = { excludeDirs = { '.git', 'target', 'node_modules', '.venv' } },
      },
    },
  },
}

-- ── Python ──────────────────────────────────────────────────────────────────────────────

-- Activate the project's virtualenv for everything Neovim spawns (terminals, :!python,
-- debugger, test runners) — what vim-python-virtualenv was meant to do.
local function activate_venv(dir)
  if vim.env.VIRTUAL_ENV then
    return
  end

  for _, name in ipairs({ '.venv', 'venv' }) do
    local venv = vim.fs.joinpath(dir, name)

    if vim.uv.fs_stat(vim.fs.joinpath(venv, 'bin', 'python')) then
      vim.env.VIRTUAL_ENV = venv
      vim.env.PATH = vim.fs.joinpath(venv, 'bin') .. ':' .. vim.env.PATH
      return
    end
  end
end

activate_venv(vim.fn.getcwd())

vim.api.nvim_create_autocmd('DirChanged', {
  group = vim.api.nvim_create_augroup('config.venv', { clear = true }),
  desc = 'Activate the project virtualenv',
  callback = function()
    activate_venv(vim.fn.getcwd())
  end,
})

-- ── Markdown ────────────────────────────────────────────────────────────────────────────

vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_auto_close = 1

require('render-markdown').setup({
  file_types = { 'markdown' },
  link = {
    enabled = true,
    render_modes = false,
    footnote = { enabled = true, superscript = true, prefix = '', suffix = '' },
    image = '󰥶 ',
    email = '󰀓 ',
    hyperlink = '󰌹 ',
    highlight = 'RenderMarkdownLink',
    wiki = {
      icon = '󱗖 ',
      body = function()
        return nil
      end,
      highlight = 'RenderMarkdownWikiLink',
    },
    custom = {
      web = { pattern = '^http', icon = '󰖟 ' },
      discord = { pattern = 'discord%.com', icon = '󰙯 ' },
      github = { pattern = 'github%.com', icon = '󰊤 ' },
      gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
      google = { pattern = 'google%.com', icon = '󰊭 ' },
      neovim = { pattern = 'neovim%.io', icon = '\u{e7c5} ' },
      reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
      stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
      wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
      youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
    },
  },
  bullet = {
    enabled = true,
    render_modes = false,
    icons = { '●', '○', '◆', '◇' },
    ordered_icons = function(ctx)
      local value = vim.trim(ctx.value)
      local index = tonumber(value:sub(1, #value - 1))

      return ('%d.'):format(index > 1 and index or ctx.index)
    end,
    left_pad = 0,
    right_pad = 0,
    highlight = 'RenderMarkdownBullet',
    scope_highlight = {},
  },
})
