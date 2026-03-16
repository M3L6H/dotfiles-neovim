local lazyAdd = require("nixCatsUtils").lazyAdd

--- Attempts to find the project root using LSP, root markers, or cwd.
--- @return string
local function get_project_root()
  -- Try LSP root
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  for _, client in ipairs(clients) do
    local workspace_folders = client.config.workspace_folders
    if workspace_folders and #workspace_folders > 0 then
      return vim.uri_to_fname(workspace_folders[1].uri)
    elseif client.config.root_dir then
      return client.config.root_dir
    end
  end

  -- Fallback to root markers
  local root_markers = {
    ".git",
    "package.json",
    "pyproject.toml",
    "Cargo.toml",
    "go.mod",
    "Makefile",
    "setup.py",
    "requirements.txt",
    "Pipfile",
    "tsconfig.json",
    "composer.json",
    "Gemfile",
    "build.gradle",
    "CMakeLists.txt",
    "meson.build",
    "project.clj",
    "mix.exs",
    "pubspec.yaml",
    "elm.json",
    "sln",
    "csproj",
    "Rakefile",
    "env",
    ".hg",
    ".svn",
    ".root",
    ".project",
    ".workspace",
  }
  local root = vim.fs.root(vim.api.nvim_buf_get_name(0), root_markers)
  if root then return root end

  -- Fallback to cwd
  return vim.fn.getcwd()
end

local codecompanion = {
  "olimorris/codecompanion.nvim",
  enabled = lazyAdd(vim.g.feat.ai, nixCats("ai")),
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<leader>aa",
      ":CodeCompanionActions<CR>",
      mode = { "n", "v" },
      desc = "[A]I [A]ctions",
    },
    {
      "<leader>ac",
      ":CodeCompanionChat<CR>",
      mode = { "n", "v" },
      desc = "[A]I [C]hat",
    },
    {
      "<leader>ai",
      ":CodeCompanion ",
      mode = { "n", "v" },
      desc = "[A]I [I]nline",
    },
    {
      "<leader>at",
      ":CodeCompanionChat Toggle<CR>",
      mode = { "n", "v" },
      desc = "[A]I [T]oggle Chat",
    },
  },
  opts = {
    display = {
      action_palette = {
        provider = "snacks",
        opts = {
          title = "AI Actions",
        },
      },
      chat = {
        intro_message = "Press ? for options",
        show_settings = true,
      },
    },
    interactions = {
      background = {
        chat = {
          callbacks = {
            ["on_ready"] = {
              actions = {
                "interactions.background.builtin.chat_make_title",
              },
              enabled = true,
            },
          },
          opts = {
            enabled = true,
          },
        },
      },
      chat = {
        editor_context = {
          ["buffer"] = {
            opts = {
              -- Send the whole buffer since Copilot pricing is based on requests not tokens
              default_params = "all",
            },
          },
        },
        tools = {
          ["run_command"] = {
            opts = {
              require_cmd_approval = true,
            },
          },
        },
      },
    },
    prompt_library = {
      markdown = {
        dirs = {
          get_project_root() .. "/.prompts",
          "~/.ai/prompts",
        },
      },
    },
  },
}

local copilot = {
  "zbirenbaum/copilot.lua",
  enabled = lazyAdd(vim.g.feat.ai, nixCats("ai")),
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    panel = {
      enabled = false,
    },
    suggestion = {
      enabled = false,
    },
  },
}

return {
  codecompanion,
  copilot,
}
