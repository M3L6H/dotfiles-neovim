local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "windwp/nvim-autopairs",
  enabled = lazyAdd(vim.g.plugins.autopairs, nixCats("autopairs")),
  event = "InsertEnter",
  opts = {
    disable_filetype = { "oil", "snacks_picker_input" },
  },
}

return M
