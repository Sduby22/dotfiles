local config = {}

function config.nvim_treesitter()
  vim.api.nvim_command('set foldmethod=expr')
  vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    ignore_install = { 'phpdoc' },
    highlight = {
      enable = true,
      disable = function(lang, bufnr) -- Disable in large C++ buffers
        return vim.fn.wordcount().bytes > 1024 * 1024 * 2
      end,
    },
    autotag = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },
    indent = {
      enable = true,
    },
    -- rainbow = {
    --   enable = true,
    --   disable = { 'jsx' },
    --   query = 'rainbow-parens',
    --   strategy = require('ts-rainbow').strategy.global,
    -- },
  })
end

function config.null_ls()
  local null_ls = require('null-ls')
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.clang_format,
      null_ls.builtins.formatting.taplo,
    },
    on_attach = require('keymap.lsp_onattach'),
  })
end

return config
