vim.pack.add { { src = gh 'mfussenegger/nvim-jdtls' } }

vim.lsp.enable 'jdtls'
vim.keymap.set('n', '<leader>0', function() require('jdtls').organize_imports() end, { desc = 'Organize imports' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    local jdtls = require 'jdtls'

    local root_dir = jdtls.setup.find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
    if not root_dir then return end

    local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
    local workspace_dir = vim.fn.stdpath 'data' .. '/site/java-workspace/' .. project_name

    -- Path to your Mason jdtls installation directory
    local jdtls_dir = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'

    -- Find the launcher jar automatically
    local launcher_jar = vim.fn.glob(jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_*.jar')

    -- Detect operating system config directory
    local config_os = 'config_linux'
    if vim.fn.has 'mac' == 1 then
      config_os = 'config_mac'
    elseif vim.fn.has 'win32' == 1 then
      config_os = 'config_win'
    end

    local config = {
      cmd = {
        'java', -- Must be Java 17+
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',

        -- Path to equinox launcher jar
        '-jar',
        launcher_jar,

        -- OS specific configuration directory
        '-configuration',
        jdtls_dir .. '/' .. config_os,

        -- Workspace path
        '-data',
        workspace_dir,
      },
      settings = {
        java = {
          autobuild = { enabled = true },
        },
      },
      root_dir = root_dir,
      on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set('n', '<leader>0', jdtls.organize_imports, vim.tbl_extend('force', opts, { desc = 'Organize imports' }))
      end,
    }

    jdtls.start_or_attach(config)
  end,
})
