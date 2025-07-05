return {
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap", -- for the debugger
      "rcarriga/nvim-dap-ui", -- recommended
      "theHamsta/nvim-dap-virtual-text", -- recommended
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      local neotest = require('neotest')
      local jest_config_file = 'jest.config.js'

      neotest.setup({
        adapters = {
          require('neotest-jest')({
            jestCommand = "npm test --",
            jestConfigFile = jest_config_file,
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
          require('neotest-java'),
        }
      })

      vim.keymap.set('n', '<leader>tn', function()
        neotest.run.run()
      end, { desc = '[T]est run [n]earest test case' })

      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run(vim.fn.expand('%'))
      end, { desc = '[T]est run [f]ile' })

      vim.keymap.set('n', '<leader>tN', function()
        neotest.run.run({ strategy = 'dap' })
      end, { desc = '[T]est debug [N]earest test case' })

      vim.keymap.set('n', '<leader>tF', function()
        neotest.run.run({ vim.fn.expand('%'), strategy = 'dap' })
      end, { desc = '[T]est debug [F]ile' })

      vim.keymap.set('n', '<leader>ts', function()
        neotest.summary.toggle()
      end, { desc = '[T]est toggle [s]ummary panel' })
    end
  },
}
