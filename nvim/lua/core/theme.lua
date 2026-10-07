local M = {}

-- ============================================================================
-- [1] PALET — Kanagawa Dragon (dark)
-- Sumber: matugen/templates/kanagawa-dragon/blueprint/palette.json (blok "dark").
-- Disalin apa adanya. Blok ini (beserta [2]) kelak digantikan oleh output
-- template matugen, jadi jangan menambah hex di luar blok ini.
-- ============================================================================

local dark = {
  background = "#181616",
  foreground = "#c5c9c5",
  cursor = "#C8C093",

  colors = {
    "#0d0c0c",
    "#c4746e",
    "#8a9a7b",
    "#c4b28a",
    "#8ba4b0",
    "#a292a3",
    "#8ea4a2",
    "#C8C093",

    "#a6a69c",
    "#E46876",
    "#87a987",
    "#E6C384",
    "#7FB4CA",
    "#938AA9",
    "#7AA89F",
    "#c5c9c5",
  },

  extra = {
    accent = {
      primary = "#8ba4b0",
      secondary = "#a292a3",
      on_accent = "#0d0c0c",
    },

    text = {
      primary = "#c5c9c5",
      secondary = "#C8C093",
      muted = "#a6a69c",
      link = "#8ba4b0",
      visited = "#7b6f8c",
    },

    layer = {
      base = "#181616",
      mantle = "#12120f",
      crust = "#0d0c0c",
      surface = "#1D1C19",
      surface_raised = "#282727",
      surface_overlay = "#393836",
    },

    border = {
      default = "#282727",
      active = "#8ba4b0",
      medium = "#4a4a49",
    },

    status = {
      success = "#8a9a7b",
      warning = "#c4b28a",
      error = "#c4746e",
      critical = "#E46876",
      info = "#8ba4b0",
    },

    fg = {
      dim = "#63635e",
      dim_muted = "#7a7a74",
      disabled = "#5a5f63",
    },

    bg = {
      conflict = "#635127",
      disk_usage = "#50504a",
    },

    syntax = {
      comment = "#625E5A",

      keyword = "#938AA9",
      statement = "#938AA9",

      ["function"] = "#7FB4CA",
      method = "#7FB4CA",

      string = "#87A987",

      constant = "#E6C384",
      number = "#E6C384",
      boolean = "#E6C384",

      type = "#7AA89F",
      class = "#7AA89F",

      variable = "#C5C9C5",
      parameter = "#C8C093",
      property = "#C8C093",
      identifier = "#E6C384",

      operator = "#C0A36E",
      regex = "#C0A36E",

      builtin = "#7FB4CA",
      builtin_variable = "#E46876",

      punctuation = "#9CABCA",

      special = "#E46876",
      exception = "#E46876",
      ["return"] = "#E46876",
      import = "#FFA066",

      decorator = "#938AA9",
      tag = "#E46876",
      attribute = "#C8C093",
    },

    ui = {
      bg_statusline = "#282727",
      gutter = "#393836",
    },
  },
}

--- Indeks 0-based seperti urutan warna ANSI (ansi(0) = hitam, ansi(15) = putih terang).
local function ansi(i)
  return dark.colors[i + 1]
end

-- ============================================================================
-- [2] MAPPING KE KUNCI TOKYONIGHT
-- ============================================================================

local BLUE0_ALPHA = 0.35
local BLUE7_ALPHA = 0.22

