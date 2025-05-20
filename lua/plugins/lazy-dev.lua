local lazyAdd = require("nixCatsUtils").lazyAdd

local library = {
  "lazy.nvim",
  { path = "${3rd}/luv/library", words = { "vim%.uv" } },
}

if lazyAdd(vim.g.plugins.snacks, nixCats("snacks")) then
  table.insert(library, { path = "snacks.nvim", words = { "Snacks" } })
end

if lazyAdd(vim.g.plugins.trouble, nixCats("trouble")) then table.insert(library, "trouble.nvim") end

local M = {
  "folke/lazydev.nvim",
  enabled = lazyAdd(vim.g.plugins.lazydev, nixCats("lazydev")),
  ft = "lua", -- Only load on lua files
  opts = {
    library = library,
  },
}

return M
