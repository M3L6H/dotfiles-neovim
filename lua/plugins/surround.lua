local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "kylechui/nvim-surround",
  enabled = lazyAdd(vim.g.plugins.surround, nixCats("surround")),
  keys = {
    { "Sa", desc = "[S]urround [a]dd" },
    { "Sl", desc = "[S]urround [l]ord" },
    { "Sd", desc = "[S]urround [d]elete" },
    { "Sr", desc = "[S]urround [r]eplace" },
    { "S", mode = "v", desc = "[S]urround" },
  },
  opts = {
    keymaps = {
      normal = "Sa",
      normal_cur = "Sw",
      visual = "S",
      delete = "Sd",
      change = "Sr",
    },
    surrounds = {
      [")"] = {
        add = { "( ", " )" },
        find = function() return require("nvim-surround").get_selection({ motion = "a(" }) end,
        delete = "^(. ?)().-( ?.)()$",
      },
      ["("] = {
        add = { "(", ")" },
        find = function() return require("nvim-surround").get_selection({ motion = "a)" }) end,
        delete = "^(.)().-(.)()$",
      },
      ["}"] = {
        add = { "{ ", " }" },
        find = function() return require("nvim-surround").get_selection({ motion = "a{" }) end,
        delete = "^(. ?)().-( ?.)()$",
      },
      ["{"] = {
        add = { "{", "}" },
        find = function() return require("nvim-surround").get_selection({ motion = "a}" }) end,
        delete = "^(.)().-(.)()$",
      },
      [">"] = {
        add = { "< ", " >" },
        find = function() return require("nvim-surround").get_selection({ motion = "a<" }) end,
        delete = "^(. ?)().-( ?.)()$",
      },
      ["<"] = {
        add = { "<", ">" },
        find = function() return require("nvim-surround").get_selection({ motion = "a>" }) end,
        delete = "^(.)().-(.)()$",
      },
      ["]"] = {
        add = { "[ ", " ]" },
        find = function() return require("nvim-surround").get_selection({ motion = "a[" }) end,
        delete = "^(. ?)().-( ?.)()$",
      },
      ["["] = {
        add = { "[", "]" },
        find = function() return require("nvim-surround").get_selection({ motion = "a]" }) end,
        delete = "^(.)().-(.)()$",
      },
    },
  },
}

return M
