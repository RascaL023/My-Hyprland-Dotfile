return {
  "mistweaverco/kulala.nvim",
  version = "v5.3.4",
  ft = { "http", "rest" },     -- load hanya saat membuka file .http atau .rest
  cmd = { "Kulala" },          -- atau saat menjalankan :Kulala
  config = function()
    require("kulala").setup({
      env_file = ".env",       -- optional: pakai file .env untuk variable
      split_direction = "vertical", -- tampilkan response di vertical split

      -- pretty print JSON otomatis
      formatters = {
        json = { "jq" }, -- menggunakan jq untuk format
      },
    })

    -- keybinding global untuk convenience
    vim.keymap.set("n", "<leader>kr", function()
      require("kulala").run()
    end, { desc = "Run Kulala API Request" })
  end,
}


-- return {
--   "mistweaverco/kulala.nvim",
--   ft = { "http", "rest" },
--   cmd = { "Kulala" },
--   keys = {
--     {
--       "<leader>kr",
--       function()
--         require("kulala").run()
--       end,
--       desc = "Run Kulala API Request",
--       ft = { "http", "rest" },
--     },
--   },
--   opts = {
--     global_keymaps = false,
--
--     lsp = {
--       filetypes = { "http", "rest" },
--       keymaps = false,
--     },
--
--     contenttypes = {
--       ["application/json"] = {
--         ft = "json",
--         formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
--       },
--     },
--   },
-- }

-- return {
--   "mistweaverco/kulala.nvim",
--   ft = { "http", "rest" },
--   keys = {
--     {
--       "<leader>kr",
--       function()
--         require("kulala").run()
--       end,
--       desc = "Run Kulala API Request",
--       ft = { "http", "rest" },
--     },
--   },
--   opts = {
--     global_keymaps = false,
--   },
-- }
