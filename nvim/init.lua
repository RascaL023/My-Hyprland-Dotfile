require("core.options")
require("core.bindings")
require("core.theme").setup_base_ui()
require("core.lazy")
require("core.livereload")

vim.g.VM_maps = {
  ["Find Under"]         = "<C-d>",
  ["Find Subword Under"] = "<C-d>",
}

