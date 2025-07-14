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
      {
        'zbirenbaum/copilot.lua',
        opts = {},
      },
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
        cmd = {
          adapter = 'copilot',
        },
      },
    },
  },
}
