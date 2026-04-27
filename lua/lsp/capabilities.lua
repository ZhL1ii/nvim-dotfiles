-- 提供所有LSP server共用的 capabilities
local M = {}

function M.get()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if ok and blink.get_lsp_capabilities then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end
  return capabilities
end

return M
