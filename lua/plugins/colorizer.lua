local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "catgoose/nvim-colorizer.lua",
  enabled = lazyAdd(vim.g.plugins.colorizer, nixCats("colorizer")),
  event = "BufReadPost",
  opts = {
    lazy_load = true,
    user_default_options = {
      RRGGBBAA = true,
      css = true,
      css_fn = true,
      mode = "virtualtext",
      virtualtext = "",
      virtualtext_inline = "before",
      always_update = true,
    },
  },
}

return M
