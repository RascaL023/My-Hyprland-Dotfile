-- Auto-copy static resources ke target/classes
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {
    "*/src/main/resources/static/**",
    "*/src/main/resources/templates/**"
  },
  callback = function()
    local src_file = vim.fn.expand("%:p") -- Path lengkap file yang di-save
    local dest_file = src_file:gsub("/src/main/resources/", "/target/classes/")
    
    -- Buat folder tujuan kalau belum ada
    local dest_dir = vim.fn.fnamemodify(dest_file, ":h")
    vim.fn.mkdir(dest_dir, "p")
    
    -- Copy file
    local cmd = string.format("cp '%s' '%s'", src_file, dest_file)
    vim.fn.system(cmd)
    
    -- Notifikasi
    print("✓ Copied: " .. vim.fn.fnamemodify(src_file, ":t"))
  end,
})
