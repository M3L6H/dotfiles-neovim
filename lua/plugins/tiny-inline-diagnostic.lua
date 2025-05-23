local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "rachartier/tiny-inline-diagnostic.nvim",
  enabled = lazyAdd(vim.g.plugins["tiny-inline-diagnostic"], nixCats("tiny-inline-diagnostic")),
  event = "VeryLazy",
  priority = 1000,
  opts = {
    preset = "ghost",
    options = {
      mutilines = true,
      show_all_diags_on_cursorline = true,
    },
  },
  init = function()
    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
}

return M
