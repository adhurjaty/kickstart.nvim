local root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])
local project_name = root_dir and vim.fn.fnamemodify(root_dir, ':t') or 'unknown'
local data_dir = vim.fn.expand('~/.local/share/nvim/jdtls-workspace/') .. project_name

local config = {
    cmd = { vim.fn.expand '~/.local/share/nvim/mason/bin/jdtls', '-data', data_dir },
    root_dir = root_dir,
}

local bundles = {
  vim.fn.glob("/Users/anil.dhurjaty/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
};

vim.list_extend(bundles, vim.tbl_filter(function(path)
  return not path:match("jacocoagent%.jar$")
end, vim.split(vim.fn.glob("/Users/anil.dhurjaty/src/vscode-java-test/server/*.jar", true), "\n")))
config['init_options'] = {
  bundles = bundles;
}

require('jdtls').start_or_attach(config)
