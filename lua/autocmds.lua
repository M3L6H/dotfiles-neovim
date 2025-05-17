local buf_enter = vim.api.nvim_create_augroup("MyBufEnter", { clear = true })
local file_type = vim.api.nvim_create_augroup("MyFileType", { clear = true })

-- Fix comment indentation in nix files
vim.api.nvim_create_autocmd("BufEnter", {
  group = buf_enter,
  pattern = "*.nix",
  callback = function() vim.opt.cinkeys = "0{,0},0),0],:,!^F,o,O,e" end,
  desc = "Remove # from cinkeys for nix files",
})

-- Open help in a vertical split
vim.api.nvim_create_autocmd("FileType", {
  group = file_type,
  pattern = "help",
  command = "wincmd L",
  desc = "Open help in a vertical split",
})

-- Highlight text after yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
  desc = "Highlight yank",
})
