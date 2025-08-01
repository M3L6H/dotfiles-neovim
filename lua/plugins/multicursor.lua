local lazyAdd = require("nixCatsUtils").lazyAdd

local enabled = lazyAdd(vim.g.plugins.multicursor, nixCats("multicursor"))

local M = {
  "jake-stewart/multicursor.nvim",
  enabled = enabled,
  keys = {
    {
      "<up>",
      function() require("multicursor-nvim").lineAddCursor(-1) end,
      mode = { "n", "x" },
      desc = "Add cursor above",
    },
    {
      "<down>",
      function() require("multicursor-nvim").lineAddCursor(1) end,
      mode = { "n", "x" },
      desc = "Add cursor below",
    },
    {
      "<leader>v",
      function() require("multicursor-nvim").matchAddCursor(1) end,
      mode = { "n", "x" },
      desc = "Add cursor at next match",
    },
    {
      "<leader>V",
      function() require("multicursor-nvim").matchAddCursor(-1) end,
      mode = { "n", "x" },
      desc = "Add cursor at previous match",
    },
    {
      "<C-leftmouse>",
      enabled and require("multicursor-nvim").handleMouse,
      mode = { "n", "x" },
      desc = "Add cursor with click",
    },
    {
      "<C-leftdrag>",
      enabled and require("multicursor-nvim").handleMouseDrag,
      mode = { "n", "x" },
      desc = "Add cursors with drag",
    },
    {
      "<C-leftrelease>",
      enabled and require("multicursor-nvim").handleMouseRelease,
      mode = { "n", "x" },
      desc = "Stop adding cursors with drag",
    },
    {
      "<C-q>",
      enabled and require("multicursor-nvim").toggleCursor,
      mode = { "n", "x" },
      desc = "Toggle cursor disabled/enabled",
    },
  },
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    mc.addKeymapLayer(function(layerSet)
      layerSet({ "n", "x" }, "<left>", mc.prevCursor)
      layerSet({ "n", "x" }, "<right>", mc.nextCursor)

      layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)

    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}

return M
