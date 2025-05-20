local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "folke/noice.nvim",
  enabled = lazyAdd(vim.g.plugins.noice, nixCats("noice")),
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  event = "CmdlineEnter",
  opts = {
    messages = {
      enabled = false,
    },
    notify = {
      enabled = false,
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
    },
  },
}

return M