--- Campur `fg` ke `bg` dengan bobot `alpha` untuk `fg` (0 = bg, 1 = fg).
--- Implementasi Lua murni supaya tidak bergantung pada `tokyonight.util`.
--- @return string hex `#rrggbb`
local function blend(fg, bg, alpha)
  local function channels(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
  end

  local fr, fgc, fb = channels(fg)
  local br, bgc, bb = channels(bg)

  local function mix(f, b)
    return math.floor(math.min(math.max(0, alpha * f + (1 - alpha) * b), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", mix(fr, br), mix(fgc, bgc), mix(fb, bb))
end

local function build_colors(d)
  local layer = d.extra.layer
  local text = d.extra.text
  local border = d.extra.border
  local status = d.extra.status
  local fg = d.extra.fg
  local syntax = d.extra.syntax
  local accent = d.extra.accent
  local ui = d.extra.ui

  local base = layer.base

  local blue = syntax["function"]
  local blue0 = blend(blue, base, BLUE0_ALPHA)
  local blue7 = blend(blue, base, BLUE7_ALPHA)

  local green = syntax.string
  local teal = ansi(14)
  local yellow = syntax.constant
  local orange = syntax.import
  local magenta = syntax.statement
  local purple = syntax.keyword
  local red = status.critical
  local dark5 = fg.dim_muted

  return {
    -- Palet dasar (peran ditentukan oleh pemakaian di source tokyonight).
    bg = layer.base,
    bg_dark = layer.mantle,
    bg_dark1 = layer.crust,
    bg_highlight = layer.surface_raised,
    fg = d.foreground,
    fg_dark = text.muted,
    fg_gutter = ui.gutter,
    comment = syntax.comment,
    dark3 = fg.dim,
    dark5 = dark5,
    terminal_black = border.medium,
    red = red,
    red1 = status.error,
    green = green,
    green1 = syntax.property,
    green2 = status.success,
    yellow = yellow,
    orange = orange,
    blue = blue,
    blue1 = syntax.type,
    blue2 = status.info,
    blue5 = syntax.operator,
    blue6 = syntax.regex,
    cyan = ansi(6),
    teal = teal,
    purple = purple,
    magenta = magenta,
    magenta2 = syntax.special,
    blue0 = blue0,
    blue7 = blue7,
    git = {
      add = status.success,
      change = accent.primary,
      delete = status.error,
      ignore = fg.dim,
    },

    -- Kunci turunan. Wajib di-set eksplisit karena tokyonight menghitungnya
    -- SEBELUM `on_colors` dipanggil.
    black = layer.crust,
    border = border.medium,
    border_highlight = border.active,
    bg_popup = layer.mantle,
    bg_float = layer.mantle,
    bg_sidebar = layer.mantle,
    bg_statusline = ui.bg_statusline,
    bg_visual = blue7,
    bg_search = blue0,
    fg_sidebar = text.muted,
    fg_float = d.foreground,
    error = status.error,
    warning = status.warning,
    info = status.info,
    hint = teal,
    todo = blue,
    diff = {
      add = blend(status.success, base, 0.25),
      delete = blend(status.error, base, 0.25),
      change = blend(blue, base, 0.15),
      text = blue7,
    },
    rainbow = { blue, yellow, green, teal, magenta, purple, orange, red },
    terminal = {
      black = ansi(0),
      black_bright = ansi(8),
      red = ansi(1),
      red_bright = ansi(9),
      green = ansi(2),
      green_bright = ansi(10),
      yellow = ansi(3),
      yellow_bright = ansi(11),
      blue = ansi(4),
      blue_bright = ansi(12),
      magenta = ansi(5),
      magenta_bright = ansi(13),
      cyan = ansi(6),
      cyan_bright = ansi(14),
      white = ansi(7),
      white_bright = ansi(15),
    },

    -- Kunci custom (bukan kosakata tokyonight, menggantikan engine lama).
    button = blue,
    footer = syntax.comment,
    smooth_body3 = teal,
    smooth_tail = dark5,
    accent = accent.primary,
    accent2 = accent.secondary,
    cursor = d.cursor,
  }
end

M.colors = build_colors(dark)

--- Token semantik -> hex, dipakai oleh peta sintaks di bagian [3].
M.syntax = dark.extra.syntax

-- ============================================================================
-- [3] OVERRIDE TOKYONIGHT
-- ============================================================================

local warned_missing_keys = false

--- Ubah hanya `fg` bila grup sudah bertabel (pertahankan `style` dll.);
--- bila masih string (link) atau nil, ganti utuh dengan `{ fg = warna }`.
--- Berlaku juga untuk grup yang hanya link: agar warnanya benar, grup link
--- yang ada di peta harus di-set langsung (tidak cukup mengandalkan induknya).
local function set_fg(hl, group, color)
  local current = hl[group]
  if type(current) == "table" then
    current.fg = color
  else
    hl[group] = { fg = color }
  end
end

local function apply_syntax_highlights(hl)
  local s = dark.extra.syntax

  local map = {
    { s.constant, "Constant", "@constant", "@constant.builtin" },
    { s.number, "Number", "Float", "@number", "@number.float" },
    { s.boolean, "Boolean", "@boolean" },
    { s.string, "String", "Character", "@string" },
    { s.special, "@string.escape" },
    { s.regex, "@string.regexp" },
    { s.identifier, "Identifier" },
    { s.variable, "@variable" },
    { s.builtin_variable, "@variable.builtin" },
    { s.parameter, "@variable.parameter" },
    { s.property, "@variable.member", "@property" },
    { s["function"], "Function", "@function", "@function.call" },
    { s.method, "@function.method", "@function.method.call" },
    { s.builtin, "@function.builtin" },
    { s.statement, "Statement", "Conditional", "Repeat", "Label" },
    { s.keyword, "Keyword", "@keyword", "@keyword.function" },
    { s["return"], "@keyword.return" },
    { s.exception, "@keyword.exception", "Exception" },
    { s.import, "PreProc", "Include", "Define", "Macro", "@keyword.import" },
    { s.operator, "@keyword.operator", "Operator", "@operator" },
    { s.type, "Type", "StorageClass", "Structure", "@type", "@type.builtin" },
    { s.class, "@constructor" },
    { s.special, "Special" },
    {
      s.punctuation,
      "Delimiter",
      "@punctuation.delimiter",
      "@punctuation.bracket",
      "@punctuation.special",
      "@tag.delimiter",
    },
    { s.decorator, "@attribute", "@attribute.builtin" },
    { s.tag, "@tag" },
    { s.attribute, "@tag.attribute" },
  }

  for _, entry in ipairs(map) do
    for i = 2, #entry do
      set_fg(hl, entry[i], entry[1])
    end
  end
end

--- Opsi lengkap untuk `require("tokyonight").setup(...)`.
function M.tokyonight_opts()
  return {
    style = "night",
    transparent = true,
    -- Kunci cache tokyonight tidak memuat Util.bg/Util.fg, jadi cache lama bisa
    -- menyajikan grup yang sudah di-blend dengan basis style asli. Nonaktifkan
    -- agar grup selalu dibangun ulang dengan basis palet kita.
    cache = false,

    on_colors = function(c)
      for key, value in pairs(M.colors) do
        c[key] = type(value) == "table" and vim.deepcopy(value) or value
      end

      -- tokyonight menangkap Util.bg/Util.fg dari palet mentah SEBELUM
      -- on_colors dipanggil, sehingga setiap Util.blend_bg/blend_fg() tanpa
      -- basis eksplisit akan mem-blend ke style asli (night), bukan ke palet
      -- kita. Arahkan ulang agar grup turunan tetap on-theme.
      local Util = require("tokyonight.util")
      Util.bg = c.bg
      Util.fg = c.fg

      -- Guard: style "night" mewarisi palet "storm", jadi kunci storm yang
      -- tidak ditimpa akan bocor sebagai warna tokyonight asli.
      if not warned_missing_keys then
        local missing = {}
        for key in pairs(require("tokyonight.colors.storm")) do
          if M.colors[key] == nil then
            missing[#missing + 1] = key
          end
        end
        if #missing > 0 then
          table.sort(missing)
          warned_missing_keys = true
          vim.notify(
            "[theme] kunci palet tokyonight tidak ditimpa: " .. table.concat(missing, ", "),
            vim.log.levels.WARN
          )
        end
      end
    end,

    on_highlights = function(hl, c)
      -- Transparansi + plugin yang sudah ada (perilaku dipertahankan).
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

      -- Peta token semantik yang lebih rinci daripada 1 warna per kunci palet.
      apply_syntax_highlights(hl)
    end,
  }
end

-- ============================================================================
-- [4] HIGHLIGHT PLUGIN NON-TOKYONIGHT
-- ============================================================================

-- markview's palette groups derive from Normal.bg, tapi tema transparan
-- (Normal.bg = "none"), jadi beri tahu background tema lewat global.
vim.g.markview_dark_bg = M.colors.bg
vim.g.markview_light_bg = M.colors.bg

function M.apply_plugin_highlights()
  local c = M.colors
  local set = vim.api.nvim_set_hl

  -- Alpha
  set(0, "AlphaHeader", { fg = c.magenta })
  set(0, "AlphaBorder", { fg = c.border })
  set(0, "AlphaButtons", { fg = c.button })
  set(0, "AlphaFooter", { fg = c.footer })

  -- Telescope: pertahankan pola lama (baca bg yang ada, lalu set fg).
  local function set_fg_keep_bg(name, fg)
    local current = vim.api.nvim_get_hl(0, { name = name })
    set(0, name, { fg = fg, bg = current.bg })
  end

  set_fg_keep_bg("TelescopeBorder", c.border)
  set_fg_keep_bg("TelescopePromptBorder", c.magenta)
  set_fg_keep_bg("TelescopePromptTitle", c.magenta)
  set_fg_keep_bg("TelescopeResultsTitle", c.purple)
  set_fg_keep_bg("TelescopePreviewTitle", c.magenta)

  -- SmoothCursor
  set(0, "SmoothCursor", { fg = c.accent2 })
  set(0, "SmoothCursorBody1", { fg = c.purple })
  set(0, "SmoothCursorBody2", { fg = c.blue })
  set(0, "SmoothCursorBody3", { fg = c.smooth_body3 })
  set(0, "SmoothCursorTail", { fg = c.smooth_tail })

  -- mini.indentscope
  set(0, "MiniIndentscopeSymbol", { fg = c.purple })
  set(0, "MiniIndentscopeSymbolOff", { fg = c.magenta })

  -- markview inline code (bg-nya hardcode bila Normal.bg tak di-set)
  set(0, "MarkviewInlineCode", { bg = c.terminal_black, fg = c.green })

  -- zen-mode
  set(0, "ZenNormal", { fg = c.fg, bg = "none" })

  -- cheatsheet badges
  set(0, "CheatModeN", { fg = c.blue, bold = true, default = true })
  set(0, "CheatModeV", { fg = c.green, bold = true, default = true })
  set(0, "CheatModeX", { fg = c.teal, bold = true, default = true })
  set(0, "CheatModeI", { fg = c.yellow, bold = true, default = true })
  set(0, "CheatModeO", { fg = c.red, bold = true, default = true })
  set(0, "CheatModeT", { fg = c.accent2, bold = true, default = true })
  set(0, "CheatModeS", { fg = c.purple, bold = true, default = true })

  -- Grup bawaan Neovim yang tidak didefinisikan tokyonight (kalau dibiarkan,
  -- warnanya jatuh ke default Neovim dan lepas dari palet).
  set(0, "DiagnosticOk", { fg = c.green2 })
  set(0, "DiagnosticUnderlineOk", { sp = c.green2, underline = true })
  set(0, "DiagnosticDeprecated", { sp = c.dark3, strikethrough = true })

  set(0, "Added", { fg = c.green2 })
  set(0, "Changed", { fg = c.blue2 })
  set(0, "Removed", { fg = c.red1 })

  set(0, "FloatShadow", { bg = c.bg_dark1 })
  set(0, "FloatShadowThrough", { bg = c.bg_dark1 })

  set(0, "NvimInternalError", { fg = c.bg, bg = c.red })
  set(0, "RedrawDebugClear", { fg = c.bg, bg = c.yellow })
  set(0, "RedrawDebugComposed", { fg = c.bg, bg = c.green2 })
  set(0, "RedrawDebugRecompose", { fg = c.bg, bg = c.red })
end

-- :colorscheme menghapus highlight group, jadi pasang ulang. Autocmd didaftarkan
-- saat theme.lua pertama di-require (init.lua me-require sebelum lazy).
M.apply_plugin_highlights()
local theme_augroup = vim.api.nvim_create_augroup("Theme", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = theme_augroup,
  callback = function()
    M.apply_plugin_highlights()
  end,
})

-- ============================================================================
-- [5] LAIN-LAIN
-- ============================================================================

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

  if vim.fn.has("nvim-0.11") == 1 then
    vim.o.winborder = "rounded"
  else
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  end
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
