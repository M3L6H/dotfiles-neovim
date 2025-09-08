local lazyAdd = require("nixCatsUtils").lazyAdd

local config_dir = vim.fn.expand("$HOME/.config/nvim")
local mdsf_file = config_dir .. "/mdsf.json"

---Make a key with an array of values (specifically for mdsf)
---@param key string Key for the karr
---@param ... string Values for the array
local function mk_karr(key, ...)
  local values = { ... }
  local value = ""

  for i, v in ipairs(values) do
    value = value .. string.format('"%s"%s', v, i < #values and ", " or "")
  end

  return string.format('"%s": [ %s ]', key, value)
end

local function mdsf(bufner)
  if vim.fn.filereadable(mdsf_file) ~= 1 then
    vim.fn.mkdir(config_dir, "p") -- Make config dir

    -- Create JSON config file
    local json = { "{" }
    table.insert(json, '"languages": {')

    local languages = {}

    if lazyAdd(vim.g.langs.nix, nixCats("lua")) then
      table.insert(languages, mk_karr("lua", "stylua"))
    end

    if lazyAdd(vim.g.langs.nix, nixCats("nix")) then
      table.insert(languages, mk_karr("nix", "nixfmt"))
    end

    if lazyAdd(vim.g.langs.shell, nixCats("shell")) then
      table.insert(languages, mk_karr("sh", "shfmt"))
    end

    if lazyAdd(vim.g.langs.web, nixCats("web")) then
      table.insert(languages, mk_karr("css", "prettierd", "stylelint"))
      table.insert(languages, mk_karr("html", "prettierd"))
      table.insert(languages, mk_karr("javascript", "prettierd"))
      table.insert(languages, mk_karr("javascriptreact", "prettierd"))
      table.insert(languages, mk_karr("typescript", "prettierd"))
      table.insert(languages, mk_karr("typescriptreact", "prettierd"))
    end

    for i, lang in ipairs(languages) do
      table.insert(json, string.format("%s%s", lang, i < #languages and "," or ""))
    end

    table.insert(json, "}")
    table.insert(json, "}")

    vim.fn.writefile(json, mdsf_file)
  end

  return {
    command = "mdsf",
    append_args = { "--config", mdsf_file },
  }
end

local M = {
  "stevearc/conform.nvim",
  enabled = lazyAdd(vim.g.plugins.conform, nixCats("conform")),
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format() end, desc = "Code format" },
  },
  -- @type conform.setupOpts
  opts = {
    notify_no_formatters = true,
    formatters = {
      doctoc = {
        prepend_args = { "--title", "**Table of Contents**" },
      },
      mdsf = mdsf,
      mdformat = {
        prepend_args = { "--no-codeformatters" },
      },
    },
    -- @type conform.FiletypeFormatter
    formatters_by_ft = {
      css = lazyAdd(vim.g.langs.web, nixCats("web")) and { "prettierd", "stylelint" },
      gd = lazyAdd(vim.g.langs.godot, nixCats("godot")) and { "gdformat" },
      gdscript = lazyAdd(vim.g.langs.godot, nixCats("godot")) and { "gdformat" },
      html = lazyAdd(vim.g.langs.web, nixCats("web")) and { "prettierd" },
      javascript = lazyAdd(vim.g.langs.web, nixCats("web")) and { "prettierd" },
      javascriptreact = lazyAdd(vim.g.langs.web, nixCats("web")) and { "prettierd" },
      lua = lazyAdd(vim.g.langs.lua, nixCats("lua")) and { "stylua" },
      markdown = lazyAdd(vim.g.langs.markdown, nixCats("markdown"))
        and { "mdsf", "mdformat", "doctoc" },
      nix = lazyAdd(vim.g.langs.nix, nixCats("nix")) and { "nixfmt" },
      rust = lazyAdd(vim.g.langs.rust, nixCats("rust")) and { "rustfmt" },
      sh = lazyAdd(vim.g.langs.shell, nixCats("shell")) and { "shfmt" },
      typescript = lazyAdd(vim.g.langs.web, nixCats("web")) and { "prettierd" },
      typescriptreact = lazyAdd(vim.g.langs.web, nixCats("web")) and { "prettierd" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = { timeout_ms = 500 },
  },
}

return M
