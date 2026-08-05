return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          layout_strategy = "flex",
          file_ignore_patterns = { "%.git/" },
          path_display = function(_, path)
            local parts = vim.split(path, "/", { trimempty = true })
            local n = #parts
            if n > 4 then
              return "../" .. table.concat(parts, "/", n - 3, n)
            end
            return path
          end,
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
            -- width = 0.85,
            -- height = 0.85,
          },
          winblend = 10,
          borderchars = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },
        },
        pickers = {
          find_files = {
            no_ignore = false,
            hidden = true,
          },
        },
      })

      require("core.theme").apply_telescope_highlights()
    end,
  }
  
