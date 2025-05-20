local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "echasnovski/mini.diff",
  enabled = lazyAdd(vim.g.plugins["mini-diff"], nixCats("mini-diff")),
  event = "VeryLazy",
  keys = {
    {
      "<leader>go",
      function() require("mini.diff").toggle_overlay(0) end,
      desc = "Toggle mini.diff overlay",
    },
  },
  opts = {
    view = {
      style = "sign",
      signs = {
        add = "▎",
        change = "▎",
        delete = "",
      },
    },
  },
}

return M
