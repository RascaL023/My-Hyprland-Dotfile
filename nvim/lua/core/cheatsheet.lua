local M = {}

local mode_info = {
  n = { label = "N", hl = "CheatModeN", fg = "#89b4fa" },
  v = { label = "V", hl = "CheatModeV", fg = "#a6e3a1" },
  x = { label = "X", hl = "CheatModeX", fg = "#94e2d5" },
  i = { label = "I", hl = "CheatModeI", fg = "#f9e2af" },
  o = { label = "O", hl = "CheatModeO", fg = "#f38ba8" },
  t = { label = "T", hl = "CheatModeT", fg = "#f5c2e7" },
  s = { label = "S", hl = "CheatModeS", fg = "#cba6f7" },
}

local function infer_desc(map)
  if map.desc and map.desc ~= "" then
    return map.desc
  end

  if not map.rhs then return nil end

  for pattern in map.rhs:gmatch(":([%w_%.]+)") do
    local name = pattern:gsub("^[%w_]+%.", "")
    name = name:gsub("_", " "):gsub("^%l", string.upper)
    if name ~= "" then return name end
  end

  local plain = map.rhs:gsub("<[^>]+>", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
  if plain and #plain > 0 and #plain < 50 then
    return plain
  end

  return nil
end

function M.show()
  local entries = {}
  local total = 0

  for mode, info in pairs(mode_info) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
      local desc = infer_desc(map)
      if desc then
        table.insert(entries, {
          mode = mode,
          badge = info.label,
          hl_group = info.hl,
          lhs = map.lhs,
          desc = desc,
        })
        total = total + 1
      end
    end
  end

  if total == 0 then
    vim.notify("Belum ada keymap yang terdaftar", vim.log.levels.INFO)
    return
  end

  table.sort(entries, function(a, b)
    if a.mode ~= b.mode then return a.mode < b.mode end
    return a.desc < b.desc
  end)

  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("Telescope gak tersedia", vim.log.levels.ERROR)
    return
  end

  for _, info in pairs(mode_info) do
    vim.api.nvim_set_hl(0, info.hl, { fg = info.fg, bold = true, default = true })
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create {
    separator = " │ ",
    items = {
      { width = 3 },
      { width = 28 },
      { remaining = true },
    },
  }

  pickers.new({}, {
    prompt_title = ("󰌌  Keymaps (%d)"):format(total),
    finder = finders.new_table {
      results = entries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = function(e)
            return displayer {
              { e.value.badge, e.value.hl_group },
              e.value.lhs,
              e.value.desc,
            }
          end,
          ordinal = entry.desc .. " " .. entry.lhs .. " " .. entry.mode,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    previewer = false,
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<CR>", function(prompt_bufnr)
        actions.close(prompt_bufnr)
      end)
      return true
    end,
  }):find()
end

return M
