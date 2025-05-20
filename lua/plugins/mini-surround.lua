local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "echasnovski/mini.surround",
  enabled = lazyAdd(vim.g.plugins["mini-surround"], nixCats("mini-surround")),
  lazy = false,
  keys = {
    { "Sa", mode = { "n", "v" }, desc = "Surround add" },
    { "Sd", desc = "Surround delete" },
    { "Sf", desc = "Surround find" },
    { "SF", desc = "Surround find back" },
    { "Sr", desc = "Surround replace" },
  },
  opts = {
    custom_surroundings = {
      ["("] = { output = { left = "(", right = ")" } },
      [")"] = { output = { left = "( ", right = " )" } },
      ["["] = { output = { left = "[", right = "]" } },
      ["]"] = { output = { left = "[ ", right = " ]" } },
      ["{"] = { output = { left = "{", right = "}" } },
      ["}"] = { output = { left = "{ ", right = " }" } },
    },
    mappings = {
      add = "Sa", -- Add surrounding in Normal and Visual modes
      delete = "Sd", -- Delete surrounding
      find = "Sf", -- Find surrounding (to the right)
      find_left = "SF", -- Find surrounding (to the left)
      highlight = "", -- Highlight surrounding
      replace = "Sr", -- Replace surrounding
      update_n_lines = "", -- Update `n_lines`

      suffix_last = "N", -- Suffix to search with "prev" method
      suffix_next = "n", -- Suffix to search with "next" method
    },
    silent = true,
  },
}

return M
