local import = _G.import or require

local core = import('./core')
local exports = {}
for key, value in pairs(core) do
  exports[key] = value
end

function exports.mount(fs)
  return import('./db')(import('./storage')(fs))
end

return exports
