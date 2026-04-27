local function is_regular_buffer(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr)
		and vim.bo[bufnr].buflisted
		and vim.bo[bufnr].buftype == ""
		and vim.bo[bufnr].filetype ~= "neo-tree"
end

local function find_regular_window(exclude_win, exclude_buf)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local bufnr = vim.api.nvim_win_get_buf(winid)
		if winid ~= exclude_win and bufnr ~= exclude_buf and is_regular_buffer(bufnr) then
			return winid
		end
	end
end

local function find_regular_buffer(exclude_buf)
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if bufnr ~= exclude_buf and is_regular_buffer(bufnr) then
			return bufnr
		end
	end
end

local function delete_current_buffer()
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_get_current_buf()

	if not is_regular_buffer(current_buf) then
		return
	end

	if vim.bo[current_buf].modified then
		vim.cmd("bdelete " .. current_buf)
		return
	end

	local target_win = find_regular_window(current_win, current_buf)
	if target_win then
		vim.api.nvim_set_current_win(target_win)
	else
		local target_buf = find_regular_buffer(current_buf)
		if target_buf then
			vim.cmd.buffer(target_buf)
		else
			local placeholder = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_win_set_buf(current_win, placeholder)
		end
	end

	vim.api.nvim_buf_delete(current_buf, {})
end

return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			always_show_bufferline = true,
			separator_style = "slant",
			offsets = {
				{
					filetype = "neo-tree",
					text = "Files",
					text_align = "center",
					separator = true,
				},
			},
		},
	},
	keys = {
		{ "<leader>bh", ":BufferLineCyclePrev<CR>", desc = "Buffer: Previous", silent = true },
		{ "<S-h>", ":BufferLineCyclePrev<CR>", desc = "Buffer: Previous", silent = true },
		{ "<leader>bl", ":BufferLineCycleNext<CR>", desc = "Buffer: Next", silent = true },
		{ "<S-l>", ":BufferLineCycleNext<CR>", desc = "Buffer: Next", silent = true },
		{ "<leader>bp", ":BufferLinePick<CR>", desc = "Buffer: Pick", silent = true },
		{ "<leader>bd", delete_current_buffer, desc = "Buffer: Delete", silent = true },
	},
	lazy = false,
}
