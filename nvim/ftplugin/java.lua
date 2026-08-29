local jdtls = require("jdtls")

-- Autocomplete capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Root dir = folder project java
-- .git bisa berupa direktori (repo normal) ATAU file (git worktree)
-- Basis pencarian = path buffer, bukan cwd, agar stabil walau dibuka dari parent
local bufpath = vim.api.nvim_buf_get_name(0)
local git_marker = vim.fs.find(".git", {
  upward = true,
  path = bufpath,
  limit = 1,
})[1]

local root_dir = git_marker and vim.fs.dirname(git_marker) or nil

if not root_dir then
  root_dir = require("jdtls.setup").find_root({
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
  })
end

if not root_dir then
  root_dir = vim.fs.dirname(bufpath)
end

-- Workspace untuk tiap project: diambil dari root (stabil per worktree)
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Path ke Lombok jar (sesuaikan dengan lokasi di sistem Anda)
-- Untuk Mason biasanya ada di: ~/.local/share/nvim/mason/packages/jdtls/
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local lombok_jar = mason_path .. "/lombok.jar"

-- Cek apakah lombok.jar ada, jika tidak beri warning
if vim.fn.filereadable(lombok_jar) == 0 then
  vim.notify(
    "Lombok jar not found at: " .. lombok_jar .. "\nPlease download lombok.jar manually",
    vim.log.levels.WARN
  )
end

-- Configuration JDTLS
local config = {
  cmd = { 
    "jdtls",
    "-data", 
    workspace_dir,
    -- Tambahkan javaagent untuk Lombok (HANYA ini, tanpa Xbootclasspath)
    "--jvm-arg=-javaagent:" .. lombok_jar,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      contentProvider = { preferred = "fernflower" }, -- buat decompile class
      completion = {
        favoriteStaticMembers = {
          "org.springframework.*",
          "org.springframework.boot.*"
        }
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        }
      },
      -- Tambahkan konfigurasi untuk Lombok
      configuration = {
        runtimes = {}
      },
      -- Enable annotation processing
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
    },
  },
  init_options = {
    bundles = {},
    extendedClientCapabilities = {
      classFileContentsSupport = true,
    },
  },
}

-- Start LSP
jdtls.start_or_attach(config)
