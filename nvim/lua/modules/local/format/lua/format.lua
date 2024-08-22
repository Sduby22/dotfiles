local logger = require('core.log')
local M = {}

M.opts = nil

function M.enabled_global()
  return M.opts.autoformat
end

function M.enabled_tab()
  return vim.t.autoformat == true or vim.t.autoformat == nil and M.opts.autoformat
end

function M.toggle_global()
  M.opts.autoformat = not M.opts.autoformat
  if M.opts.autoformat then
    logger.info('Enabled format on save')
  else
    logger.info('Disabled format on save')
  end
end

function M.toggle_tab()
  if vim.t.autoformat == nil then
    vim.t.autoformat = M.opts.autoformat
  end
  vim.t.autoformat = not vim.t.autoformat
  if vim.t.autoformat then
    logger.info('Enabled format on save for current tab')
  else
    logger.info('Disabled format on save for current tab')
  end
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()

  local formatters = M.get_formatters(buf)
  local client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if #client_ids == 0 then
    return
  end

  if M.opts.format_notify then
    M.notify(formatters)
  end

  vim.lsp.buf.format(vim.tbl_deep_extend('force', {
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
  }, {}))
end

---@param formatters LazyVimFormatters
function M.notify(formatters)
  local lines = { '# Active: ' .. vim.bo.filetype }

  for _, client in ipairs(formatters.active) do
    local line = '- **' .. client.name .. '**'
    if client.name == 'null-ls' then
      line = line
        .. ' ('
        .. table.concat(
          vim.tbl_map(function(f)
            return '`' .. f.name .. '`'
          end, formatters.null_ls),
          ', '
        )
        .. ')'
    end
    table.insert(lines, line)
  end

  if #formatters.available > 0 then
    table.insert(lines, '')
    table.insert(lines, '# Disabled:')
    for _, client in ipairs(formatters.available) do
      table.insert(lines, '- **' .. client.name .. '**')
    end
  end

  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, {
    title = 'Formatting',
    on_open = function(win)
      vim.api.nvim_win_set_option(win, 'conceallevel', 3)
      vim.api.nvim_win_set_option(win, 'spell', false)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, 'markdown')
    end,
  })
end

-- Gets all lsp clients that support formatting.
-- When a null-ls formatter is available for the current filetype,
-- only null-ls formatters are returned.
function M.get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype
  -- check if we have any null-ls formatters for the current filetype
  local null_ls = package.loaded['null-ls'] and require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') or {}

  ---@class LazyVimFormatters
  local ret = {
    ---@type lsp.Client[]
    active = {},
    ---@type lsp.Client[]
    available = {},
    null_ls = null_ls,
  }

  ---@type lsp.Client[]
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      if (#null_ls > 0 and client.name == 'null-ls') or #null_ls == 0 then
        table.insert(ret.active, client)
      else
        table.insert(ret.available, client)
      end
    end
  end

  return ret
end

-- Gets all lsp clients that support formatting
-- and have not disabled it in their client config
---@param client lsp.Client
function M.supports_format(client)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client.supports_method('textDocument/formatting') or client.supports_method('textDocument/rangeFormatting')
end

logger.info('out')
function M.setup(opts)
  logger.info('in')
  M.opts = opts
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('LazyVimFormat', {}),
    callback = function()
      if not (M.enabled_global() and M.enabled_tab()) then
        return
      end

      -- if filetype in disabled list, return
      if vim.tbl_contains(M.opts.disabled_ft, vim.bo.filetype) then
        return
      end

      M.format()
    end,
  })
end

return M
