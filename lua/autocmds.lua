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
  callback = function() vim.hl.on_yank() end,
  desc = "Highlight yank",
})

-- https://www.reddit.com/r/neovim/comments/1ct2w2h/lua_adaptation_of_vimcool_auto_nohlsearch/
local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc) fnc(vim.api.nvim_create_augroup(name, { clear = true })) end

augroup("ibhagwan/ToggleSearchHL", function(g)
  aucmd("InsertEnter", {
    group = g,
    callback = function()
      vim.schedule(function() vim.cmd("nohlsearch") end)
    end,
  })
  aucmd("CursorMoved", {
    group = g,
    callback = function()
      -- No bloat lua adpatation of: https://github.com/romainl/vim-cool
      local view, rpos = vim.fn.winsaveview(), vim.fn.getpos(".")
      -- Move the cursor to a position where (whereas in active search) pressing `n`
      -- brings us to the original cursor position, in a forward search / that means
      -- one column before the match, in a backward search ? we move one col forward
      vim.cmd(
        string.format(
          "silent! keepjumps go%s",
          (vim.fn.line2byte(view.lnum) + view.col + 1 - (vim.v.searchforward == 1 and 2 or 0))
        )
      )
      -- Attempt to goto next match, if we're in an active search cursor position
      -- should be equal to original cursor position
      local ok, _ = pcall(vim.cmd, "silent! keepjumps norm! n")
      local insearch = ok
        and (function()
          local npos = vim.fn.getpos(".")
          return npos[2] == rpos[2] and npos[3] == rpos[3]
        end)()
      -- restore original view and position
      vim.fn.winrestview(view)
      if not insearch then vim.schedule(function() vim.cmd("nohlsearch") end) end
    end,
  })
end)
