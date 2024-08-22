-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local fn, uv, api = vim.fn, vim.loop, vim.api
local vim_path = vim.fn.stdpath('config')
local data_dir = string.format('%s/site/', vim.fn.stdpath('data'))
local modules_dir = vim_path .. '/lua/modules'
local packer_compiled = data_dir .. 'lua/packer_compiled.lua'
local packer = nil

local Packer = {}

function Packer:load_plugins()
  self.repos = {}

  local get_plugins_list = function()
    local list = {}
    local tmp = vim.split(fn.globpath(modules_dir, '*/plugins.lua'), '\n')
    for _, f in ipairs(tmp) do
      list[#list + 1] = string.match(f, 'lua/(.+).lua$')
    end
    return list
  end

  local plugins_file = get_plugins_list()
  for _, m in ipairs(plugins_file) do
    require(m)
  end
end

function Packer:ensure_plugins()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  packer = require('lazy')
  self:load_plugins()
  table.insert(self.repos, { 'folke/lazy.nvim', version = '*' })
  packer.setup(self.repos)
end

local function nocode()
  return vim.g.vscode ~= 1
end

local function code()
  return vim.g.vscode == 1
end

function Packer.register_local_plugin(repo, mode)
  repo.dir = modules_dir .. '/local/' .. repo[1]
  repo[1] = nil
  Packer.register_plugin(repo, mode)
end

function Packer.register_plugin(repo, mode)
  mode = mode or 'nvim'

  if mode == 'nvim' then
    repo.cond = nocode
  end

  if mode == 'vscode' then
    repo.cond = code
  end

  table.insert(Packer.repos, repo)
end

return Packer
