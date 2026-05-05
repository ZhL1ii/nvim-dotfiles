local buffer = require("utils.buffer")

local function get_hl_color(group, attr)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	if not ok or not hl or not hl[attr] then
		return nil
	end

	return string.format("#%06x", hl[attr])
end

local colors = {
	bg = "NONE",
	fg = get_hl_color("Normal", "fg"),
	fg_dark = get_hl_color("Comment", "fg"),
	blue = get_hl_color("Directory", "fg"),
	cyan = get_hl_color("DiagnosticInfo", "fg"),
	green = get_hl_color("DiagnosticHint", "fg"),
	orange = get_hl_color("DiagnosticWarn", "fg"),
	red = get_hl_color("DiagnosticError", "fg"),
	separator = get_hl_color("WinSeparator", "fg") or get_hl_color("VertSplit", "fg") or get_hl_color("Comment", "fg"),
}

return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			mode = "buffers",
			numbers = "ordinal",
			always_show_bufferline = true,

			show_buffer_icons = true,
			show_buffer_close_icons = false,
			show_close_icon = false,
			show_modified_icon = true,

			diagnostics = "nvim_lsp",
			separator_style = { "▕", "▕" },
			indicator = {
				style = "none",
			},

			close_command = buffer.delete,
			right_mouse_command = buffer.delete,

			offsets = {
				{
					filetype = "neo-tree",
					text = "󰙅 Files",
					text_align = "center",
					separator = false,
					highlight = "BufferLineNeoTree",
				},
			},

			max_name_length = 20,
			max_prefix_length = 15,
			truncate_names = true,
			enforce_regular_tabs = true,
			tab_size = 20,
			sort_by = "insert_after_current",
		},

		highlights = {
			fill = { bg = colors.bg },
			background = { fg = colors.fg_dark, bg = colors.bg },

			buffer_visible = { fg = colors.fg_dark, bg = colors.bg },
			buffer_selected = {
				fg = colors.blue,
				bg = colors.bg,
				bold = true,
				italic = false,
			},

			numbers = { fg = colors.fg_dark, bg = colors.bg },
			numbers_visible = { fg = colors.fg_dark, bg = colors.bg },
			numbers_selected = {
				fg = colors.blue,
				bg = colors.bg,
				bold = true,
				italic = false,
			},

			separator = { fg = colors.separator, bg = colors.bg },
			separator_visible = { fg = colors.separator, bg = colors.bg },
			separator_selected = { fg = colors.separator, bg = colors.bg },

			indicator_selected = { fg = colors.bg, bg = colors.bg },

			modified = { fg = colors.orange, bg = colors.bg },
			modified_visible = { fg = colors.orange, bg = colors.bg },
			modified_selected = {
				fg = colors.orange,
				bg = colors.bg,
				bold = false,
			},

			error = { fg = colors.red, bg = colors.bg },
			error_selected = { fg = colors.red, bg = colors.bg, bold = false },

			warning = { fg = colors.orange, bg = colors.bg },
			warning_selected = { fg = colors.orange, bg = colors.bg, bold = false },

			info = { fg = colors.cyan, bg = colors.bg },
			info_selected = { fg = colors.cyan, bg = colors.bg, bold = false },

			hint = { fg = colors.green, bg = colors.bg },
			hint_selected = { fg = colors.green, bg = colors.bg, bold = false },

			pick = { fg = colors.red, bg = colors.bg, bold = false },
			pick_selected = { fg = colors.red, bg = colors.bg, bold = false },

			BufferLineNeoTree = {
				fg = colors.blue,
				bg = colors.bg,
				bold = true,
			},
		},
	},

	keys = {
		{ "<leader>bh", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer: Previous", silent = true },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer: Previous", silent = true },

		{ "<leader>bl", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer: Next", silent = true },
		{ "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer: Next", silent = true },

		{ "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Buffer: Pick", silent = true },

		{ "<leader>bd", buffer.delete_current, desc = "Buffer: Delete", silent = true },
		{ "<leader>bD", buffer.force_delete_current, desc = "Buffer: Force Delete", silent = true },
		{ "<leader>bo", buffer.delete_others, desc = "Buffer: Delete Others", silent = true },
		{ "<leader>ba", buffer.delete_all, desc = "Buffer: Delete All", silent = true },
	},

	lazy = false,
}
