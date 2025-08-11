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

    if lazyAdd(vim.g.langs.css, nixCats("css")) then
      table.insert(languages, mk_karr("css", "stylelint", "js-beautify"))
    end

    if lazyAdd(vim.g.langs.nix, nixCats("lua")) then
      table.insert(languages, mk_karr("lua", "stylua"))
    end

    if lazyAdd(vim.g.langs.nix, nixCats("nix")) then
      table.insert(languages, mk_karr("nix", "nixfmt"))
    end

    if lazyAdd(vim.g.langs.shell, nixCats("shell")) then
      table.insert(languages, mk_karr("sh", "shfmt"))
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
      css_beautify = {
        command = "js-beautify",
        args = { "--css" },
      },
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
      css = lazyAdd(vim.g.langs.css, nixCats("css")) and { "stylelint", "css_beautify" } or {},
      lua = lazyAdd(vim.g.langs.lua, nixCats("lua")) and { "stylua" } or {},
      markdown = lazyAdd(vim.g.langs.markdown, nixCats("markdown"))
          and { "mdsf", "mdformat", "doctoc" }
        or {},
      nix = lazyAdd(vim.g.langs.nix, nixCats("nix")) and { "nixfmt" } or {},
      rust = lazyAdd(vim.g.langs.rust, nixCats("rust")) and { "rustfmt" } or {},
      sh = lazyAdd(vim.g.langs.shell, nixCats("shell")) and { "shfmt" } or {},
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = { timeout_ms = 500 },
  },
}

return M
