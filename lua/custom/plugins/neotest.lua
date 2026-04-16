return {
  {
    "rcasia/neotest-java",
    commit = "09e4e3db567d9d9b7772a111014b660d49feda5e", -- pin before result_builder API change (49f0566)
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
      local Path = require("neotest-java.model.path")
      local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
      package.loaded["neotest-java.command.binaries"] = function(_deps)
        local java_home = vim.env.JAVA_HOME
        local exe_ext = is_windows and ".exe" or ""
        return {
          java = function(_cwd)
            return Path(java_home):append("bin/java" .. exe_ext)
          end,
          javap = function(_cwd)
            return Path(java_home):append("bin/javap" .. exe_ext)
          end,
        }
      end

      -- Monkey-patch JunitResult:status() to guard against nil _attr when the XML
      -- parser breaks on '>' characters in JUnit Vintage failure message attributes.
      local JunitResult = require("neotest-java.model.junit_result")
      local FAILED = require("neotest.types").ResultStatus.failed
      local original_status = JunitResult.status
      JunitResult.status = function(self)
        local ok, status, failures = pcall(original_status, self)
        if not ok then
          local failed = self.testcase.failure or self.testcase.error
          if failed then
            -- Extract text nodes from the broken XML element (stack trace lives here)
            local parts = {}
            if type(failed) == "string" then
              parts[1] = failed
            elseif type(failed) == "table" then
              for _, v in ipairs(failed) do
                if type(v) == "string" then parts[#parts + 1] = v end
              end
            end
            local text = table.concat(parts, "\n")
            return FAILED, {{ failure_message = text ~= "" and text or "<test failed>", failure_output = text }}
          end
          return require("neotest.types").ResultStatus.passed
        end
        return status, failures
      end

      -- Monkey-patch result_builder to fix JUnit 4/Vintage result key mismatch.
      -- JUnit Vintage XML uses name="methodName(ClassName)" but neotest position ids
      -- use "classname#methodName()" — remap via clean_id (strip everything from "(" on).
      local result_builder = require("neotest-java.core.result_builder")
      local original_build_results = result_builder.build_results
      local clean_id = function(str) return str:gsub("%(.*", "") end
      result_builder.build_results = function(spec, result, tree, ...)
        local results = original_build_results(spec, result, tree, ...)
        local clean_to_pos = {}
        for _, pos in tree:iter() do
          clean_to_pos[clean_id(pos.id)] = pos.id
        end
        local remapped = {}
        for key, val in pairs(results) do
          remapped[clean_to_pos[clean_id(key)] or key] = val
        end
        return remapped
      end

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

      vim.keymap.set('n', '<leader>to', function()
        neotest.output.open()
      end, { desc = '[T]est [o]pen output window' })
    end
  },
}
