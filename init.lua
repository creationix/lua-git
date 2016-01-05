
local core = require('./core')
local exports = {}
for key, value in pairs(core) do
  exports[key] = value
end

function exports.mount(fs)
  return require('./db')(require('./storage')(fs))
end

return exports
