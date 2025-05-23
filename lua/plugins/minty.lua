local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "nvzone/minty",
  enabled = lazyAdd(vim.g.plugins.minty, nixCats("minty")),
  event = "BufReadPost",
  dependencies = {
    "nvzone/volt",
  },
  keys = {
    { "<leader>Cp", "<CMD>Huefy<CR>", desc = "[C]olor [p]ick" },
    { "<leader>Cs", "<CMD>Shades<CR>", desc = "[C]olor [s]hades" },
  },
  opts = {},
}

return M
