-- lua/plugins/comment.lua
return {
  "numToStr/Comment.nvim",
  opts = {
    -- Optional: Add any custom options here if you want.
    -- For example, to change the comment string for specific filetypes:
    -- ft = {
    --   markdown = "",
    -- },
  },
  lazy = false, -- Load on startup as it's a frequently used feature
}
