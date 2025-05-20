local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "nvim-treesitter/nvim-treesitter",
  enabled = lazyAdd(vim.g.plugins.treesitter, nixCats("treesitter")),
  build = lazyAdd(":TSUpdate"),
  event = "BufEnter",
  opts = {
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    autopairs = { enable = true },
    ensure_installed = lazyAdd({
      "bash",
      "c",
      "cpp",
      "css",
      "go",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "ruby",
      "rust",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "yuck",
    }, false),
    auto_install = lazyAdd(true, false),
    sync_install = false,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "+",
        node_incremental = "+",
        scope_incremental = false,
        node_decremental = "_",
      },
    },
  },
  config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
}

return M
