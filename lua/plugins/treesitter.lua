return {
	"nvim-treesitter/nvim-treesitter",

	-- master 分支仍是稳定兼容配置方式，后续升级到 Neovim 0.12+ 后再考虑切 main。
	branch = "master",

	-- nvim-treesitter 官方不建议 lazy-load。
	-- 原因是高亮、缩进、折叠都依赖 buffer 打开时就准备好 parser。
	lazy = false,

	-- 插件更新后同步更新 parser，避免插件代码和 parser 版本不匹配。
	build = ":TSUpdate",

	config = function()
		require("nvim-treesitter.configs").setup({
			-- 这里写需要有语法树支持的语言。
			-- parser 名称不一定等于 filetype，例如 vimdoc 是帮助文档 parser。
			-- 新增语言时可以先用 :TSInstallInfo 查看可用名称。
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"go",
				"java",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},

			-- false 表示安装 parser 时不阻塞 Neovim 启动。
			sync_install = false,

			-- 打开某种文件时，如果对应 parser 没装，会自动安装。
			auto_install = true,

			highlight = {
				-- Tree-sitter 的核心能力：用语法树做高亮，比传统 regex 高亮更准确。
				enable = true,

				-- 大文件解析成本高，这里超过 200KB 就关闭 Treesitter 高亮，避免卡顿。
				disable = function(_, buf)
					local max_filesize = 200 * 1024
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					return ok and stats and stats.size > max_filesize
				end,

				-- false 表示不叠加 Vim 传统正则高亮，避免重复高亮和性能损耗。
				-- 少数语言如果高亮缺失，可以改成 { "language_name" } 只对该语言叠加。
				additional_vim_regex_highlighting = false,
			},

			indent = {
				-- 使用语法树辅助 =、缩进等行为。这个功能仍可能因语言而异。
				enable = true,

				-- Python/YAML 对缩进非常敏感，Treesitter 缩进有时不如语言工具稳定。
				-- 这里交给你的基础缩进设置、LSP 或 formatter 处理。
				disable = { "python", "yaml" },
			},

			incremental_selection = {
				-- 按语法节点逐步扩大/缩小选择范围，比普通 visual 选择更适合改代码块。
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
		})

		-- 使用 Neovim 内置 Treesitter foldexpr，让折叠按语法结构计算。
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

		-- 默认打开文件不自动折叠；需要时用 za/zc/zo 手动折叠即可。
		vim.opt.foldenable = false
	end,
}
