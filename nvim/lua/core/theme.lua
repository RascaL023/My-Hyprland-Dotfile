local M = {}

M.colors = {
  bg = "#1a0f1f",
  bg_dark = "#120b16",
  fg = "#dcd7ff",
  purple = "#bb9af7",
  magenta = "#c678dd",
  blue = "#9d7cd8",
  border = "#ab7ae6",
  button = "#d6b2ff",
  footer = "#bd93f9",
  smooth_body3 = "#6d4ea8",
  smooth_tail = "#5a3c8c",
}

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
  local colors = M.colors

  c.bg = colors.bg
  c.bg_dark = colors.bg_dark
  c.purple = colors.purple
  c.magenta = colors.magenta
  c.blue = colors.blue
  c.fg = colors.fg
  c.border = colors.border
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
  local colors = M.colors

  vim.api.nvim_set_hl(0, "AlphaHeader", { fg = colors.magenta })
  vim.api.nvim_set_hl(0, "AlphaBorder", { fg = colors.border })
  vim.api.nvim_set_hl(0, "AlphaButtons", { fg = colors.button })
  vim.api.nvim_set_hl(0, "AlphaFooter", { fg = colors.footer })
end

function M.apply_telescope_highlights()
  local colors = M.colors

  local function set_hl(name, fg)
    local current = vim.api.nvim_get_hl(0, { name = name })
    vim.api.nvim_set_hl(0, name, { fg = fg, bg = current.bg })
  end

  set_hl("TelescopeBorder", colors.border)
  set_hl("TelescopePromptBorder", colors.magenta)
  set_hl("TelescopePromptTitle", colors.magenta)
  set_hl("TelescopeResultsTitle", colors.purple)
  set_hl("TelescopePreviewTitle", colors.magenta)
    -- set_hl("TelescopeResultsBorder", colors.border)
    -- set_hl("TelescopePreviewBorder", colors.border)
end

function M.apply_smoothcursor_highlights()
  local colors = M.colors

  vim.api.nvim_set_hl(0, "SmoothCursor", { fg = colors.magenta })
  vim.api.nvim_set_hl(0, "SmoothCursorBody1", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "SmoothCursorBody2", { fg = colors.blue })
  vim.api.nvim_set_hl(0, "SmoothCursorBody3", { fg = colors.smooth_body3 })
  vim.api.nvim_set_hl(0, "SmoothCursorTail", { fg = colors.smooth_tail })
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
