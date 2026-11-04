return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  init = function()
    -- The plugin's built-in terminal mappings use Vim's `<C-w>:` termwinkey,
    -- which Neovim doesn't support, so they type "TmuxNavigateLeft" into the
    -- terminal instead of navigating. Define our own mappings below instead.
    vim.g.tmux_navigator_no_mappings = 1
  end,
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "t" } },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "t" } },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "t" } },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t" } },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n", "t" } },
  },
}
