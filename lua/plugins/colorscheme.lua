local themes = {
	day = {
		colorscheme = "tokyonight-day",
		background = "light",
	},
	moon = {
		colorscheme = "tokyonight-moon",
		background = "dark",
	},
}

local current_theme = "day"

-- 先注释掉随系统切换，暂时禁用
-- local function get_system_theme()
-- 	if vim.fn.has("mac") ~= 1 then
-- 		return current_theme
-- 	end
--
-- 	local result = vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }):wait()
-- 	return result.code == 0 and "moon" or "day"
-- end

local function set_theme(name)
	local theme = themes[name]
	if not theme then
		vim.notify(("Unknown theme: %s"):format(name), vim.log.levels.ERROR)
		return
	end

	if current_theme == name and vim.g.colors_name == theme.colorscheme then
		return
	end

	current_theme = name
	vim.o.background = theme.background
	vim.cmd.colorscheme(theme.colorscheme)
end

-- local function set_system_theme()
-- 	set_theme(get_system_theme())
-- end

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
	},
	config = function(_, opts)
		-- 主题只在这里初始化，避免 Neovide 或其他入口重复 setup。
		require("tokyonight").setup(opts)
		vim.api.nvim_create_user_command("ThemeDay", function()
			set_theme("day")
		end, {})
		vim.api.nvim_create_user_command("ThemeMoon", function()
			set_theme("moon")
		end, {})
		vim.api.nvim_create_user_command("ThemeToggle", function()
			set_theme(current_theme == "day" and "moon" or "day")
		end, {})
		-- vim.api.nvim_create_user_command("ThemeSystem", set_system_theme, {})
		-- vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
		-- 	group = vim.api.nvim_create_augroup("SystemTheme", { clear = true }),
		-- 	callback = set_system_theme,
		-- })
		-- set_system_theme()
		set_theme(current_theme)
	end,
}
