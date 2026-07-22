---@type snacks.Config
local opts = {
  bigfile = { enabled = true },
  explorer = {
    enabled = false,
  },
  indent = { enabled = false },
  input = { enabled = true },
  picker = {
    enabled = true,
    hidden = true,
    ignored = true,
    sources = {
      files = {
        hidden = true,
        ignored = true,
      },
      grep = {
        hidden = true,
        ignored = true,
      },
      explorer = {
        hidden = true,
        ignored = true,
      },
    },
    win = {
      input = {
        keys = {
          ['<M-/>'] = { 'choose_history', mode = { 'i', 'n' } },
        },
      },
    },
  },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}

vim.pack.add { { src = gh 'folke/snacks.nvim' } }

local Snacks = require 'snacks'
Snacks.setup(opts)

vim.keymap.set('n', '<leader>sh', Snacks.picker.help, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', Snacks.picker.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', Snacks.picker.files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', Snacks.picker.pickers, { desc = '[S]earch [S]elect Snacks pickers' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', Snacks.picker.grep_word, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', Snacks.picker.grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', Snacks.picker.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', Snacks.picker.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', Snacks.picker.recent, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sc', Snacks.picker.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', Snacks.picker.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set(
  'n',
  '<leader>e',
  function()
    Snacks.explorer {
      auto_close = true,
      layout = { preset = 'telescope', reverse = false },
    }
  end,
  { desc = 'Open [e]xplorer' }
)

-- LSP stuff
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf

    -- Find references for the word under your cursor.
    vim.keymap.set('n', 'grr', Snacks.picker.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

    -- Jump to the implementation of the word under your cursor.
    -- Useful when your language has ways of declaring types without an actual implementation.
    vim.keymap.set('n', 'gri', Snacks.picker.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

    -- Jump to the definition of the word under your cursor.
    -- This is where a variable was first declared, or where a function is defined, etc.
    -- To jump back, press <C-t>.
    vim.keymap.set('n', 'grd', Snacks.picker.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

    -- Fuzzy find all the symbols in your current document.
    -- Symbols are things like variables, functions, types, etc.
    vim.keymap.set('n', 'gO', Snacks.picker.lsp_symbols, { buffer = buf, desc = 'Open Document Symbols' })

    -- Fuzzy find all the symbols in your current workspace.
    -- Similar to document symbols, except searches over your entire project.
    vim.keymap.set('n', 'gW', Snacks.picker.lsp_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

    -- Jump to the type of the word under your cursor.
    -- Useful when you're not sure what type a variable is and you want to see
    -- the definition of its *type*, not where it was *defined*.
    vim.keymap.set('n', 'grt', Snacks.picker.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
  end,
})
