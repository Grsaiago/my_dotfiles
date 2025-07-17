return {
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
    dependencies = {
      'j-hui/fidget.nvim', -- Display status
      {
        'Davidyz/VectorCode', -- Index and search code in your repositories
        version = '*',
        build = 'uv tool install vectorcode',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        build = ':Copilot auth',
        config = function()
          require('copilot').setup()
        end,
      },
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
          ---@type VectorCode.CodeCompanion.ExtensionOpts
          tool_group = {
            -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
            enabled = true,
            -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
            -- if you use @vectorcode_vectorise, it'll be very handy to include
            -- `file_search` here.
            extras = {
              'file_search',
            },
            collapse = true, -- whether the individual tools should be shown in the chat
          },
          tool_opts = {
            ---@type VectorCode.CodeCompanion.ToolOpts
            ['*'] = {},
            ---@type VectorCode.CodeCompanion.LsToolOpts
            ls = {},
            ---@type VectorCode.CodeCompanion.VectoriseToolOpts
            vectorise = {},
            ---@type VectorCode.CodeCompanion.QueryToolOpts
            query = {
              max_num = { chunk = -1, document = -1 },
              default_num = { chunk = 50, document = 10 },
              include_stderr = false,
              use_lsp = true,
              no_duplicate = true,
              chunk_mode = false,
              ---@type VectorCode.CodeCompanion.SummariseOpts
              summarise = {
                ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
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
