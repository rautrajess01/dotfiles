return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				section_separators = "",
				component_separators = "",
				globalstatus = true,
				icons_enabled = true,
			},
		})
	end,
}
