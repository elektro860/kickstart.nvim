vim.pack.add { { src = gh 'akinsho/toggleterm.nvim' } }

local t = require 'toggleterm'
t.setup {
  open_mapping = [[<leader>st]],
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  terminal_mappings = false,
  insert_mappings = false,
  on_open = function() vim.cmd 'startinsert' end,
  persist_size = true,
  direction = 'float',
  float_opts = {
    border = 'rounded',
    winblend = 15,
    width = function() return math.floor(vim.o.columns * 0.9) end,
    height = function() return math.floor(vim.o.lines * 0.9) end,
    highlights = {
      border = 'FloatBorder',
      background = 'Normal',
    },
  },
}
