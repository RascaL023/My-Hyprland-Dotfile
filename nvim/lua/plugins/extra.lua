return {
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },
  {
    "ziontee113/color-picker.nvim",
    config = function()
      require("color-picker")
      -- shortcut untuk memunculkan picker
      vim.api.nvim_set_keymap('n', '<leader>cp', ':PickColor<CR>', { noremap = true, silent = true })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*"; -- highlight semua file
      }, {
        RGB = true,
        RRGGBB = true,
        names = true,
        tailwind = true,
        css = true,
      })
    end
  }
}

