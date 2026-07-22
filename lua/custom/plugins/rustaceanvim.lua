vim.pack.add { { src = gh 'mrcjkb/rustaceanvim' } }

vim.g.rustaceanvim = {
  tools = {
    inlay_hints = {
      auto = true,
      show_parameter_hints = true,
      parameter_hints_prefix = '<- ',
      other_hints_prefix = '=> ',
      highlight = 'Comment',
    },
  },
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
        },
        workspace = {
          symbol = {
            search = {
              scope = 'workspace_and_dependencies',
              kind = 'all_symbols',
            },
          },
        },
      },
    },
  },
}
