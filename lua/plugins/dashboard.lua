_G.nvim_dashboard_find_file = function()
	vim.ui.input({ prompt = "Find file: ", completion = "file" }, function(input)
		if not input or input == "" then
			return
		end

		vim.cmd("edit " .. vim.fn.fnameescape(input))
	end)
end

_G.nvim_dashboard_find_text = function()
	vim.ui.input({ prompt = "Find text: " }, function(input)
		if not input or input == "" then
			return
		end

		vim.cmd("vimgrep /" .. vim.fn.escape(input, "/\\") .. "/gj **/*")
		vim.cmd("copen")
	end)
end

return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = function()
		local dashboard = require("alpha.themes.dashboard")

		vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#82aaff" })
		vim.api.nvim_set_hl(0, "DashboardAccent", { fg = "#86e1fc" })
		vim.api.nvim_set_hl(0, "DashboardButton", { fg = "#86e1fc" })
		vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#65bcff" })
		vim.api.nvim_set_hl(0, "DashboardShortcut", { fg = "#ff966c" })

		local function button(shortcut, icon, label, command)
			local item = dashboard.button(shortcut, icon .. "  " .. label, command)
			item.opts.hl = "DashboardButton"
			item.opts.hl_shortcut = "DashboardShortcut"
			item.opts.align_shortcut = "right"
			item.opts.width = 52

			return item
		end

		dashboard.section.header.val = {
			"██╗   ██╗██╗███╗   ███╗ ██████╗██████╗  █████╗ ███████╗████████╗",
			"██║   ██║██║████╗ ████║██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝",
			"██║   ██║██║██╔████╔██║██║     ██████╔╝███████║█████╗     ██║   ",
			"╚██╗ ██╔╝██║██║╚██╔╝██║██║     ██╔══██╗██╔══██║██╔══╝     ██║   ",
			" ╚████╔╝ ██║██║ ╚═╝ ██║╚██████╗██║  ██║██║  ██║██║        ██║   ",
			"  ╚═══╝  ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   ",
		}
		dashboard.section.header.opts = {
			hl = "DashboardHeader",
			position = "center",
		}

		dashboard.section.buttons.val = {
			button("f", "󰈞", "Find file", "<cmd>lua _G.nvim_dashboard_find_file()<cr>"),
			button("n", "󰈔", "New file", "<cmd>ene | startinsert<cr>"),
			button("r", "󰋚", "Recent files", "<cmd>oldfiles<cr>"),
			button("g", "󰱽", "Find text", "<cmd>lua _G.nvim_dashboard_find_text()<cr>"),
			button("c", "", "Config", "<cmd>edit $MYVIMRC<cr>"),
			button(
				"m",
				"󰏖",
				"Tools",
				"<cmd>lua require('lazy').load({ plugins = { 'mason.nvim' } }); vim.cmd('Mason')<cr>"
			),
			button("l", "󰒲", "Lazy", "<cmd>Lazy<cr>"),
			button("q", "󰩈", "Quit", "<cmd>qa<cr>"),
		}

		local stats = require("lazy").stats()
		local loaded = stats.loaded or 0
		local ms = math.floor((stats.startuptime or 0) * 100 + 0.5) / 100

		dashboard.section.footer.val = "  Neovim loaded " .. loaded .. " plugins in " .. ms .. "ms"
		dashboard.section.footer.opts = {
			hl = "DashboardFooter",
			position = "center",
		}

		dashboard.config.layout = {
			{ type = "padding", val = 8 },
			dashboard.section.header,
			{ type = "padding", val = 4 },
			dashboard.section.buttons,
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		return dashboard
	end,
	config = function(_, dashboard)
		require("alpha").setup(dashboard.config)

		local dashboard_group = vim.api.nvim_create_augroup("DashboardTabline", { clear = true })
		local previous_showtabline

		vim.api.nvim_create_autocmd("FileType", {
			group = dashboard_group,
			pattern = "alpha",
			callback = function()
				previous_showtabline = vim.opt.showtabline:get()
				vim.opt.showtabline = 0
			end,
		})

		vim.api.nvim_create_autocmd("BufUnload", {
			group = dashboard_group,
			callback = function(event)
				if vim.bo[event.buf].filetype == "alpha" and previous_showtabline ~= nil then
					vim.opt.showtabline = previous_showtabline
					previous_showtabline = nil
				end
			end,
		})
	end,
}
