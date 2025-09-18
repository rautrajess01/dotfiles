-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= -3 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(-2)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set mapleader before plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup plugins
-- Setup plugins
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = { colorscheme = { "catppuccin" } },
	checker = { enabled = true },
})
require("vim-options")
require("nvim-web-devicons").setup()
vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
-- Go to Neo-tree (assuming it's always on the left)
vim.keymap.set("n", "<leader>e", "<C-w>h", { desc = "Focus Neo-tree" })

-- Go back to editor (assuming Neo-tree is on the left)
vim.keymap.set("n", "<leader>;", "<C-w>l", { desc = "Focus Editor" })
vim.cmd([[
  autocmd FocusLost,BufLeave * silent! wall
]])

-- Indent selection in Visual mode using Tab / Shift-Tab
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })
