return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "OXY2DEV/markview.nvim" },
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "java",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
          "sql",
          "bash",
          "yaml",
          "go", "gomod", "gosum", "gowork",
          "svelte",
          "markdown",
          "markdown_inline",
        },

        highlight = { enable = true },
        indent = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
          },
        },
      })
    end,
  }
