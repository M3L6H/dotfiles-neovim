local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "stevearc/conform.nvim",
  enabled = lazyAdd(vim.g.plugins.conform, nixCats("conform")),
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format() end, desc = "Code format" },
  },
  opts = {
    formatters = {
      css_beautify = {
        cmd = "js-beautify",
        args = { "--css" },
      },
    },
    formatters_by_ft = {
      css = lazyAdd(vim.g.langs.css, nixCats("css")) and { "stylelint", "css_beautify" } or {},
      lua = lazyAdd(vim.g.langs.lua, nixCats("lua")) and { "stylua" } or {},
      nix = lazyAdd(vim.g.langs.nix, nixCats("nix")) and { "nixfmt" } or {},
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = { timeout_ms = 500 },
  },
}

return M
