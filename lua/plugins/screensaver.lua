local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "Root-lee/screensaver.nvim",
  enabled = lazyAdd(vim.g.plugins.screensaver, nixCats("screensaver")),
  event = "VeryLazy",
  opts = {
    animations = { "zoo" },
  },
}

return M
