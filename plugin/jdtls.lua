-- Code from https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/setup-with-nvim-jdtls.md

local paths_ = require("constants.paths")
local join_paths = require("utils.paths").join_paths
local os = require("utils.os")

local cache_vars = {}

local root_files = {
  ".git",
  "mvnw",
  "gradlew",
  "build.gradle",
}

local function get_jdtls_paths()
  if cache_vars.paths then
    return cache_vars.paths
  end

  local paths = {}

  paths.data_dir = join_paths(paths_.cache_dir, "jdtls")

  local jdtls_install =
      require("mason-registry").get_package("jdtls"):get_install_path()

  paths.java_agent = join_paths(jdtls_install, "lombok.jar")
  paths.launcher_jar = vim.fn.glob(
    join_paths(jdtls_install, "plugins", "org.eclipse.equinox.launcher_*.jar")
  )

  if os.is_macos then
    paths.platform_config = join_paths(jdtls_install, "config_mac")
  elseif os.is_linux then
    paths.platform_config = join_paths(jdtls_install, "config_linux")
  elseif os.is_windows then
    paths.platform_config = join_paths(jdtls_install, "config_win")
  end

  paths.bundles = {}

  local java_test_path =
      require("mason-registry").get_package("java-test"):get_install_path()

  local java_test_bundle = vim.split(
    vim.fn.glob(join_paths(java_test_path, "/extension/server/*.jar")),
    "\n"
  )

  if java_test_bundle[1] ~= "" then
    vim.list_extend(paths.bundles, java_test_bundle)
  end

  local java_debug_path = require("mason-registry")
      .get_package("java-debug-adapter")
      :get_install_path()

  local java_debug_bundle = vim.split(
    vim.fn.glob(
      join_paths(
        java_debug_path,
        "/extension/server/com.microsoft.java.debug.plugin-*.jar"
      )
    ),
    "\n"
  )

  if java_debug_bundle[1] ~= "" then
    vim.list_extend(paths.bundles, java_debug_bundle)
  end

  cache_vars.paths = paths

  return paths
end

local function jdtls_setup(event)
  local jdtls = require("jdtls")

  local paths = get_jdtls_paths()
  local data_dir =
      join_paths(paths.data_dir, vim.fn.fnamemodify(vim.loop.cwd(), ":p:h:t"))

  if not cache_vars.capabilities then
    jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    cache_vars.capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      ok and cmp_nvim_lsp.default_capabilities() or {}
    )
  end

  local config = {
    cmd = {
      "java",

      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-javaagent:" .. paths.java_agent,
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",

      "-jar",
      paths.launcher_jar,

      -- 💀
      "-configuration",
      paths.platform_config,

      -- 💀
      "-data",
      data_dir,
    },
    settings = {
      -- jdt = {
      --   ls = {
      --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
      --   }
      -- },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = paths.runtimes,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      format = {
        enabled = true,
        settings = {
          profile = "GoogleStyle",
          url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
        },
      },
      signatureHelp = {
        enabled = true,
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
      },
      contentProvider = {
        preferred = "fernflower",
      },
      extendedClientCapabilities = jdtls.extendedClientCapabilities,
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
    handlers = {
      ["language/status"] = function() end, -- noop
    },
    root_dir = jdtls.setup.find_root(root_files),
    on_attach = require("lsp.on_attach"),
    capabilities = cache_vars.capabilities,
    flags = {
      allow_incremental_sync = true,
    },
    init_options = {
      bundles = paths.bundles,
      extendedClientCapabilities = {
        progressReportProvider = false,
      },
    },
  }

  jdtls.start_or_attach(config)

  vim.api.nvim_create_user_command("JdtCompile", function(opts)
    require("jdtls").compile(opts.fargs)
  end, {
    nargs = "?",
    complete = require("jdtls")._complete_compile,
  })

  vim.api.nvim_create_user_command("JdtSetRuntime", function(opts)
    require("jdtls").set_runtime(opts.fargs)
  end, {
    nargs = "?",
    complete = require("jdtls")._complete_set_runtime,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("jdtls_config", { clear = true }),
  pattern = "java",
  desc = "Setup jdtls",
  callback = jdtls_setup,
})
