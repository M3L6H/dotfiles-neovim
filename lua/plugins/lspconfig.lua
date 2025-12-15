local utils = require("nixCatsUtils")
local lazyAdd = utils.lazyAdd
local isNixCats = utils.isNixCats

local lsps = {
  basedpyright = lazyAdd(vim.g.langs.python, nixCats("python")) and {
    pattern = { "*.py", "*.pyi" },
    settings = {
      basedpyright = {
        -- We will use our formatter for this
        disableOrganizeImports = true,
        analysis = {
          diagnosticMode = "workspace",
        },
      },
    },
  },
  bashls = lazyAdd(vim.g.langs.shell, nixCats("shell")) and {
    pattern = { "*.bash", "*.sh" },
    settings = {
      bashls = {
        shfmt = {
          -- Follow redirection operators with a space
          spaceRedirects = true,
        },
      },
    },
  },
  codebook = lazyAdd(vim.g.feat.dictionary, nixCats("dictionary")) and {
    pattern = {
      "*.c",
      "*.css",
      "*.go",
      "*.html",
      "*.java",
      "*.js",
      "*.jsx",
      "*.lua",
      "*.md",
      "*.py",
      "*.rb",
      "*.rs",
      "*.toml",
      "*.txt",
      "*.ts",
      "*.tsx",
    },
    settings = {},
  },
  cssls = lazyAdd(vim.g.langs.web, nixCats("web")) and {
    pattern = { "*.css", "*.less", "*.scss" },
    settings = {
      cssls = {
        validate = true,
        lint = {},
        completion = {
          triggerPropertyValueCompletion = true,
          completePropertyWithSemicolon = true,
        },
        hover = {
          documentation = true,
          references = false,
        },
      },
    },
  },
  emmet_language_server = lazyAdd(vim.g.langs.web, nixCats("web")) and {
    pattern = { "*.css", "*.html", "*.jsx", "*.less", "*.sass", "*.scss", "*.tsx" },
    settings = {},
  },
  eslint = lazyAdd(vim.g.langs.web, nixCats("web")) and {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    settings = {
      format = {
        enable = false, -- We use prettier for formatting
      },
    },
  },
  gdscript = lazyAdd(vim.g.langs.godot, nixCats("godot")) and {
    pattern = { "*.gd", "*.gdscript" },
    settings = {
      gdscript = {},
    },
  },
  lua_ls = lazyAdd(vim.g.langs.lua, nixCats("lua")) and {
    pattern = { "*.lua" },
    settings = {
      Lua = {
        signatureHelp = { enable = true },
        diagnostics = {
          globals = { "nixCats" },
        },
        -- Inlay hints
        hint = {
          enable = true,
          arrayIndex = "Disable",
          paramName = "Literal",
        },
      },
    },
  },
  marksman = lazyAdd(vim.g.langs.markdown, nixCats("markdown")) and {
    pattern = { "*.md" },
    settings = {}, -- No settings for marksman
  },
  -- We shouldn't need nixd if we are running outside of nixCats!
  nixd = lazyAdd(vim.g.langs.nix, nixCats("nix")) and {
    pattern = { "*.nix" },
    settings = {
      nixd = {
        nixpkgs = {
          expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
        },
        options = {
          nixos = {
            expr = nixCats.extra("nixdExtras.nixos_options"),
          },
          ["home-manager"] = {
            expr = nixCats.extra("nixdExtras.home_manager_options"),
          },
        },
        formatting = { command = { "nixfmt" } },
      },
    },
  },
  rust_analyzer = lazyAdd(vim.g.langs.rust, nixCats("rust")) and {
    pattern = { "*.rs" },
    settings = {
      ["rust-analyzer"] = {
        assist = {
          preferSelf = true,
        },
        completion = {
          fullFunctionSignatures = {
            enable = true,
          },
        },
        diagnostics = {
          styleLints = {
            enable = true,
          },
        },
        hover = {
          actions = {
            references = {
              enable = true,
            },
          },
          show = {
            enumVariants = 10,
            fields = 10,
          },
        },
        imports = {
          granularity = {
            enforce = true,
          },
        },
      },
    },
  },
  ts_ls = lazyAdd(vim.g.langs.web, nixCats("web")) and {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    settings = {},
  },
}

local M = {
  "neovim/nvim-lspconfig",
  enabled = lazyAdd(vim.g.plugins.lspconfig, nixCats("lspconfig")),
  cmd = { "LspInfo", "LspLog", "LspStart", "LspStop", "LspRestart" },
  init = function()
    local lspConfigPath = lazyAdd(
      require("lazy.core.config").options.root .. "/nvim-lspconfig",
      nixCats.extra("nixdExtras.nvim_lspconfig")
    )
    vim.opt.runtimepath:prepend(lspConfigPath)

    local diagnostic_config = {
      underline = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = "󰋼 ",
          [vim.diagnostic.severity.HINT] = "󰌵 ",
        },
      },
      severity_sort = true,
    }

    if not lazyAdd(vim.g.plugins["tiny-inline-diagnostic"], nixCats("tiny-inline-diagnostic")) then
      diagnostic_config.virtual_text = {
        severity = {
          max = vim.diagnostic.severity.ERROR,
          min = vim.diagnostic.severity.WARN,
        },
        source = "if_many",
        prefix = function(diagnostic, i, total)
          if i < total then return "" end

          local p = ""

          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            p = p .. " "
          elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            p = p .. " "
          elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            p = p .. "󰋼 "
          elseif diagnostic.severity == vim.diagnostic.severity.HINT then
            p = p .. "󰌵"
          end

          if total > 1 then p = p .. "" end

          return p
        end,
        virt_text_pos = "eol_right_align",
      }
    end

    vim.diagnostic.config(diagnostic_config)

    -- We use Mason-lspconfig when we are not in the nixcats world
    if isNixCats then
      for lsp, config in pairs(lsps) do
        if config then
          -- Merge any manually specified capabilities
          if nixCats("blink-cmp") then
            config.capabilities =
              require("blink.cmp").get_lsp_capabilities(config.capabilities or {})
          end
          vim.lsp.config(lsp, config)
        end
      end
    end

    -- We use Mason-lspconfig when we are not in the nixcats world
    if isNixCats then
      local buf_read_pre_lsp = vim.api.nvim_create_augroup("buf-read-pre-lsp", { clear = true })
      local lsp_attach = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_attach,
        pattern = "*",
        callback = function(event)
          local km = vim.keymap
          km.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, { desc = "[R]e[n]ame" })
          km.set(
            "n",
            "<leader>dd",
            function() vim.diagnostic.open_float() end,
            { desc = "[D]iagnostics [d]isplay" }
          )

          -- Get client
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.server_capabilities.inlayHintProvider then
            vim.g.inlay_hints_visible = true
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          end
        end,
        desc = "Additional LSP init after attach",
      })

      for lsp, config in pairs(lsps) do
        if config then
          vim.api.nvim_create_autocmd("BufReadPre", {
            group = buf_read_pre_lsp,
            pattern = config.pattern,
            callback = function() vim.lsp.enable(lsp) end,
            once = true,
            desc = "Enable lsp in BufReadPre",
          })

          if config.on_attach then
            vim.api.nvim_create_autocmd("LspAttach", {
              group = lsp_attach,
              pattern = config.pattern,
              callback = config.on_attach,
              desc = "Setup LSP-specific behavior on attach",
            })
          end
        end
      end
    end
  end,
}

return M
