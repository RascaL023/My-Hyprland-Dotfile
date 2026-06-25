return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  opts = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local theme = require("core.theme")

    theme.apply_alpha_highlights()

    ------------------------------------------------------
    -- BIG ANIME ASCII
    ------------------------------------------------------
    -- local anime = require("sources.anime1")
    -- dashboard.section.header.val = anime 
    local tree = require("sources.stone")
    dashboard.section.header.val = vim.split(tree, "\n")
    dashboard.section.header.opts.hl = "AlphaHeader"

    ------------------------------------------------------
    -- QUOTES
    ------------------------------------------------------
    local quotes = {
      "“Stay focused and keep coding.”",
      "“Simplicity is elegance.”",
      "“Every bug teaches you something.”",
      "“Build. Break. Learn.”",
      "“Good code is its own best documentation.”",
    }
    local function random_quote()
      math.randomseed(os.time())
      return quotes[math.random(#quotes)]
    end

    ------------------------------------------------------
    -- BUTTONS
    ------------------------------------------------------
    dashboard.section.buttons.val = {
      dashboard.button("e", "   New File", ":ene<CR>"),
      dashboard.button("f", "󰈞   Find File", ":Telescope find_files<CR>"),
      dashboard.button("g", "   Live Grep", ":Telescope live_grep<CR>"),
      dashboard.button("r", "   Recent", ":Telescope oldfiles<CR>"),
      dashboard.button("c", "   Config", ":e ~/.config/nvim/init.lua<CR>"),
      dashboard.button("q", "   Quit", ":qa<CR>"),
    }

    for _, b in ipairs(dashboard.section.buttons.val) do
      b.opts.hl = "AlphaButtons"
      b.opts.hl_shortcut = "AlphaButtons"
    end

    ------------------------------------------------------
    -- BIG BORDER (Full-width container)
    ------------------------------------------------------
    local border_top    = "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    local border_bottom = "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

    local bordered_group = {
      type = "group",
      val = {
        { type = "text", val = border_top, opts = { hl = "AlphaBorder", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        { type = "text", val = border_bottom, opts = { hl = "AlphaBorder", position = "center" } },
      },
    }

    ------------------------------------------------------
    -- FOOTER
    ------------------------------------------------------
    dashboard.section.footer.val = random_quote()
    dashboard.section.footer.opts.hl = "AlphaFooter"

    ------------------------------------------------------
    -- FINAL LAYOUT
    ------------------------------------------------------
    dashboard.config.layout = {
      { type = "padding", val = 1 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      bordered_group,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    return dashboard.config
  end,
}
