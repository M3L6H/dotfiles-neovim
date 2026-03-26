local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "sphamba/smear-cursor.nvim",
  enabled = (not vim.env.SSH_CLIENT or vim.env.SSH_CONNECTION)
    and lazyAdd(vim.g.plugins["smear-cursor"], nixCats("smear-cursor")),
  event = "BufReadPost",
  opts = {
    stiffness = 0.8,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.5,
    legacy_computing_symbols_support = true,
    smear_insert_mode = false,
  },
}

return M
