local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = lazyAdd(vim.g.plugins["render-markdown"], nixCats("render-markdown")),
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = "markdown", -- Only load on markdown files
  opts = {
    completions = { lsp = { enabled = true } },
    latex = { enabled = false }, -- We use snacks for LaTeX rendering
  },
}

return M
