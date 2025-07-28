local lazyAdd = require("nixCatsUtils").lazyAdd

local image = vim.g.dashboard.image
local size = vim.g.dashboard.size
local dims = {}
for dim in string.gmatch(size, "%d+") do
  table.insert(dims, dim)
end

---@class (exact) MyBlock
---@field min integer
---@field max integer

---@class (exact) MyDesc
---@field enabled boolean
---@field height integer

---@param height integer Height we have to work with
---@param blocks MyBlock[] Array of blocks that we need to fit
---@return MyDesc[]
local function get_heights(height, blocks)
  local res = {}
  local sum = 0

  for _, block in ipairs(blocks) do
    if sum + block.min <= height then
      sum = sum + block.min
      table.insert(res, { enabled = true, height = block.min })
    else
      table.insert(res, { enabled = false, height = 0 })
    end
  end

  for i, block in ipairs(blocks) do
    if res[i].enabled and sum < height then
      local diff = math.min(height - sum, block.max - block.min)
      res[i].height = res[i].height + diff
      sum = sum + diff
    end
  end

  return res
end

local max_height = 40
local base_height = 2
local height = math.min(max_height, tonumber(dims[2]))
local heights = get_heights(height - max_height + 30, {
  { min = base_height + 3, max = base_height + 8 },
  { min = base_height + 3, max = base_height + 6 },
  { min = base_height + 5, max = base_height + 10 },
})

local recents = heights[1]
local git = heights[2]
local gh = heights[3]

local M = {
  "folke/snacks.nvim",
  enabled = lazyAdd(vim.g.plugins.snacks, nixCats("snacks")),
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
    -- Find
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "[f]ind [c]ommands" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "[f]ind [f]iles" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "[f]ind [d]iagnostics" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "[f]ind [h]elp" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "[f]ind [k]eymaps" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "[f]ind [m]arks" },
    { "<leader>fn", function() Snacks.picker.notifications() end, desc = "[f]ind [n]otifications" },
    { "<leader>fr", function() Snacks.picker.resume() end, desc = "[f]ind [r]esume" },
    { "<leader>fs", function() Snacks.picker.grep() end, desc = "[f]ind [s]earch (ripgrep)" },
    -- Code
    { "<leader>rf", function() Snacks.rename.rename_file() end, desc = "[r]ename [f]ile" },
    -- Goto
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "[g]oto [d]efinition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "[g]oto [D]eclaration" },
    {
      "gu",
      function() Snacks.picker.lsp_references() end,
      nowait = true,
      desc = "[g]oto [u]sages",
    },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "[g]oto [i]mplementation" },
    {
      "gy",
      function() Snacks.picker.lsp_type_definitions() end,
      desc = "[g]oto t[y]pe definition",
    },
    -- Jump
    {
      "]]",
      function() Snacks.words.jump(vim.v.count1) end,
      desc = "Jump to next reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function() Snacks.words.jump(-vim.v.count1) end,
      desc = "Jump to previous reference",
      mode = { "n", "t" },
    },
  },
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = lazyAdd(true, nixCats("dashboard")),
      sections = {
        {
          section = "terminal",
          cmd = "chafa "
            .. image
            .. " --format symbols --symbols vhalf --size "
            .. size
            .. " --stretch --align center; sleep .1",
          height = height,
          padding = 1,
        },
        {
          pane = 2,
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            enabled = recents.enabled,
            indent = 2,
            padding = 1,
            limit = recents.height - base_height,
          },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function() return git.enabled and Snacks.git.get_root() ~= nil end,
            cmd = "git status --short --branch --renames",
            height = git.height - base_height,
            padding = 1,
            ttl = 5 * 60,
            indent = 2,
          },
          {
            icon = " ",
            title = "Open Issues",
            section = "terminal",
            enabled = function() return gh.enabled and Snacks.git.get_root() ~= nil end,
            cmd = "gh issue list -L "
              .. gh.height
              .. ' | awk -F\'\\t\' \'{ print "\\033[32m"$1"\\t\\033[36m"$4"\\t\\033[0m"$3; }\'',
            key = "i",
            action = function() vim.fn.jobstart("gh issue list --web", { detach = true }) end,
            height = gh.height - base_height,
            padding = 1,
            ttl = 5 * 60,
            indent = 2,
          },
          { section = "startup" },
        },
      },
    },
    image = { enabled = lazyAdd(vim.g.feat.image, nixCats("image")) },
    indent = {
      enabled = true,
      indent = {
        only_scope = true,
        only_current = true,
      },
      scope = {
        only_current = true,
      },
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      level = vim.log.levels.INFO,
    },
    picker = {
      enabled = lazyAdd(true, nixCats("picker")),
      matcher = {
        frecency = true,
      },
      db = {
        sqlite3_path = lazyAdd(nil, nixCats.extra("nixdExtras.sqlite3_path")),
      },
      actions = nixCats("trouble") and require("trouble.sources.snacks").actions,
      win = {
        input = {
          keys = {
            ["<C-t>"] = nixCats("trouble") and {
              "trouble_open",
              mode = { "n", "i" },
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = {
      enabled = true,
      right = { "git", "fold" },
    },
    words = { enabled = true },
  },
  init = function()
    -- Neovim news reminder
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("NeovimNews", { clear = true }),
      pattern = "*",
      callback = function()
        local vinfo = vim.fs.abspath("~/.local/state/nvim/version-info")

        local function read_vinfo()
          local file = assert(io.open(vinfo, "r"))
          local content = file:read("*a")
          file:close()
          return content
        end

        local currv = vim.version()
        currv = currv.major .. "." .. currv.minor .. "." .. currv.patch

        local function write_vinfo()
          local file = assert(io.open(vinfo, "w"))
          file:write(currv)
          file:close()
        end

        -- Check if neovim has been updated
        if not vim.uv.fs_stat(vinfo) or read_vinfo() ~= currv then
          Snacks.notify.info("Neovim has updated. Run <leader>N to view the news")
          vim.keymap.set("n", "<leader>N", function()
            vim.cmd("h news-features")
            vim.keymap.del("n", "<leader>N")
          end, { desc = "View the Neovim news" })
          write_vinfo()
        end
      end,
      desc = "Neovim News",
    })
  end,
}

return M
