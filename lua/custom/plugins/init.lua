-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'tpope/vim-fugitive',
  {
    'voldikss/vim-floaterm',
    config = function()
      vim.keymap.set('n', '<leader>lg', '<CMD>FloatermNew lazygit<CR>', { desc = 'Open [l]azy[g]it in floaterm' })
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.7
    end,
  },
}
