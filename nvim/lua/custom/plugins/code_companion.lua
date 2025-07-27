return {
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
    dependencies = {
      'j-hui/fidget.nvim',
      {
        'Davidyz/VectorCode',
        version = '*',
        build = 'uv tool upgrade vectorcode',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        -- https://github.com/zbirenbaum/copilot.lua?tab=readme-ov-file#setup-and-configuration
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        dependencies = {
          {
            'zbirenbaum/copilot-cmp',
            opts = {},
          },
        },
        opts = {
          panel = { enabled = false }, -- for some reason, we have to use this option so the plugin works when opening a new codecompanion chat
          filetypes = {
            codecompanion = true,
          },
        },
      },
    },
    keys = {
      { '<leader>aa', ':Copilot auth<CR>', mode = 'n', desc = '[A]uth copilot', silent = true },
      { '<leader>act', ':CodeCompanionChat Toggle<CR>', mode = 'n', desc = '[C]hat [T]oggle', silent = true },
      { '<leader>ac', ':CodeCompanionChat<CR>', mode = 'n', desc = '[C]reate a new chat', silent = true },
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
      extensions = {
        vectorcode = {
          tool_group = {
            enabled = true,
            extras = {
              'file_search',
            },
            collapse = true,
          },
          tool_opts = {
            ['*'] = {},
            ls = {},
            vectorise = {},
            query = {
              max_num = { chunk = -1, document = -1 },
              default_num = { chunk = 50, document = 10 },
              include_stderr = false,
              use_lsp = true,
              no_duplicate = true,
              chunk_mode = false,
              summarise = {
                enabled = false,
                adapter = nil,
                query_augmented = true,
              },
            },
            files_ls = {},
            files_rm = {},
            async_backend = 'lsp',
          },
        },
      },
    },
  },
}
