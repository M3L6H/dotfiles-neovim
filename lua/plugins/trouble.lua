local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "folke/trouble.nvim",
  enabled = lazyAdd(vim.g.plugins.trouble, nixCats("trouble")),
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>dt",
      "<CMD>Trouble diagnostics toggle<CR>",
      desc = "[D]iagnostic [t]rouble",
    },
    {
      "<leader>ds",
      "<CMD>Trouble symbols toggle focus=false<CR>",
      desc = "[D]iagnostic [s]ymbol toggle",
    },
    {
      "<leader>dq",
      "<CMD>Trouble qflist toggle<CR>",
      desc = "[D]iagnostic [q]uickfix",
    },
  },
  ---@class trouble.Config
  opts = {
    focus = true,
    ---@type trouble.Window.opts
    win = {
      position = "right",
      size = {
        width = 80,
      },
    },
    keys = {
      j = "next",
      k = "prev",
    },
  },
}

return M
