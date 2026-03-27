local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "Root-lee/screensaver.nvim",
  enabled = (not (vim.env.SSH_CLIENT or vim.env.SSH_CONNECTION))
    and lazyAdd(vim.g.plugins.screensaver, nixCats("screensaver")),
  event = "VeryLazy",
  opts = {
    animations = { "zoo" },
  },
}

return M
