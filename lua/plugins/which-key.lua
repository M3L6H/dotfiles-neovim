local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "folke/which-key.nvim",
  enabled = lazyAdd(vim.g.plugins["which-key"], nixCats("which-key")),
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "[Buffer local] Which key?",
    },
  },
  opts = {
    preset = "modern",
  },
}

return M
