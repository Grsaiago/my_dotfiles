local dap = require 'dap'

dap.configurations.rust = {
  {
    name = 'Run debug',
    type = 'codelldb',
    request = 'launch',
    program = function()
      vim.fn.jobstart 'cargo build'
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
  },
}
