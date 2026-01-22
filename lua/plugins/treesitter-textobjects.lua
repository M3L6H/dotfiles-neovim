local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  enabled = lazyAdd(vim.g.plugins.treesitter, nixCats("treesitter")),
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "BufReadPost",
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true
  end,
  config = function()
    -- We set up the other required treesitter configs in the treesitter plugin file
    ---@diagnostic disable-next-line missing-fields
    require("nvim-treesitter-textobjects").setup({
      select = {
        enable = true,

        lookahead = true,

        keymaps = {
          ["ac"] = { query = "@class.outer", desc = "Select outer class" },
          ["ic"] = { query = "@class.inner", desc = "Select inner class" },
          ["af"] = { query = "@function.outer", desc = "Select outer function" },
          ["if"] = { query = "@function.inner", desc = "Select inner function" },
          ["am"] = { query = "@method.outer", desc = "Select outer method" },
          ["im"] = { query = "@method.inner", desc = "Select inner method" },
        },
      },
      move = {
        enable = true,
        set_jumps = false,
        goto_next_start = {
          ["]a"] = { query = "@argument.outer", desc = "Go to next argument start" },
          ["]c"] = { query = "@class.outer", desc = "Go to next class start" },
          ["]f"] = { query = "@function.outer", desc = "Go to next function start" },
          ["]m"] = { query = "@method.outer", desc = "Go to next method start" },
        },
        goto_next_end = {
          ["]A"] = { query = "@argument.outer", desc = "Go to next argument end" },
          ["]C"] = { query = "@class.outer", desc = "Go to next class end" },
          ["]F"] = { query = "@function.outer", desc = "Go to next function end" },
          ["]M"] = { query = "@method.outer", desc = "Go to next method end" },
        },
        goto_previous_start = {
          ["[a"] = { query = "@argument.outer", desc = "Go to prev argument start" },
          ["[c"] = { query = "@class.outer", desc = "Go to prev class start" },
          ["[f"] = { query = "@function.outer", desc = "Go to prev function start" },
          ["[m"] = { query = "@method.outer", desc = "Go to prev method start" },
        },
        goto_previous_end = {
          ["[A"] = { query = "@argument.outer", desc = "Go to prev argument end" },
          ["[C"] = { query = "@class.outer", desc = "Go to prev class end" },
          ["[F"] = { query = "@function.outer", desc = "Go to prev function end" },
          ["[M"] = { query = "@method.outer", desc = "Go to prev method end" },
        },
      },
    })
  end,
}

return M
