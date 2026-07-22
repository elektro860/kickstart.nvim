local jdtls = require 'jdtls'

vim.cmd.colorscheme 'nightfox'
local config = {
  -- cmd = { 'java', '-Xmx4G', '-jar', 'jdtls' }, -- Ensure jdtls is in your PATH
  cmd = { 'jdtls', '-Xmx8G' }, -- Ensure jdtls is in your PATH
  root_dir = vim.fs.root(0, { 'gradlew', '.git', 'pom.xml' }),

  settings = {
    java = {
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
    },
  },

  init_options = {
    bundles = {
      vim.fn.glob '/home/elektro/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.2.jar',
    },
  },
}

-- Setting up DAP for Java
jdtls.setup_dap { hotcodereplace = 'auto' } -- For hot code replacement

jdtls.start_or_attach(config)

-- Add the on_attach function to enable debugging without conflicts
config.on_attach = function(client, bufnr)
  require('dap').setup() -- Attach DAP functionality
end
