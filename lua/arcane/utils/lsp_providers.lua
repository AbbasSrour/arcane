local M = {}
local null_ls = require("null-ls")

---------------------------------------- Services --------------------------------------------------
function M.list_registered_providers_names(filetype)
  local s = require("null-ls.sources")
  local available_sources = s.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

---------------------------------------- Linters --------------------------------------------------
local linter_method = null_ls.methods.DIAGNOSTICS

function M.list_registered_linters(filetype)
  local registered_providers = M.list_registered_providers_names(filetype)
  return registered_providers[linter_method] or {}
end

---------------------------------------- formatters --------------------------------------------------
local formatter_method = null_ls.methods.FORMATTING

function M.list_registered_formmaters(filetype)
  local registered_providers = M.list_registered_providers_names(filetype)
  return registered_providers[formatter_method] or {}
end

return M
