exports.name = "creationix/git"
exports.version = "2.0.0"
exports.homepage = "https://github.com/luvit/lit/blob/master/deps/git.lua"
exports.description = "An implementation of git in pure lua."
exports.tags = {"git","db"}
exports.license = "MIT"
exports.author = { name = "Tim Caswell" }
exports.dependencies = {
  "creationix/hex-bin",
  "creationix/coro-fs",
}
exports.files = {
  "*.lua",
}

local makeChroot = require('coro-fs').chroot
local makeStorage = require('./storage')
local makeDb = require('./db')
local core = require('./core')

for key, value in pairs(core) do
  exports[key] = value
end

function exports.mount(path)
  local fs = makeChroot(path)
  local storage = makeStorage(fs)
  local db = makeDb(storage)
  return db
end
