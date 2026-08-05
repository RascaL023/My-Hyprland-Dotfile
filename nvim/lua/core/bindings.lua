local map = vim.keymap.set

-- state per-proses: ft -> { managed = { [server_name] = true }, nonmanaged = boolean }
local lsp_disabled_ft = {}

-- Mencegat vim.lsp.start: filetype yang di-disable tidak pernah attach
local lsp_start = vim.lsp.start
vim.lsp.start = function(config, opts)
  local bufnr = opts and opts.bufnr or vim.api.nvim_get_current_buf()
  if lsp_disabled_ft[vim.bo[bufnr].filetype] then
    return nil
  end
  return lsp_start(config, opts)
end

local function zen_close()
  local ok, view = pcall(require, "zen-mode.view")
  if ok and view.is_open() then
    require("zen-mode").close()
  end
end

map("n", "<Space>", "<Nop>", { desc = "Disable default space" })
vim.g.mapleader = " "

-- Tools
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree: toggle" })
local telescope_show_ignored = false

local function open_find_files()
  require("telescope.builtin").find_files({ no_ignore = telescope_show_ignored })
end

map("n", "<leader>ff", open_find_files, { desc = "Telescope: cari file" })
map("n", "<leader>fF", function()
  telescope_show_ignored = not telescope_show_ignored
  if telescope_show_ignored then
    vim.notify("find_files: tampilkan file ignored git", vim.log.levels.INFO)
  else
    vim.notify("find_files: sembunyikan file ignored git", vim.log.levels.WARN)
  end
end, { desc = "Telescope: toggle file ignored git" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Telescope: cari teks" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope: daftar buffer" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope: cari help" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope: cari diagnostik" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Telescope: cari function/type dalam file" })
map("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Telescope: cari simbol dalam workspace" })
map("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Telescope: preview colorscheme" })
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Telescope: resume telescope" })

