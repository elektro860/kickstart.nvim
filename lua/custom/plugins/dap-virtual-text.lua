vim.pack.add { { src = gh 'theHamsta/nvim-dap-virtual-text' } }

local v_text = require 'nvim-dap-virtual-text'
v_text.setup {
  highlight_changed_variables = true,
  highlight_new_as_changed = true,
}
