return {
 "akinsho/bufferline.nvim",
 dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for file icons
 version = "*",
 event = "VeryLazy",
 config = function()
  require("bufferline").setup({
   options = {
    mode = "buffers", -- set to "tabs" if you want tabs
    separator_style = "slant",
    -- If you have neo-tree, this will create a nice offset
    offsets = {
     {
      filetype = "neo-tree",
      text = "File Explorer",
      text_align = "left",
      separator = true,
     },
    },
   },
  })
  -- Simple keymaps to switch buffers
  vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
 end,
}
