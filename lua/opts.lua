local o = vim.opt

-- Line numbers
o.nu = true
o.rnu = true

-- Tabs
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2
o.smartindent = false -- Causes issues with comments in nix
o.cindent = true
o.breakindent = true

-- Enable mouse mode
o.mouse = "a"

-- No wrapping
o.wrap = false

o.swapfile = false
o.backup = false
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true

o.incsearch = true
-- Case-insensitive searching unless one or more capital letters are included in the search term
o.ignorecase = true
o.smartcase = true

-- Open new splits to the right/bottom
o.splitright = true
o.splitbelow = true

-- Display particular whitespace characters
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions
o.inccommand = "split"

-- Highlight line under cursor
o.cursorline = true

-- Mode show in statusline
o.showmode = false

o.termguicolors = true

o.cmdheight = 0

o.scrolloff = 16
o.signcolumn = "yes"
o.isfname:append("@-@")

o.updatetime = 50

-- Border
vim.g.border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }

-- Terminal window
vim.g.terminalwindow = "2"

-- Dashboard
vim.g.dashboard = {
  image = "/home/m3l6h/files/images/neovim/dashboard.jpg",
  size = "60x32",
}

-- Plugin enablement opts
vim.g.plugins = {}
vim.g.plugins.autopairs = true
vim.g.plugins["blink-cmp"] = true
vim.g.plugins.conform = true
vim.g.plugins.colorizer = true
vim.g.plugins.demicolon = true
vim.g.plugins.fastaction = true
vim.g.plugins.flash = true
vim.g.plugins["guess-indent"] = true
vim.g.plugins.lazydev = true
vim.g.plugins.lspconfig = true
vim.g.plugins["mini-diff"] = true
vim.g.plugins["mini-statusline"] = true
vim.g.plugins["mini-surround"] = false
vim.g.plugins.minty = true
vim.g.plugins.noice = true
vim.g.plugins.oil = true
vim.g.plugins.smartcolumn = true
vim.g.plugins["smear-cursor"] = true
vim.g.plugins.snacks = true
vim.g.plugins.surround = true
vim.g.plugins.treesitter = true
vim.g.plugins.trouble = true
vim.g.plugins.undotree = true
vim.g.plugins["vim-tmux-navigator"] = true
vim.g.plugins["which-key"] = true

-- Language enablement opts
vim.g.langs = {}
vim.g.langs.css = true
vim.g.langs.lua = true
vim.g.langs.nix = false
vim.g.langs.yuck = false
