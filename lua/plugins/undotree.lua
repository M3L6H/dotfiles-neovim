local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "mbbill/undotree",
  enabled = lazyAdd(vim.g.plugins.undotree, nixCats("undotree")),
  keys = {
    {
      "<leader>u",
      function()
        vim.cmd.UndotreeToggle()
        vim.cmd.wincmd("h")
      end,
      desc = "Toggle undotree",
    },
  },
}

return M
