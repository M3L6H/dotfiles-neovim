local lazyAdd = require("nixCatsUtils").lazyAdd

local has_diff = lazyAdd(vim.g.plugins["mini-diff"], nixCats("mini-diff"))

local dependencies = {}

if has_diff then table.insert(dependencies, { "echasnovski/mini.diff" }) end

local M = {
  "echasnovski/mini.statusline",
  enabled = lazyAdd(vim.g.plugins["mini-statusline"], nixCats("mini-statusline")),
  lazy = false,
  dependencies = dependencies,
  opts = {
    content = {
      active = function()
        local MiniStatusline = require("mini.statusline")

        -- Groups
        local mode_groups = {}
        local dev_groups = {}
        local filename_groups = {}
        local fileinfo_groups = {}
        local location_groups = {}

        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 999 }) -- Always truncate
        if mode then table.insert(mode_groups, mode) end

        local git = MiniStatusline.section_git({ trunc_width = 40 })
        if git then table.insert(dev_groups, git) end

        local diff = has_diff and MiniStatusline.section_diff({ trunc_width = 75 })
        if diff then table.insert(dev_groups, diff) end

        local diagnostics = MiniStatusline.section_diagnostics({
          trunc_width = 75,
          signs = {
            ERROR = "",
            WARN = "",
            INFO = "",
            HINT = "",
          },
        })
        if diagnostics then table.insert(dev_groups, diagnostics) end

        local lsp = MiniStatusline.section_lsp({
          trunc_width = 75,
          icon = "",
        })
        if lsp then table.insert(dev_groups, lsp) end

        local filename = MiniStatusline.section_filename({ trunc_width = 999 }) -- Always truncate
        if filename then table.insert(filename_groups, filename) end

        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 75 })
        if fileinfo then table.insert(fileinfo_groups, fileinfo) end

        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
        if search then table.insert(location_groups, search) end

        local location = MiniStatusline.section_location({ trunc_width = 75 })
        if location then table.insert(location_groups, location) end

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = mode_groups },
          { hl = "MiniStatuslineDevinfo", strings = dev_groups },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = filename_groups },
          "%=", -- End left alignment
          { hl = "MiniStatuslineFileinfo", strings = fileinfo_groups },
          { hl = mode_hl, strings = { search, location } },
        })
      end,
    },
  },
  init = function()
    vim.cmd("hi clear MiniStatuslineFilename") -- Transparent statusline
  end,
}

return M
