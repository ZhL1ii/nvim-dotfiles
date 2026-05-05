return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = not vim.g.neovide,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
			terminal_colors = true,
		},
		style = "day",
	},
	config = function(_, opts)
		-- 主题只在这里初始化，避免 Neovide 或其他入口重复 setup。
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight")
	end,
}
