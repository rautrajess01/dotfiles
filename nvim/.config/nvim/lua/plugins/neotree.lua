return {
 "nvim-neo-tree/neo-tree.nvim",
 branch = "v2.x",
 dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",
 },
 config = function()
  require("neo-tree").setup({
   enable_git_status = false,
   window = {
    width = 25, -- 👈 Set to your preferred width (default is 40)
   },
  })
  vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
 end,
}
