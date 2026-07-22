local M = {}
local Snacks = require("snacks")
local ai_term = nil

local function get_visual_selection()
  local orig = vim.fn.getreg('"')
  vim.cmd('normal! "vy')
  local selected = vim.fn.getreg('"')
  vim.fn.setreg('"', orig)
  return selected
end

function M.ask()
  local selected = get_visual_selection()
  if not selected or #selected == 0 then
    vim.notify("Tidak ada kode terpilih", vim.log.levels.WARN)
    return
  end

  Snacks.input({
    prompt = "Tanyakan AI: ",
    default = "",
    expand = true,
  }, function(prompt)
    if not prompt or prompt == "" then return end

    local tmp = vim.fn.tempname() .. ".txt"
    local f = io.open(tmp, "w")
    f:write(selected)
    f:close()

    local escaped = prompt:gsub("'", "'\\''")

    -- ── Session / Role (pilih dengan cara uncomment) ──
    --
    -- [[PAKAI FISH FUNCTION (stateless)]]
    local term_cmd = string.format("ai_chat '%s' '%s'\n", escaped, tmp)
    --
    -- [[SESSION: percakapan berlanjut]]
    -- local term_cmd = string.format("aichat --session nvim --no-stream '%s' -f '%s' | mdcat --ansi\n", escaped, tmp)
    --
    -- [[ROLE: pakai role tertentu]]
    -- local term_cmd = string.format("aichat --role code-reviewer --no-stream '%s' -f '%s' | mdcat --ansi\n", escaped, tmp)

    if not ai_term or not ai_term:buf_valid() then
      ai_term = Snacks.terminal("fish", {
        auto_close = false,
        interactive = true,
        win = {
          position = "float",
          border = "rounded",
          height = 0.8,
          width = 0.8,
        },
      })
    elseif not ai_term:win_valid() then
      ai_term:show()
    end

    vim.defer_fn(function()
      local chan = vim.api.nvim_buf_get_option(ai_term.buf, "channel")
      if chan and chan > 0 then
        vim.api.nvim_chan_send(chan, term_cmd)
      end
    end, 200)
  end)
end

function M.toggle()
  if not ai_term then
    vim.notify("Belum ada sesi AI Chat", vim.log.levels.INFO)
    return
  end

  if ai_term:win_valid() then
    vim.api.nvim_win_close(ai_term.win, true)
  elseif ai_term:buf_valid() then
    ai_term.opts.buf = ai_term.buf
    ai_term:show()
  else
    vim.notify("Sesi AI Chat sudah berakhir", vim.log.levels.INFO)
    ai_term = nil
  end
end

return M
