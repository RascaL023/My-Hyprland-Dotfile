local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- kelompok plugin UI
  { import = "plugins.ui" },

  -- kelompok LSP
  { import = "plugins.lsp" },

  -- autocomplete
  { import = "plugins.cmp" },

  -- file explorer
  { import = "plugins.nvimtree" },

  -- treesitter
  { import = "plugins.treesitter" },

  -- telescope
  { import = "plugins.telescope" },

  -- pacman
  { import = "plugins.mason" },

  -- multi-cursor-select
  { import = "plugins.multi-cursor" },

  -- dashboard view 
  { import = "plugins.alpha"},

  -- flash
  { import = "plugins.flash"},

  -- gitsigns
  { import = "plugins.gitsigns"},

  -- comments
  { import = "plugins.comment"},

  -- autopairs
  { import = "plugins.autopairs"},

  -- extra
  { import = "plugins.extra"},

  -- ai agent
  { import = "plugins.gen"},

  -- kulala
  { import = "plugins.kulala"},

  -- undotree
  { import = "plugins.undotree"}
})
