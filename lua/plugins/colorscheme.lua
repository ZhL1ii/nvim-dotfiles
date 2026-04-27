return {
	"folke/tokyonight.nvim",
	opts = {
		style = "moon",
	},
	config = function(_, opts)
		-- 主题只在这里初始化，避免 Neovide 或其他入口重复 setup。
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight")
	end,
}
