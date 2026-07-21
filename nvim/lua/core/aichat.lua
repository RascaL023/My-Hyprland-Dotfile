local M = {}

local Snacks = require("snacks")
local function get_visual_selection()
  local orig = vim.fn.getreg('"')
  vim.cmd('normal! "vy')
  local selected = vim.fn.getreg('"')
  vim.fn.setreg('"', orig)
  return selected
end

local function render_mdcat_markdown(text)
  local out = {}
  local job = vim.system({"mdcat", "--ansi"}, {stdin=text, text=true}, function(res)
    if res.code ~= 0 or not res.stdout then
      out.result = nil
      out.err = res.stderr or "mdcat failed."
    else
      out.result = res.stdout
    end
  end)
  job:wait()
  return out.result or nil, out.err
end

function M.ask()
  -- Only works in visual mode
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
    Snacks.notify.info("Mengirim ke aichat...")
    vim.defer_fn(function()
      local result = {}
      local err_msg = nil
      local job = vim.system({"aichat", "--no-stream", prompt .. "\n" .. selected}, {text=true}, function(res)
        if res.code ~= 0 then
          err_msg = res.stderr or "aichat error"
        else
          result.response = res.stdout
        end
      end)
      job:wait()
      if err_msg then
        Snacks.notify.error("aichat gagal: " .. err_msg)
        return
      end
      local output = render_mdcat_markdown(result.response or "(tidak ada balasan)")
      if not output then
        Snacks.win {
          text = {"mdcat gagal, menampilkan plain markdown:", "", result.response or "(tidak ada balasan)"},
          ft = "markdown",
          show = true,
          border = "rounded",
          wo = {wrap = true},
          keys = { q = "close", ["<esc>"] = "close", y = function(self)
            vim.fn.setreg('+', result.response or "")
            Snacks.notify.info("Copied to clipboard")
            self:close()
          end },
        }
        return
      end
      local lines = vim.split(output, "\n", {plain = true})
      Snacks.win {
        text = lines,
        ft = "markdown",
        show = true,
        border = "rounded",
        wo = {wrap = true},
        keys = { q = "close", ["<esc>"] = "close", y = function(self)
          vim.fn.setreg('+', result.response or "")
          Snacks.notify.info("Copied to clipboard")
          self:close()
        end },
      }
    end, 10)
  end)
end

return M
