local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "NMAC427/guess-indent.nvim",
  enabled = lazyAdd(vim.g.plugins["guess-indent"], nixCats("guess-indent")),
  event = "BufReadPost",
  opts = {
    buftype_exclude = {
      "checkhealth",
      "help",
      "lazy",
      "lspinfo",
      "mason",
      "oil",
      "snacks_dashboard",
      "Trouble",
    },
  },
}

return M
