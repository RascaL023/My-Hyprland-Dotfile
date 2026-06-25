return {
  "mbbill/undotree",
  config = function()
    -- Set keymap to toggle undotree
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
  end,
}
