return {
  {
    "folke/snacks.nvim",
    priority = 900,
    lazy = false,
    opts = function()
      return require("core.theme").snacks_opts()
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return require("core.theme").tokyonight_opts()
    end,
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local theme = require("core.theme")

      require("lualine").setup({
        options = {
          theme = "tokyonight",
          section_separators = {
            left = theme.icons.lualine_left,
            right = theme.icons.lualine_right,
          },
          component_separators = "|",
        },
      })
    end,
  },
  {
    "gen740/SmoothCursor.nvim",
    event = "BufReadPost",
    config = function()
      local theme = require("core.theme")

      require("smoothcursor").setup({
        autostart = true,
        speed = 40,
        intervals = 60,
        fancy = {
          enable = true,
          head = { cursor = theme.icons.cursor_head, texthl = "SmoothCursor", linehl = nil },
          body = {
            { cursor = theme.icons.cursor_body1, texthl = "SmoothCursorBody1" },
            { cursor = theme.icons.cursor_body2, texthl = "SmoothCursorBody2" },
            { cursor = theme.icons.cursor_body3, texthl = "SmoothCursorBody3" },
          },
          tail = { cursor = theme.icons.cursor_tail, texthl = "SmoothCursorTail" },
        },
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "BufReadPost",
    opts = {
      symbol = "▎",
      options = { try_as_border = true },
      draw = {
        delay = 50,
        priority = 3,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "alpha", "dashboard", "NvimTree", "telescope", "help" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
