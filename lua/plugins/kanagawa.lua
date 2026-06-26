local M = {
  "rebelot/kanagawa.nvim",
  lazy = false,
  enabled = vim.g.colorscheme == "kanagawa",
  priority = 1000,
  opts = {
    compile = true,
    transparent = true,
    dimInactive = true,
    colors = {
      palette = {
        -- Swap green and yellow
        springGreen = "#E6C384",
        carpYellow = "#98BB6C",
      },
      theme = {
        all = {
          ui = {
            bg_dim = "#12120f", -- Dragon black 1
            bg_gutter = "none",
          },
        },
      },
    },
    overrides = function()
      return {
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },
        NormalFloat = { bg = "none" },
      }
    end,
  },
  init = function()
    vim.cmd("colorscheme kanagawa-wave")
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  end,
}

return M
