return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      -- ✨🎛️ Keymap tetap seperti punyamu
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),

      -- ✨ Source tetap clean
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
      }),

      -- ✨✨ Window styling (rounded + padding + border)
      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          scrollbar = false,
          winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
          side_padding = 1,
          col_offset = -3,
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:CmpDoc,FloatBorder:CmpBorder",
        }),
      },
    })
  end,
}

