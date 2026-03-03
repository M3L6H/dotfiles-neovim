local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "mfussenegger/nvim-jdtls",
  enabled = lazyAdd(vim.g.langs.java, nixCats("java")),
  event = "VeryLazy",
  config = function() end,
}

return M