map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope: cari file git diff" })
map("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { desc = "Telescope: cari file yang di track git" })

-- Copy - Paste
map("v", "<C-c>", '"+yI', { desc = "Copy ke clipboard" })
map("n", "<C-v>", '"+p', { desc = "Paste dari clipboard" })

-- Selections
map("i", "<S-Left>", "<Esc>gh<Left>", { desc = "Select left" })
map("i", "<S-Right>", "<Esc>gh<Right>", { desc = "Select right" })
map("i", "<S-Up>", "<Esc>gh<Up>", { desc = "Select up" })
map("i", "<S-Down>", "<Esc>gh<Down>", { desc = "Select down" })
map("v", "<S-Left>", "<Left>", { desc = "Extend left" })
map("v", "<S-Right>", "<Right>", { desc = "Extend right" })
map("v", "<S-Up>", "<Up>", { desc = "Extend up" })
map("v", "<S-Down>", "<Down>", { desc = "Extend down" })
map({ "n", "i" }, "<S-End>", "<Esc>v<End>", { desc = "Select to end" })
map({ "n", "i" }, "<S-Home>", "<Esc>v<Home>", { desc = "Select to home" })
map({ "n", "i" }, "<C-a>", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select all" })
map("n", "<leader>c", "ggVG\"+y", { desc = "Select all + copy (dipindah ke <leader>c)" })

-- Save
map({ "n", "v" }, "<C-s>", ":w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc>:w<CR>i", { desc = "Save file (insert)" })

-- AIChat
map("v", "<leader>a", function()
  require("core.aichat").ask()
end, { desc = "AI Chat: tanya kode terpilih (terminal float)" })
map("n", "<leader>at", function()
  require("core.aichat").toggle()
end, { desc = "AI Chat: toggle terminal" })


-- Undo - Redo
map("n", "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<Esc>ua", { desc = "Undo (insert)" })
map("v", "<C-z>", "<Esc>ugv", { desc = "Undo (visual)" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("i", "<C-y>", "<Esc><C-r>a", { desc = "Redo (insert)" })
map("v", "<C-y>", "<Esc><C-r>gv", { desc = "Redo (visual)" })

-- Delete Per Kata
map("i", "<C-BS>", "<C-w>", { desc = "Hapus kata ke kiri" })
map("i", "<C-H>", "<C-w>", { desc = "Hapus kata ke kiri (alt)" })
map("i", "<C-Del>", "<C-o>dw", { desc = "Hapus kata ke kanan" })

-- Move baris
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Pindah baris ke atas" })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Pindah baris ke bawah" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Pindah seleksi ke atas" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Pindah seleksi ke bawah" })
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Pindah baris ke bawah (insert)" })
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Pindah baris ke atas (insert)" })

-- Comment toggle
map({ "n", "i" }, "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

map("v", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>i", { desc = "Toggle comment (visual)" })

-- Close window
map("n", "<leader>w", function()
  zen_close()
  if vim.bo.modified then
    local input = vim.fn.input("Save before quit? (y/n): ")
    if input == "y" then
      vim.cmd("w | q")
    elseif input == "n" then
      vim.cmd("q!")
    end
  else
    vim.cmd("q")
  end
end, { desc = "Tutup window" })

-- Close buffer
map("n", "<leader>q", function()
  zen_close()
  if vim.bo.modified then
    local input = vim.fn.input("Save changes? (y/n): ")
    if input == "y" then
      vim.cmd("write")
      vim.cmd("bdelete")
    elseif input == "n" then
      vim.cmd("bdelete!")
    else
      print("Canceled")
    end
  else
    vim.cmd("bdelete")
  end
end, { desc = "Tutup buffer" })

-- Switch buffer
map("n", "<Tab>", ":bnext<CR>", { desc = "Buffer next" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Buffer previous" })

-- Window navigation
map("n", "<A-Left>", "<C-w>h", { desc = "Window: kiri" })
map("n", "<A-Down>", "<C-w>j", { desc = "Window: bawah" })
map("n", "<A-Up>", "<C-w>k", { desc = "Window: atas" })
map("n", "<A-Right>", "<C-w>l", { desc = "Window: kanan" })
map("n", "<C-h>", "<C-w>h", { desc = "Window: kiri" })
map("n", "<C-j>", "<C-w>j", { desc = "Window: bawah" })
map("n", "<C-k>", "<C-w>k", { desc = "Window: atas" })
map("n", "<C-l>", "<C-w>l", { desc = "Window: kanan" })
-- Resizing
map("n", "<C-Up>", "<C-w>+", { desc = "Window: tambah tinggi" })
map("n", "<C-Down>", "<C-w>-", { desc = "Window: kurangi tinggi" })
map("n", "<C-Left>", "<C-w><", { desc = "Window: kurangi lebar" })
map("n", "<C-Right>", "<C-w>>", { desc = "Window: tambah lebar" })

-- Indent & unindent 
map("v", "<Tab>", ">gv", { desc = "Indent" })
map("v", "<S-Tab>", "<gv", { desc = "Unindent" })

-- Tab Management
map("n", "<leader>tt", function()
  local dir = vim.fn.input("Tab folder: ", "", "dir")
  if dir ~= "" then
    vim.cmd("tabnew")
    vim.cmd("tcd " .. dir)
    vim.cmd("Telescope find_files")
  end
end, { desc = "Tab: buka folder baru" })

-- NvimTree at path
map("n", "<leader>tp", function()
  local path = vim.fn.input("Open NvimTree at: ", vim.fn.getcwd() .. "/")
  if path ~= "" then
    vim.cmd("NvimTreeOpen " .. path)
  end
end, { desc = "NvimTree: buka di path" })

-- LSP Toggle
map("n", "<leader>lt", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients > 0 then
    for _, client in ipairs(clients) do
      vim.lsp.buf_detach_client(bufnr, client.id)
    end
    vim.b.lsp_disabled = true
    vim.notify("LSP detached (buffer)", vim.log.levels.WARN)
  else
    vim.b.lsp_disabled = false
    vim.cmd("edit") -- reload buffer → LSP auto-attach
    vim.notify("LSP re-attached", vim.log.levels.INFO)
  end
end, { desc = "LSP: toggle buffer" })

-- LSP Toggle Permanen (per filetype, session-only)
map("n", "<leader>lT", function()
  local ft = vim.bo.filetype

  if ft == "" then
    vim.notify("LSP: no filetype on current buffer", vim.log.levels.WARN)
    return
  end

  local state = lsp_disabled_ft[ft]

  if state then
    -- ENABLE kembali: hapus blokir DULU agar wrapper tak memblokir re-attach
    lsp_disabled_ft[ft] = nil
    for name in pairs(state.managed) do
      vim.lsp.enable(name, true)
    end
    if state.nonmanaged then
      vim.api.nvim_exec_autocmds("FileType", { buffer = 0, modeline = false })
    end
    vim.notify("LSP enabled for filetype: " .. ft, vim.log.levels.INFO)
  else
    -- DISABLE: matikan semua server untuk filetype ini (FORCE, bukan graceful)
    local managed = {}
    for name in pairs(vim.lsp._enabled_configs) do
      local config = vim.lsp.config[name]
      if config and vim.tbl_contains(config.filetypes or {}, ft) then
        managed[name] = true
        vim.lsp.enable(name, false) -- hapus dari _enabled_configs (anti auto-start)
        for _, client in ipairs(vim.lsp.get_clients({ name = name })) do
          client:stop(true) -- SIGTERM: graceful shutdown meninggalkan zombie
        end
      end
    end
    -- force-stop client non-managed (mis. jdtls lewat ftplugin) yg masih nempel
    local nonmanaged = false
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[bufnr].filetype == ft then
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
          if not managed[client.name] then
            nonmanaged = true
            client:stop(true)
          end
        end
      end
    end
    lsp_disabled_ft[ft] = { managed = managed, nonmanaged = nonmanaged }
    vim.notify("LSP disabled for filetype: " .. ft, vim.log.levels.WARN)
  end
end, { desc = "LSP: toggle permanen (per filetype)" })

-- Zen mode
map("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Zen mode toggle" })

-- Markdown preview
map("n", "<leader>mm", "<CMD>Markview toggle<CR>", { desc = "Markdown: toggle preview" })

-- Text wrap
map("n", "<leader>r", function()
  if vim.wo.wrap then
    vim.wo.wrap = false
    vim.wo.linebreak = false
    vim.wo.breakindent = false
    vim.notify("Wrap OFF", vim.log.levels.INFO)
  else
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.breakindent = true
    vim.notify("Wrap ON", vim.log.levels.INFO)
  end
end, { desc = "Toggle text wrap" })

-- Cheatsheet
map("n", "<leader>?", function()
  require("core.cheatsheet").show()
end, { desc = "Cheatsheet: cari keymap" })

map("n", "<leader>??", function()
  require("telescope.builtin").keymaps({
    modes = { "n", "v", "i", "x" },
  })
end, { desc = "Keymaps: semua (termasuk default)" })

-- Git ignore toggle
map("n", "<leader>gi", function()
  require("nvim-tree.api").tree.toggle_gitignore_filter()
end, { desc = "NvimTree: toggle gitignore" })

-- LSP definitions
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP: go to references" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP: hover docs" })

-- Snacks
map("n", "<leader>lg", function() require("snacks").lazygit() end, { desc = "Lazygit" })

-- NvimTree Refresh
map("n", "<leader>tr", "<cmd>NvimTreeRefresh<CR>", {
    desc = "Refresh NvimTree",
})

-- Remove search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", {
    silent = true,
    desc = "Clear search highlight",
})
