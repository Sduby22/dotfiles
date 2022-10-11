-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.telescope()
  if not packer_plugins['plenary.nvim'].loaded then
    vim.cmd([[packadd plenary.nvim]])
    vim.cmd([[packadd popup.nvim]])
    vim.cmd([[packadd telescope-fzy-native.nvim]])
    vim.cmd([[packadd telescope-file-browser.nvim]])
  end

  local actions = require "telescope.actions"
  require('telescope').setup({
    defaults = {
      mappings = {
        i = {
          ["<C-h>"] = "which_key",
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous
        }
      },
      layout_config = {
        horizontal = { prompt_position = 'top', results_width = 0.6 },
        vertical = { mirror = false },
      },
      sorting_strategy = 'ascending',
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  require('telescope').load_extension('fzy_native')
  require('telescope').load_extension('projects')
end

function config.project() 
  require("project_nvim").setup {}
end

function config.nvim_autopairs()
  local Rule = require('nvim-autopairs.rule')
  local npairs = require('nvim-autopairs')

  npairs.setup({
    check_ts = true,
    ts_config = {
      lua = {'string'},-- it will not add a pair on that treesitter node
      javascript = {'template_string'},
      java = false,-- don't check treesitter on java
    }
  })

  npairs.add_rules {
    Rule(' ', ' '):with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({'()', '[]', '{}'}, pair)
    end), Rule('( ', ' )'):with_pair(function() return false end):with_move(
    function(opts) return opts.prev_char:match('.%)') ~= nil end):use_key(
    ')'),
    Rule('{ ', ' }'):with_pair(function() return false end):with_move(
    function(opts) return opts.prev_char:match('.%}') ~= nil end):use_key(
    '}'), Rule('[ ', ' ]'):with_pair(function() return false end):with_move(
    function(opts) return opts.prev_char:match('.%]') ~= nil end):use_key(
    ']')
  }
  npairs.add_rule(Rule("'''", "'''", "python"))
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  require('cmp').event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end

function config.gitsigns()
  require('gitsigns').setup()
end

function config.comment()
  require('Comment').setup()
end

return config