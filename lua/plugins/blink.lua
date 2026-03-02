local lazyAdd = require("nixCatsUtils").lazyAdd

local default_sources = { "lsp", "snippets", "path", "buffer" }
local extended_sources = { "lsp", "snippets", "path", "buffer" }

local providers = {}
local dependencies = { "echasnovski/mini.icons" }
local per_filetype = {
  lua = { inherit_defaults = true },
  markdown = { inherit_defaults = true },
  text = { inherit_defaults = true },
}

if lazyAdd(vim.g.plugins.lazydev, nixCats("lazydev")) then
  table.insert(per_filetype.lua, "lazydev")

  providers["lazydev"] = {
    name = "LazyDev",
    module = "lazydev.integrations.blink",
    score_offset = 100,
  }
end

if lazyAdd(vim.g.feat.dictionary, nixCats("dictionary")) then
  table.insert(dependencies, "archie-judd/blink-cmp-words")

  providers["dictionary"] = {
    name = "blink-cmp-words",
    module = "blink-cmp-words.dictionary",
  }

  providers["thesaurus"] = {
    name = "blink-cmp-words",
    module = "blink-cmp-words.thesaurus",
  }
end

if lazyAdd(vim.g.feat.ai, nixCats("ai")) then
  table.insert(dependencies, "fang2hou/blink-copilot")
  table.insert(extended_sources, 1, "copilot")

  providers["copilot"] = {
    name = "copilot",
    module = "blink-copilot",
    score_offset = 120,
    async = true,
  }
end

function is_cursor_at_end_of_word()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()

  local char_under_cursor = string.sub(current_line, col + 1, col + 1)
  if not char_under_cursor:find("%w") then return false end

  local next_char = string.sub(current_line, col + 2, col + 2)
  return next_char == "" or not next_char:find("%w")
end

local function open_provider(provider)
  if not is_cursor_at_end_of_word() then
    vim.opt.iskeyword:append({ "-" })
    vim.api.nvim_feedkeys("e", "x", true)
    vim.opt.iskeyword:remove({ "-" })
  end
  vim.api.nvim_feedkeys("a", "n", true)
  require("blink-cmp").show({
    providers = {
      provider,
    },
  })
end

local M = {
  "saghen/blink.cmp",
  enabled = lazyAdd(vim.g.plugins["blink-cmp"], nixCats("blink-cmp")),
  dependencies = dependencies,
  event = { "CmdlineEnter", "InsertEnter" },
  keys = {
    {
      "<A-d>",
      function() open_provider("dictionary") end,
      mode = { "n" },
      desc = "[D]ictionary",
    },
    {
      "<A-t>",
      function() open_provider("thesaurus") end,
      mode = { "n" },
      desc = "[T]hesaurus",
    },
  },
  opts = {
    keymap = {
      preset = "none",

      ["<C-space>"] = {
        function(cmp)
          cmp.show({
            providers = extended_sources,
          })
          return true
        end,
      },
      ["<A-d>"] = {
        function(cmp)
          if cmp.is_active() then return false end
          cmp.show({
            providers = {
              "dictionary",
            },
          })
          return true
        end,
        "hide_documentation",
        "show_documentation",
      },
      ["<A-t>"] = {
        function(cmp)
          if cmp.is_active() then return false end
          cmp.show({
            providers = {
              "thesaurus",
            },
          })
          return true
        end,
        "hide_documentation",
        "show_documentation",
      },
      ["<C-e>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.hide()
        end,
        "fallback",
      },

      -- Emulate IntelliJ behavior
      ["<CR>"] = {
        function(cmp)
          -- We track this so we can use preselect without jacking up enter
          if vim.g.cmp_selected then
            vim.g.cmp_selected = false
            return cmp.accept()
          end
        end,
        "fallback",
      },
      ["<Tab>"] = {
        function(cmp)
          vim.g.cmp_selected = false

          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<Up>"] = {
        function(cmp)
          vim.g.cmp_selected = true
          return cmp.select_prev()
        end,
        "fallback",
      },
      ["<Down>"] = {
        function(cmp)
          vim.g.cmp_selected = true
          return cmp.select_next()
        end,
        "fallback",
      },

      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },

      -- Select Nth item from the list
      ["<A-1>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 1 })
        end,
      },
      ["<A-2>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 2 })
        end,
      },
      ["<A-3>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 3 })
        end,
      },
      ["<A-4>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 4 })
        end,
      },
      ["<A-5>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 5 })
        end,
      },
      ["<A-6>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 6 })
        end,
      },
      ["<A-7>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 7 })
        end,
      },
      ["<A-8>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 8 })
        end,
      },
      ["<A-9>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 9 })
        end,
      },
      ["<A-0>"] = {
        function(cmp)
          vim.g.cmp_selected = false
          return cmp.accept({ index = 10 })
        end,
      },
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      ghost_text = { enabled = true, show_with_menu = true },
      list = {
        selection = {
          preselect = true, -- Ghost text doesn't work without it
        },
      },
      menu = {
        auto_show = true,
        draw = {
          columns = { { "item_idx" }, { "kind_icon" }, { "label", "label_description", gap = 1 } },
          components = {
            item_idx = {
              text = function(ctx)
                return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
              end,
              highlight = "BlinkCmpItemIdx",
            },
            kind_icon = {
              text = function(ctx)
                if ctx.kind_icon ~= nil then return ctx.kind_icon end
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                if ctx.kind_icon_highlight ~= nil then return ctx.kind_icon_highlight end
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            kind = {
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    sources = {
      default = default_sources,
      providers = providers,
      per_filetype = per_filetype,
    },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = {
        menu = { auto_show = true },
      },
    },
  },
}

return M
