local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "kylechui/nvim-surround",
  enabled = lazyAdd(vim.g.plugins.surround, nixCats("surround")),
  keys = {
    -- yeet makes no sense in this context, but it helps me remember the keymap
    { "ys", desc = "[y]eet [s]urround" },
    { "yss", desc = "[y]eet [s]urround[s]" },
    { "yS", desc = "[y]eet [S]urround line" },
    { "ySS", desc = "[y]eet [S]urround[S] line" },
    { "S", mode = "v", desc = "Visual [S]urround" },
    { "gS", mode = "v", desc = "[g]o [S]urround line" },
    { "ds", desc = "[d]elete [s]urround" },
    { "cs", desc = "[c]hange [s]urround" },
    { "cS", desc = "[c]hange [S]urround line" },
  },
  opts = {
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
