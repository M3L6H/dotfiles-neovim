local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "mawkler/demicolon.nvim",
  enabled = lazyAdd(vim.g.plugins.demicolon, nixCats("demicolon")),
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  event = "BufReadPost",
  opts = {
    keymaps = {
      -- Keep neovim's original behavior for ; and ,
      repeat_motions = "stateful",
      disabled_keys = { "p", "I", "A", "i" },
    },
  },
}

return M
