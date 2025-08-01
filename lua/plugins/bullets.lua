local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "bullets-vim/bullets.vim",
  enabled = lazyAdd(vim.g.langs.markdown, nixCats("markdown")),
  ft = { "markdown", "text", "gitcommit", "scratch" },
}

return M
