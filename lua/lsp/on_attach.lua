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

		local show_diagnostic_float = function(jump_bufnr)
			-- 统一诊断浮窗入口，跳转诊断和手动查看保持同一套显示行为。
			vim.diagnostic.open_float({
				bufnr = jump_bufnr,
				scope = "cursor",
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
		-- Neovim 0.12 提供内置 :lsp 管理命令，方便在当前 buffer 重启/停止 server。
		map("n", "<leader>cR", "<cmd>lsp restart<cr>", "LSP: Restart")
		map("n", "<leader>cS", "<cmd>lsp stop<cr>", "LSP: Stop")

		-- 诊断导航
		map("n", "[d", function()
			vim.diagnostic.jump({
				count = -1,
				on_jump = function(diagnostic, jump_bufnr)
					-- on_jump 只在真的跳到诊断时打开浮窗，避免无诊断时弹空窗口。
					if diagnostic then
						show_diagnostic_float(jump_bufnr)
					end
				end,
			})
		end, "Diagnostic: Previous")

		map("n", "]d", function()
			vim.diagnostic.jump({
				count = 1,
				on_jump = function(diagnostic, jump_bufnr)
					-- 保留原来“跳转后立即看到诊断内容”的使用习惯。
					if diagnostic then
						show_diagnostic_float(jump_bufnr)
					end
				end,
			})
		end, "Diagnostic: Next")

		map("n", "<leader>xd", function()
			show_diagnostic_float(bufnr)
		end, "Diagnostic: Show line diagnostic")
	end
end

return M
