local M = {}

M.auto = true

function M.register(lint)
	local config_path = vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml"

	lint.linters["markdownlint-cli2"].args = {
		"--config",
		config_path,
		"-",
	}
end

M.linters_by_ft = {
	markdown = { "markdownlint-cli2" },
}

return M
