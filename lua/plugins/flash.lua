local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "folke/flash.nvim",
  enabled = lazyAdd(vim.g.plugins.flash, nixCats("flash")),
  keys = {
    {
      "<CR>",
      mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash",
    },
    {
      "<S-CR>",
      mode = { "n", "x", "o" },
      function() require("flash").treesitter() end,
      desc = "Flash treesitter",
    },
    {
      "<C-CR>",
      mode = { "c" },
      function() require("flash").toggle() end,
      desc = "Toggle Flash Search",
    },
    {
      "r",
      mode = { "o" },
      function() require("flash").remote() end,
      desc = "Remote Flash",
    },
  },
  ---@type Flash.Config
  ---@diagnostic disable-next-line missing-fields
  opts = {
    jump = {
      nohlsearch = true,
      autojump = true,
    },
    label = {
      rainbow = {
        enabled = false,
      },
    },
    modes = {
      char = {
        enabled = false,
      },
    },
  },
}

return M
