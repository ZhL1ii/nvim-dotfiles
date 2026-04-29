local function is_regular_buffer(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr)
		and vim.bo[bufnr].buflisted
		and vim.bo[bufnr].buftype == ""
		and vim.bo[bufnr].filetype ~= "neo-tree"
end

local function find_regular_buffer(exclude_buf)
	-- 当 bufferline 里找不到左侧 buffer 时，从 Neovim 的 buffer 列表里
	-- 找一个仍然可用的普通文件 buffer，避免关闭当前 buffer 后停在无效页面。
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if bufnr ~= exclude_buf and is_regular_buffer(bufnr) then
			return bufnr
		end
	end
end

local function find_window_showing_buffer(bufnr)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_buf(winid) == bufnr then
			return winid
		end
	end
end

local function find_left_buffer(current_buf)
	-- bufferline 维护了用户在顶部看到的 buffer 顺序。直接用 nvim_list_bufs()
	-- 只能拿到 Neovim 内部顺序，和界面上从左到右的顺序不一定一致。
	local ok, bufferline = pcall(require, "bufferline")
	if not ok then
		return nil
	end

	-- get_elements() 返回 bufferline 当前展示顺序中的元素。
	-- pcall 可以避免插件尚未加载或 API 出错时影响关闭 buffer 的主流程。
	local ok_elements, result = pcall(bufferline.get_elements)
	if not ok_elements or not result or not result.elements then
		return nil
	end

	local left_buf
	for _, element in ipairs(result.elements) do
		local bufnr = element.id
		if bufnr == current_buf then
			-- 从左到右遍历时，left_buf 始终记录当前 buffer 左边最近的普通 buffer。
			return left_buf
		end

		-- 只把普通文件 buffer 作为跳转目标，过滤 neo-tree、terminal、help 等特殊 buffer。
		if is_regular_buffer(bufnr) then
			left_buf = bufnr
		end
	end
end

local function delete_buffer(bufnr)
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = bufnr or vim.api.nvim_get_current_buf()

	if not is_regular_buffer(current_buf) then
		return
	end

	if vim.bo[current_buf].modified then
		vim.cmd("bdelete " .. current_buf)
		return
	end

	-- 先切换当前窗口的 buffer，再删除原 buffer。这样关闭后用户停留在当前窗口，
	-- 并且目标页会按 bufferline 视觉顺序优先选择左侧第一个。
	local target_buf = find_left_buffer(current_buf) or find_regular_buffer(current_buf)
	local target_win = find_window_showing_buffer(current_buf)

	if not target_win and vim.api.nvim_win_get_buf(current_win) == current_buf then
		target_win = current_win
	end

	if target_win then
		if target_buf then
			vim.api.nvim_win_set_buf(target_win, target_buf)
		else
			-- 如果这是最后一个普通 buffer，就创建一个新的空 buffer，避免当前窗口没有内容。
			local placeholder = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_win_set_buf(target_win, placeholder)
		end
	end

	vim.api.nvim_buf_delete(current_buf, {})
end

local function delete_current_buffer()
	delete_buffer()
end

return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			always_show_bufferline = true,
			close_command = delete_buffer,
			right_mouse_command = delete_buffer,
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
