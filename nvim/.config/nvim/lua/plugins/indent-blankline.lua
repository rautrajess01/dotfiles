return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  -- Use the `opts` table to configure the plugin
  opts = {
    -- This section is for the simple indent lines
    indent = {
      char = "│", -- You can change this character
      tab_char = "│",
    },
    -- THIS IS THE IMPORTANT PART: Disable the "box"
    scope = {
      enabled = false,
    },
  },
}