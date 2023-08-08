-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.lang.config')

plugin({
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
  config = conf.nvim_treesitter,
  dependencies = {
    { 'windwp/nvim-ts-autotag', lazy = true },
    { 'HiPhish/nvim-ts-rainbow2', event = 'BufReadPost', lazy = true },
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      },
    },
    {
      'folke/twilight.nvim',
      opts = {},
      keys = {
        { '<leader>t', ':Twilight<CR>' },
      },
    },
  },
})

plugin({
  'nvim-treesitter/nvim-treesitter-textobjects',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
})

-- plugin({
--   'simrat39/rust-tools.nvim',
--   ft = { 'rust' },
--   config = conf.rust_tools,
-- })

-- plugin({
--   'p00f/clangd_extensions.nvim',
--   ft = { 'c', 'cpp' },
--   config = conf.clangd_extensions,
-- })

plugin({
  'jose-elias-alvarez/null-ls.nvim',
  config = conf.null_ls,
  event = 'BufWritePre',
  dependencies = { 'nvim-lua/plenary.nvim' },
})

-- plugin({
--   event = 'BufWritePre',
--   'lukas-reineke/lsp-format.nvim',
-- })

plugin({
  'nvim-neorg/neorg',
  build = ':Neorg sync-parsers',
  ft = { 'norg' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('neorg').setup({
      load = {
        ['core.defaults'] = {}, -- Loads default behaviour
        ['core.concealer'] = {}, -- Adds pretty icons to your documents
        ['core.dirman'] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = '~/org',
            },
          },
        },
      },
    })
  end,
})
