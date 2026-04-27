local M = {}

function M.get()
	-- 返回真正的 on_attach 回调函数
	return function(_, bufnr)
		-- 简化映射函数，统一绑定当前 buffer 的 LSP 快捷键
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, {
				buffer = bufnr,
				silent = true,
				desc = desc,
			})
		end

		-- 跳转与查看
		map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
		map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
		map("n", "gr", vim.lsp.buf.references, "LSP: List references")
		map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to implementation")
		map("n", "K", vim.lsp.buf.hover, "LSP: Hover documentation")

		-- 重构与动作
		map("n", "<leader>cr", vim.lsp.buf.rename, "LSP: Rename")
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")

		-- 诊断导航
		map("n", "[d", function()
			vim.diagnostic.jump({
				count = -1,
				float = true,
			})
		end, "Diagnostic: Previous")

		map("n", "]d", function()
			vim.diagnostic.jump({
				count = 1,
				float = true,
			})
		end, "Diagnostic: Next")

		map("n", "<leader>xd", function()
			vim.diagnostic.open_float(nil, {
				border = "rounded",
				source = "if_many",
				focusable = false,
			})
		end, "Diagnostic: Show line diagnostic")
	end
end

return M
