return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      git = {
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
    })
  end
}

