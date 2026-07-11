local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local function zen_close()
  local ok, view = pcall(require, "zen-mode.view")
  if ok and view.is_open() then
    require("zen-mode").close()
  end
end

map("n", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Tools 
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- Copy - Paste
map("v", "<C-c>", '"+yI')
map("n", "<C-v>", '"+p')
-- map("i", "<C-v>", '<ESC>"+pI', opts)
-- map("i", "<C-c>", function()
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>yyi", true, false, true), "n", true)
-- end, opts)
-- map("i", "<C-v>", function()
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>p==i", true, false, true), "n", true)
-- end, opts)

-- Selections
-- map("n", "<S-Left>", "v<Left>")
-- map("n", "<S-Right>", "v<Right>")
-- map("n", "<S-Up>", "v<Up>")
-- map("n", "<S-Down>", "v<Down>")
-- map("i", "<S-Left>", "<Esc>v<Left>")
-- map("i", "<S-Right>", "<Esc>v<Right>")
-- map("i", "<S-Up>", "<Esc>v<Up>")
-- map("i", "<S-Down>", "<Esc>v<Down>")
-- map("n", "<S-Left>",  "gh<Left>")
-- map("n", "<S-Right>", "gh<Right>")
-- map("n", "<S-Up>",    "gh<Up>")
-- map("n", "<S-Down>",  "gh<Down>")
map("i", "<S-Left>",  "<Esc>gh<Left>")
map("i", "<S-Right>", "<Esc>gh<Right>")
map("i", "<S-Up>",    "<Esc>gh<Up>")
map("i", "<S-Down>",  "<Esc>gh<Down>")
map("v", "<S-Left>", "<Left>")
map("v", "<S-Right>", "<Right>")
map("v", "<S-Up>", "<Up>")
map("v", "<S-Down>", "<Down>")
map({ "n", "i" }, "<S-End>", "<Esc>v<End>")
map({ "n", "i" }, "<S-Home>", "<Esc>v<Home>")
map({ "n", "i" }, "<C-a>", function()
  vim.cmd("normal! ggVG")
end, opts)
map("n", "<leader>a", "ggVG\"+y", opts) -- select all + copy

-- Save
map({ "n", "v" }, "<C-s>", ":w<CR>")
map("i", "<C-s>", "<Esc>:w<CR>i")

-- Undo - Redo
map("n", "<C-z>", "u", opts)
map("i", "<C-z>", "<Esc>ua", opts)
map("v", "<C-z>", "<Esc>ugv", opts)
map("n", "<C-y>", "<C-r>", opts)
map("i", "<C-y>", "<Esc><C-r>a", opts)
map("v", "<C-y>", "<Esc><C-r>gv", opts)

-- Delete Per Kata
map("i", "<C-BS>", "<C-w>", opts)
map("i", "<C-H>", "<C-w>", opts)
map("i", "<C-Del>", "<C-o>dw", opts)

-- Move selected
map("n", "<A-Up>", ":m .-2<CR>==", opts)
map("n", "<A-Down>", ":m .+1<CR>==", opts)
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", opts)

-- Comment toggle
map({ "n", "i" }, "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, {})

map("v", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>i", {})

-- Close active
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
end)

-- Close file + buffer
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
end, { noremap = true, silent = true })


-- Switch file
map("n", "<Tab>", ":bnext<CR>", { silent = true })
map("n", "<S-Tab>", ":bprevious<CR>", { silent = true })

-- Window Switcher
map("n", "<A-Left>", "<C-w>h")
map("n", "<A-Down>", "<C-w>j")
map("n", "<A-Up>", "<C-w>k")
map("n", "<A-Right>", "<C-w>l")
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
-- Resizing
map("n", "<C-Up>",    "<C-w>+", { desc = "Increase height" })
map("n", "<C-Down>",  "<C-w>-", { desc = "Decrease height" })
map("n", "<C-Left>",  "<C-w><", { desc = "Decrease width" })
map("n", "<C-Right>", "<C-w>>", { desc = "Increase width" })



-- Indent & unindent 
map("v", "<Tab>", ">gv", { silent = true })
map("v", "<S-Tab>", "<gv", { silent = true })

-- Tab Management
map("n", "<leader>tt", function()
  local dir = vim.fn.input("Tab folder: ", "", "dir")
  if dir ~= "" then
    vim.cmd("tabnew")
    vim.cmd("tcd " .. dir)
    vim.cmd("Telescope find_files")
  end
end, { noremap = true, silent = true })

-- NvimTree root find
map("n", "<leader>tf", function()
  local path = vim.fn.input("Open NvimTree at: ", vim.fn.getcwd() .. "/")
  if path ~= "" then
    vim.cmd("NvimTreeOpen " .. path)
  end
end, { desc = "NvimTree: Open at path" })

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
end, { desc = "LSP: Toggle buffer" })

-- Zen mode
map("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Zen mode toggle" })

-- Markdown preview toggle
map("n", "<leader>mm", "<CMD>Markview toggle<CR>", { desc = "Toggle markdown preview" })

-- Git ignore toggle
map("n", "<leader>gi", function()
  require("nvim-tree.api").tree.toggle_gitignore_filter()
end, { desc = "Toggle gitignore in NvimTree" })


-- Definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
  silent = true,
  noremap = true,
  desc = "Go to definition",
})

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
  silent = true,
  noremap = true,
  desc = "Go to declaration",
})

vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
  silent = true,
  noremap = true,
  desc = "Go to implementation",
})

vim.keymap.set("n", "gr", vim.lsp.buf.references, {
  silent = true,
  noremap = true,
  desc = "Go to references",
})

vim.keymap.set("n", "K", vim.lsp.buf.hover, {
  silent = true,
  noremap = true,
  desc = "Hover documentation",
})
