return {
  {
    -- https://github.com/zbirenbaum/copilot.lua?tab=readme-ov-file#setup-and-configuration
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter', -- So it loads when I first type something
    dependencies = {
      {
        'zbirenbaum/copilot-cmp',
        opts = {},
      },
    },
    opts = {
      suggestion = {
        auto_trigger = true,
        enabled = false, -- as per copilot-cmp docs
      },
      panel = { enabled = false }, -- as per copilot-cmp docs
      filetypes = {
        java = false,
        env = false,
        ['*'] = true,
      },
    },
  },
}
