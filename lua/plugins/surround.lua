local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "kylechui/nvim-surround",
  enabled = lazyAdd(vim.g.plugins.surround, nixCats("surround")),
  event = "VeryLazy",
  keys = {
    { "<C-y>s", mode = "i", "<Plug>nvim-surround-insert", desc = "[y]ou [s]urround" },
    { "<C-y>S", mode = "i", "<Plug>nvim-surround-insert-line", desc = "[y]ou [S]urround line" },
    { "ys", "<Plug>nvim-surround-normal", desc = "[y]ou [s]urround" },
    { "yss", "<Plug>nvim-surround-normal-cur", desc = "[y]ou [s]urround [s]elf" },
    { "yS", "<Plug>nvim-surround-normal-line", desc = "[y]ou [S]urround new line" },
    { "ySS", "<Plug>nvim-surround-normal-cur-line", desc = "[y]ou [S]urround [S]elf new line" },
    { "S", mode = "v", "<Plug>nvim-surround-visual", desc = "Visual [S]urround" },
    { "gS", mode = "v", "<Plug>nvim-surround-visual-line", desc = "Visual [g]o [S]urround line" },
    { "ds", "<Plug>nvim-surround-delete", desc = "[d]elete [s]urround" },
    { "cs", "<Plug>nvim-surround-change", desc = "[c]hange [s]urround" },
    { "cS", "<Plug>nvim-surround-change-line", desc = "[c]hange [S]urround line" },
  },
  opts = {
    keymaps = {}, -- Disable default keymaps
    surrounds = {
      [")"] = {
        add = { "( ", " )" },
        find = function() return require("nvim-surround.config").get_selection({ motion = "a(" }) end,
        delete = "^(. ?)().-( ?.)()$",
      },
      ["("] = {
        add = { "(", ")" },
        find = function() return require("nvim-surround.config").get_selection({ motion = "a)" }) end,
        delete = "^(.)().-(.)()$",
      },
      ["}"] = {
        add = { "{ ", " }" },
        find = function() return require("nvim-surround.config").get_selection({ motion = "a{" }) end,
        delete = "^(. ?)().-( ?.)()$",
      },
      ["{"] = {
        add = { "{", "}" },
        find = function() return require("nvim-surround.config").get_selection({ motion = "a}" }) end,
        delete = "^(.)().-(.)()$",
      },
      [">"] = {
        add = { "< ", " >" },
        find = function() return require("nvim-surround.config").get_selection({ motion = "a<" }) end,
        delete = "^(. ?)().-( ?.)()$",
      },
      ["<"] = {
        add = { "<", ">" },
        find = function() return require("nvim-surround.config").get_selection({ motion = "a>" }) end,
        delete = "^(.)().-(.)()$",
      },
      ["]"] = {
        add = { "[ ", " ]" },
        find = function() return require("nvim-surround.config").get_selection({ motion = "a[" }) end,
        delete = "^(. ?)().-( ?.)()$",
      },
      ["["] = {
        add = { "[", "]" },
        find = function() return require("nvim-surround.config").get_selection({ motion = "a]" }) end,
        delete = "^(.)().-(.)()$",
      },
    },
  },
}

return M
