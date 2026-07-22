local dap = require 'dap'

dap.set_log_level 'TRACE'
dap.adapters['probe-rs-debug'] = {
  type = 'server',
  port = '${port}', -- Tells Neovim to pick a free random port
  executable = {
    command = 'probe-rs', -- Must be in your system PATH
    args = { 'dap-server', '--port', '${port}' }, -- Passes that port to probe-rs
  },
}

dap.listeners.before['event_probe-rs-rtt-channel-config']['probe-rs-handshake'] = function(session, body)
  vim.schedule(function() print('🚀 RTT Channel Connected: ' .. (body.channelName or 'defmt')) end)
  return true
end

dap.listeners.before['event_probe-rs-rtt-data']['probe-rs-stream'] = function(session, body)
  if body and body.data then
    vim.schedule(function()
      vim.api.nvim_echo({ { '[RP2040 Log]: ' .. body.data, 'String' } }, true, {})

      -- Also append to REPL just in case
      require('dap.repl').append(body.data)
    end)
  end
  return true
end

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', '<leader>a', function()
  vim.cmd.RustLsp 'codeAction' -- supports rust-analyzer's grouping
  -- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr, desc = 'Rust Code [a]ctions' })
vim.keymap.set(
  'n',
  'K', -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function() vim.cmd.RustLsp { 'hover', 'actions' } end,
  { silent = true, buffer = bufnr }
)
