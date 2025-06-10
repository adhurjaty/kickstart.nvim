return {
  'voldikss/vim-floaterm',
  config = function()
    vim.keymap.set('n', '<leader>lg', '<CMD>FloatermNew lazygit<CR>', { desc = 'Open [l]azy[g]it in floaterm' })
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.7
  end,
}
