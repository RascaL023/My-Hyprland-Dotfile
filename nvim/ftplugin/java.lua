local jdtls = require("jdtls")

-- Workspace untuk tiap project
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Autocomplete capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Root dir = folder project java
local root_dir = require("jdtls.setup").find_root({
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  ".git",
})

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
