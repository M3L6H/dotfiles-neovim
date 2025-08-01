local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "bullets-vim/bullets.vim",
  enabled = lazyAdd(vim.g.plugins.bullets, nixCats("bullets")),
  ft = { "markdown", "text", "gitcommit", "scratch" },
}

return M
