-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.tools.config')

plugin({ 'gpanders/editorconfig.nvim', event = 'BufReadPre' })
plugin({ 'lewis6991/gitsigns.nvim', event = 'BufReadPost', config = true })
plugin({ 'wakatime/vim-wakatime', event = 'InsertEnter' })
plugin({
  'numToStr/Comment.nvim',
  event = 'BufReadPost',
}, 'both')

plugin({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  config = conf.telescope,
  dependencies = {
    { 'nvim-lua/popup.nvim', lazy = true },
    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'natecraddock/telescope-zf-native.nvim' },
    { 'Sduby22/telescope-fuzzy-grep.nvim', lazy = true },
    -- { 'folke/trouble.nvim', lazy = true },
    -- { 'ahmedkhalf/project.nvim', config=conf.project },
  },
})

plugin({
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  lazy = true,
})

plugin({ 'mg979/vim-visual-multi' }, 'both')
plugin({ 'tpope/vim-surround', event = 'BufReadPost' }, 'both')
plugin({ 'justinmk/vim-sneak', event = 'BufReadPost' }, 'both')

-- plugin({ 'Sduby22/fcitx.nvim', config=function() require('fcitx').setup() end }, 'both')
plugin({
  'tpope/vim-fugitive',
})

plugin({ 'NeogitOrg/neogit', dependencies = { 'nvim-lua/plenary.nvim' }, config = conf.neogit, cmd = 'Neogit' })
-- plugin({ 'sindrets/diffview.nvim', config = conf.diffview })
plugin({
  'sindrets/diffview.nvim',
  config = conf.diffview,
  lazy = true,
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
})

plugin({
  'gennaro-tedesco/nvim-possession',
  lazy = false,
  dependencies = {
    {
      'tiagovla/scope.nvim',
      lazy = false,
      config = true,
    },
  },
  config = function()
    require('nvim-possession').setup({
      autoload = true,
      autosave = true,
      autoswitch = {
        enable = true,
      },
      save_hook = function()
        vim.cmd([[ScopeSaveState]]) -- Scope.nvim saving
      end,
      post_hook = function()
        vim.cmd([[ScopeLoadState]]) -- Scope.nvim loading
      end,
    })
  end,
})

plugin({
  'echasnovski/mini.bufremove',
  version = '*',
  keys = {
    {
      '<leader>bk',
      function()
        require('mini.bufremove').delete(0, false)
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>bK',
      function()
        require('mini.bufremove').delete(0, true)
      end,
      desc = 'Delete Buffer (Force)',
    },
  },
})

plugin({
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'Spectre' },
})

plugin({
  'gabrielpoca/replacer.nvim',
  keys = {
    {
      '<C-e>',
      function()
        require('replacer').run()
      end,
    },
  },
})

plugin({
  'metakirby5/codi.vim',
  cmd = {
    'Codi',
    'CodiNew',
    'CodiSelect',
    'CodiExpand',
  },
  keys = {
    {
      '<leader>x',
      function()
        vim.cmd('Codi typescript')
      end,
    },
  },
})

plugin({ 'RaafatTurki/hex.nvim', opts = {} })
plugin({
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  keys = { {
    '<C-l>',
    function()
      require('neogen').generate({ snippet_engine = 'luasnip' })
    end,
  } },
  opts = {},
})

plugin({
  'natecraddock/workspaces.nvim',
  opts = {
    cd_type = 'tab',
    hooks = {
      open = 'Telescope find_files',
    },
  },
})

plugin({
  'nvim-lua/plenary.nvim',
  lazy = true,
})

plugin({ 'nmac427/guess-indent.nvim', opts = {} })
