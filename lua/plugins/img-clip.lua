local lazyAdd = require("nixCatsUtils").lazyAdd

local keys = {
  {
    "<leader>p",
    function()
      local clipboard = require("img-clip.clipboard")
      local paste = require("img-clip.paste")
      local util = require("img-clip.util")

      if not clipboard.get_clip_cmd() then
        util.error("Could not get clipboard command. See :checkhealth img-clip")
        return
      end

      if clipboard.content_is_image() then
        paste.paste_image_from_clipboard()
        return
      end

      local clipboard_content = clipboard.get_content()
      if clipboard_content then
        local input = util.sanitize_input(clipboard_content)

        if util.is_image_url(input) then
          paste.paste_image_from_url(input)
          return
        elseif util.is_image_path(input) then
          paste.paste_image_from_path(input)
          return
        end
      end

      -- If clipboard content is not an image, fallback to just directly pasting
      vim.api.nvim_feedkeys('"+p', "n", true)
    end,
    desc = "Paste (image) from clipboard",
  },
}

if lazyAdd(vim.g.plugins.snacks, nixCats("snacks")) and lazyAdd(true, nixCats("picker")) then
  table.insert(keys, {
    "<leader>fi",
    function()
      Snacks.picker.files({
        ft = { "jpg", "jpeg", "png", "webp" },
        confirm = function(self, item, _)
          self:close()
          require("img-clip").paste_image({}, "./" .. item.file) -- ./ is necessary for img-clip to recognize it as path
        end,
      })
    end,
    desc = "[f]ind [i]mages",
  })
end

local M = {
  "HakonHarnes/img-clip.nvim",
  enabled = lazyAdd(vim.g.feat["image-paste"], nixCats("image-paste")),
  event = "VeryLazy",
  keys = keys,
  opts = {
    default = {
      dir_path = "images",
    },
  },
}

return M
