local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = lazyAdd(vim.g.plugins["render-markdown"], nixCats("render-markdown")),
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = "markdown", -- Only load on markdown files
  config = function()
    local render_markdown = require("render-markdown")
    render_markdown.setup({
      completions = { lsp = { enabled = true } },
      latex = { enabled = false }, -- We use snacks for LaTeX rendering
      code = {
        disable_background = true,
      },
    })
    local hl = vim.api.nvim_set_hl
    hl(0, "RenderMarkdownCode", { bg = "none" })
    hl(0, "RenderMarkdownCodeInline", { bg = "none" })
  end,
}

return M
