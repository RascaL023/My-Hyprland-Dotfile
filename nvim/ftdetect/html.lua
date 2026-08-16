vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = { "*.html", "*.htm" },
  command = "set filetype=html"
})
