local dap = require 'dap'

-- as per [docs](https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python)
dap.configurations.python = {
  {
    name = 'Pick a file',
    type = 'python',
    request = 'launch',
    program = '${command:pickFile}',
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end,
  },
}
