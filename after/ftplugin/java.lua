-- local jdtls = require 'jdtls'
--
-- -- vim.cmd.colorscheme 'nightfox'
-- local config = {
--   -- cmd = { 'java', '-Xmx4G', '-jar', 'jdtls' }, -- Ensure jdtls is in your PATH
--   cmd = { 'jdtls', '-Xmx8G' }, -- Ensure jdtls is in your PATH
--   root_dir = vim.fs.root(0, { 'gradlew', '.git', 'pom.xml' }),
--
--   settings = {
--     java = {
--       referencesCodeLens = { enabled = true },
--       implementationsCodeLens = { enabled = true },
--       references = { includeDecompiledSources = true },
--     },
--   },
--
--   init_options = {
--     bundles = {
--       vim.fn.glob '/home/elektro/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.2.jar',
--     },
--   },
-- }
--
-- -- Setting up DAP for Java
-- jdtls.setup_dap { hotcodereplace = 'auto' } -- For hot code replacement
--
-- jdtls.start_or_attach(config)
--
-- -- Add the on_attach function to enable debugging without conflicts
-- config.on_attach = function(client, bufnr)
--   require('dap').setup() -- Attach DAP functionality
-- end
local jdtls = require 'jdtls'
local mason_registry = require 'mason-registry'

-- 1. Get path to java-debug-adapter installed by Mason
local bundles = {}
if mason_registry.is_installed 'java-debug-adapter' then
  local jar_path = mason_registry.get_package('java-debug-adapter'):get_install_path() .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'

  local found_jars = vim.fn.glob(jar_path, true, true)
  if #found_jars > 0 then vim.list_extend(bundles, found_jars) end
end

-- 2. Configure JDTLS
local config = {
  cmd = { 'jdtls' }, -- Or your custom jdtls launch script
  root_dir = jdtls.setup.find_root { '.git', 'gradlew', 'build.gradle' },

  init_options = {
    bundles = bundles,
  },

  on_attach = function(client, bufnr)
    -- 3. Register vscode.java.startDebugSession with nvim-dap
    jdtls.setup_dap { hotcodereplace = 'auto' }
  end,
}

jdtls.start_or_attach(config)
