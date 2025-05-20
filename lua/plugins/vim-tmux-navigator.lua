local lazyAdd = require("nixCatsUtils").lazyAdd

local M = {
  "christoomey/vim-tmux-navigator",
  enabled = lazyAdd(vim.g.plugins["vim-tmux-navigator"], nixCats("vim-tmux-navigator")),
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateRight",
    "TmuxNavigateUp",
    "TmuxNavigateDown",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
  },
}

return M
