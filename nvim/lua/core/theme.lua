local M = {}

local ok, colors = pcall(dofile, "/home/rascal/Documents/PUB/Code/Go/Theme-Engine/output/tools/nvim/colors.lua")
if ok then
  M.colors = colors
else
  M.colors = {}
end

M.icons = {
  lualine_left = "",
  lualine_right = "",
  cursor_head = "󰢘",
  cursor_body1 = "",
  cursor_body2 = "",
  cursor_body3 = "•",
  cursor_tail = "-",
}

function M.setup_base_ui()
  vim.opt.fillchars = { eob = " " }
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = "rounded" })
end

function M.tokyonight_colors(c)
  local clr = M.colors

  -- Background layers
  c.bg           = clr.bg
  c.bg_dark      = clr.bg_dark
  c.bg_dark1     = clr.bg_dark1
  c.bg_highlight = clr.bg_highlight

  -- Foreground
  c.fg           = clr.fg
  c.fg_dark      = clr.fg_dark
  c.fg_gutter    = clr.fg_gutter
  c.comment      = clr.comment

  -- ANSI / semantic syntax colours
  c.cyan         = clr.cyan
  c.green        = clr.green
  c.yellow       = clr.yellow
  c.blue         = clr.blue
  c.magenta      = clr.magenta
  c.red          = clr.red

  -- Accent / extended syntax colours
  c.purple       = clr.purple
  c.magenta2     = clr.magenta2
  c.orange       = clr.orange
  c.green1       = clr.green1
  c.green2       = clr.green2
  c.red1         = clr.red1
  c.teal         = clr.teal

  -- Blue variants (Type, Operator, Special, link)
  c.blue0        = clr.blue0
  c.blue1        = clr.blue1
  c.blue5        = clr.blue5
  c.blue6        = clr.blue6
  c.blue7        = clr.blue7

  -- Muted / dark variants
  c.dark3        = clr.dark3
  c.dark5        = clr.dark5

  -- Terminal black for gutter / diagnostics
  c.terminal_black = clr.terminal_black

  -- Derived diagnostic colours (must be explicit because
  -- they were already computed from the default palette)
  c.error   = clr.red1
  c.warning = clr.orange or clr.yellow
  c.info    = clr.teal
  c.hint    = clr.teal
  c.todo    = clr.blue

  -- UI chrome
  c.border           = clr.border
  c.border_highlight = clr.blue1
  c.black            = clr.bg_dark1

  -- Visual / search
  c.bg_visual = clr.blue0
  c.bg_search = clr.blue0

  -- Diff
  c.diff = {
    add    = clr.green2,
    delete = clr.red1,
    change = clr.blue7,
    text   = clr.blue7,
  }

  -- Popup / statusline / sidebar / float backgrounds
  c.bg_popup      = clr.bg_dark
  c.bg_statusline = clr.bg_dark
  c.bg_sidebar    = clr.bg_dark
  c.bg_float      = clr.bg_dark

  -- Sidebar / float foreground
  c.fg_sidebar = clr.fg_dark
  c.fg_float   = clr.fg

  -- Rainbow for markdown headings
  c.rainbow = {
    clr.blue,
    clr.yellow,
    clr.green,
    clr.teal,
    clr.magenta,
    clr.purple,
    clr.orange,
    clr.red,
  }

  -- Terminal colours
  c.terminal = {
    black          = clr.black,
    black_bright   = clr.terminal_black,
    red            = clr.red,
    red_bright     = clr.red1,
    green          = clr.green,
    green_bright   = clr.green1,
    yellow         = clr.yellow,
    yellow_bright  = clr.orange,
    blue           = clr.blue,
    blue_bright    = clr.blue1,
    magenta        = clr.magenta,
    magenta_bright = clr.magenta2,
    cyan           = clr.cyan,
    cyan_bright    = clr.teal,
    white          = clr.fg_dark,
    white_bright   = clr.fg,
  }
end

function M.tokyonight_highlights(hl, c)
  hl.CmpBorder = { fg = c.border }
  hl.CmpDoc = { bg = "none", fg = c.fg }
  hl.CmpPmenu = { bg = "none", fg = c.fg }

  hl.NvimTreeNormal = { bg = "none" }
  hl.NvimTreeNormalNC = { bg = "none" }
  hl.NvimTreeEndOfBuffer = { bg = "none" }

  hl.Normal = { bg = "none" }
  hl.NormalNC = { bg = "none" }
  hl.NormalFloat = { bg = "none" }
  hl.SignColumn = { bg = "none" }
  hl.LineNr = { bg = "none" }
  hl.CursorLineNr = { bg = "none" }
  hl.EndOfBuffer = { bg = "none" }

  -- General Float
  hl.FloatBorder = { fg = c.border }

  hl.SnacksInputBorder = { fg = c.border }
  hl.SnacksInputTitle = { fg = c.magenta }
  hl.SnacksInputIcon = { fg = c.purple }
  hl.SnacksInputNormal = { bg = "none", fg = c.fg }

  local levels = { "Error", "Warn", "Info", "Debug", "Trace" }
  for _, lvl in ipairs(levels) do
    hl["SnacksNotifierBorder" .. lvl] = { fg = c.border }
    hl["SnacksNotifierTitle" .. lvl] = { fg = c.purple }
    hl["SnacksNotifierIcon" .. lvl] = { fg = c.blue }
    hl["SnacksNotifierFooter" .. lvl] = { fg = c.border }
    hl["SnacksNotifier" .. lvl] = { fg = c.fg }
  end
end

function M.apply_alpha_highlights()
  local clr = M.colors

  vim.api.nvim_set_hl(0, "AlphaHeader", { fg = clr.magenta })
  vim.api.nvim_set_hl(0, "AlphaBorder", { fg = clr.border })
  vim.api.nvim_set_hl(0, "AlphaButtons", { fg = clr.button })
  vim.api.nvim_set_hl(0, "AlphaFooter", { fg = clr.footer })
end

function M.apply_telescope_highlights()
  local clr = M.colors

  local function set_hl(name, fg)
    local current = vim.api.nvim_get_hl(0, { name = name })
    vim.api.nvim_set_hl(0, name, { fg = fg, bg = current.bg })
  end

  set_hl("TelescopeBorder", clr.border)
  set_hl("TelescopePromptBorder", clr.magenta)
  set_hl("TelescopePromptTitle", clr.magenta)
  set_hl("TelescopeResultsTitle", clr.purple)
  set_hl("TelescopePreviewTitle", clr.magenta)
end

function M.apply_smoothcursor_highlights()
  local clr = M.colors

  vim.api.nvim_set_hl(0, "SmoothCursor", { fg = clr.magenta })
  vim.api.nvim_set_hl(0, "SmoothCursorBody1", { fg = clr.purple })
  vim.api.nvim_set_hl(0, "SmoothCursorBody2", { fg = clr.blue })
  vim.api.nvim_set_hl(0, "SmoothCursorBody3", { fg = clr.smooth_body3 })
  vim.api.nvim_set_hl(0, "SmoothCursorTail", { fg = clr.smooth_tail })
end

function M.snacks_opts()
  return {
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "fancy",
      width = { min = 36, max = 0.4 },
      margin = { top = 1, right = 1, bottom = 0 },
      padding = true,
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
      },
    },
    input = {
      enabled = true,
    },
    picker = {
      enabled = true,
      ui_select = true,
    },
    styles = {
      notification = {
        border = "rounded",
        backdrop = 60,
        wo = { winblend = 5 },
      },
      input = {
        border = "rounded",
        width = 52,
        row = 2,
      },
    },
  }
end

return M
