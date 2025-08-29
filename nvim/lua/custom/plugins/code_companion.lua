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
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter', build = 'TSUpdate' },
    },
    keys = {
      { '<leader>aa', ':Copilot auth<CR>', mode = 'n', desc = '[A]uth copilot', silent = true },
      { '<leader>at', ':CodeCompanionChat Toggle<CR>', mode = 'n', desc = '[T]oggle/Start a new chat', silent = true },
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
