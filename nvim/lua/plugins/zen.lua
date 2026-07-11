local colors = require("core.theme").colors

vim.api.nvim_set_hl(0, "ZenNormal", { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "ZenBorder", { fg = colors.border })

return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 100,
        height = 1,
        backdrop = 0.95,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorcolumn = false,
          foldcolumn = "0",
          winhighlight = "Normal:ZenNormal,FloatBorder:ZenBorder",
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
      },
      on_open = function()
        vim.cmd("PencilSoft")
        vim.b.miniindentscope_disable = true
      end,
      on_close = function()
        vim.cmd("PencilOff")
        vim.b.miniindentscope_disable = false
      end,
    },
  },
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.3,
        color = { "Normal", colors.fg },
        term_bg = colors.bg_dark,
      },
      context = 12,
      treesitter = true,
    },
  },
  {
    "preservim/vim-pencil",
    cmd = { "Pencil", "PencilSoft", "PencilOff" },
  },
}
