local core = require('../core')
local encoders = core.encoders
local decoders = core.decoders
local frame = core.frame
local deframe = core.deframe
local modes = core.modes
local dump = require('pretty-print').dump

local tests = {
  "blob", "Hello World\n", "Hello World\n",
  "blob", "\1\0\2\0\3\0\4\0\5\0", "\1\0\2\0\3\0\4\0\5\0",
  "blob", "", "",
  "tag", {
    object = "affe225fdb68803477e0fd9dea2f1cee309faed3",
    type = "commit",
    tag = "v2.0.9",
    tagger = {
      name = "Tim Caswell",
      email = "tim@creationix.com",
      date = {
        seconds = 1431710918,
        offset = -300,
      }
    },
    message = "Luvi v2.0.9"
  }, "object affe225fdb68803477e0fd9dea2f1cee309faed3\ntype commit\ntag v2.0.9\ntagger Tim Caswell <tim@creationix.com> 1431710918 -0500\n\nLuvi v2.0.9\n",
  "commit", {
    tree = "9b5a82b1cf7306709848d502121c22a50cfa4667",
    parents = { "d966b5d6668fb63e0eede457367c4f9d9067e745" },
    author = {
      name = "Tim Caswell",
      email = "tim@creationix.com",
      date = {
        seconds = 1431710879,
        offset = -300
      }
    },
    committer = {
      name = "Tim Caswell",
      email = "tim@creationix.com",
      date = {
        seconds = 1431710879,
        offset = -300
      }
    },
    message = "Bump version again to get good submodules\n"
  }, "tree 9b5a82b1cf7306709848d502121c22a50cfa4667\nparent d966b5d6668fb63e0eede457367c4f9d9067e745\nauthor Tim Caswell <tim@creationix.com> 1431710879 -0500\ncommitter Tim Caswell <tim@creationix.com> 1431710879 -0500\n\nBump version again to get good submodules\n",
  "tree", {
    { mode = modes.tree, hash = "07bee11133660674c182cba3a85be87e2308d01e", name = "cmake"},
    { mode = modes.tree, hash = "ce3be9f3a01701602b080ac8eef48a34ca73f051", name = "deps"},
    { mode = modes.tree, hash = "215e61b297bccc78580be6fbe135dc11c4122f09", name = "packaging"},
    { mode = modes.tree, hash = "49f99fd5989f62921e47b7a5332548ee0e6d5226", name = "samples"},
    { mode = modes.tree, hash = "a89d220db1d54e9a68a6477fea288dd316b6a912", name = "src"},
    { mode = modes.blob, hash = "8e9eb228a657ef6eb6acc31cc77d279fa3011c63", name = ".gitignore"},
    { mode = modes.blob, hash = "9bb8db6088ab2fc9b35a2347aa6b69365d3e9066", name = ".gitmodules"},
    { mode = modes.blob, hash = "426d23fa5454ca2ce1b3dd784ce2d6635bc63729", name = ".travis.yml"},
    { mode = modes.blob, hash = "31acbf043bc9fa4db678fbe819af4bf851838ef2", name = "CHANGELOG.md"},
    { mode = modes.blob, hash = "2d0af1fe328fba97544fd07cf38d43e696079695", name = "CMakeLists.txt"},
    { mode = modes.blob, hash = "d645695673349e3947e8e5ae42332d0ac3164cd7", name = "LICENSE.txt"},
    { mode = modes.blob, hash = "ab9413cae513746de3b080c4a5446990cc885d55", name = "Makefile"},
    { mode = modes.blob, hash = "04a8167099345935d558e4e3cd59ba1ebf31e47e", name = "README.md"},
    { mode = modes.blob, hash = "3ba44e645a76e7786e4fe10d1b336de3fd7757a7", name = "appveyor.yml"},
    { mode = modes.blob, hash = "6001cab8388bf5e17903cc440c8e747cf1908a00", name = "make.bat"},
  }, "100644 .gitignore\0\x8e\x9e\xb2\x28\xa6\x57\xef\x6e\xb6\xac\xc3\x1c\xc7\x7d\x27\x9f\xa3\x01\x1c\x63" ..
     "100644 .gitmodules\0\x9b\xb8\xdb\x60\x88\xab\x2f\xc9\xb3\x5a\x23\x47\xaa\x6b\x69\x36\x5d\x3e\x90\x66" ..
     "100644 .travis.yml\0\x42\x6d\x23\xfa\x54\x54\xca\x2c\xe1\xb3\xdd\x78\x4c\xe2\xd6\x63\x5b\xc6\x37\x29" ..
     "100644 CHANGELOG.md\0\x31\xac\xbf\x04\x3b\xc9\xfa\x4d\xb6\x78\xfb\xe8\x19\xaf\x4b\xf8\x51\x83\x8e\xf2" ..
     "100644 CMakeLists.txt\0\x2d\x0a\xf1\xfe\x32\x8f\xba\x97\x54\x4f\xd0\x7c\xf3\x8d\x43\xe6\x96\x07\x96\x95" ..
     "100644 LICENSE.txt\0\xd6\x45\x69\x56\x73\x34\x9e\x39\x47\xe8\xe5\xae\x42\x33\x2d\x0a\xc3\x16\x4c\xd7" ..
     "100644 Makefile\0\xab\x94\x13\xca\xe5\x13\x74\x6d\xe3\xb0\x80\xc4\xa5\x44\x69\x90\xcc\x88\x5d\x55" ..
     "100644 README.md\0\x04\xa8\x16\x70\x99\x34\x59\x35\xd5\x58\xe4\xe3\xcd\x59\xba\x1e\xbf\x31\xe4\x7e" ..
     "100644 appveyor.yml\0\x3b\xa4\x4e\x64\x5a\x76\xe7\x78\x6e\x4f\xe1\x0d\x1b\x33\x6d\xe3\xfd\x77\x57\xa7" ..
     "40000 cmake\0\x07\xbe\xe1\x11\x33\x66\x06\x74\xc1\x82\xcb\xa3\xa8\x5b\xe8\x7e\x23\x08\xd0\x1e" ..
     "40000 deps\0\xce\x3b\xe9\xf3\xa0\x17\x01\x60\x2b\x08\x0a\xc8\xee\xf4\x8a\x34\xca\x73\xf0\x51" ..
     "100644 make.bat\0\x60\x01\xca\xb8\x38\x8b\xf5\xe1\x79\x03\xcc\x44\x0c\x8e\x74\x7c\xf1\x90\x8a\x00" ..
     "40000 packaging\0\x21\x5e\x61\xb2\x97\xbc\xcc\x78\x58\x0b\xe6\xfb\xe1\x35\xdc\x11\xc4\x12\x2f\x09" ..
     "40000 samples\0\x49\xf9\x9f\xd5\x98\x9f\x62\x92\x1e\x47\xb7\xa5\x33\x25\x48\xee\x0e\x6d\x52\x26" ..
     "40000 src\0\xa8\x9d\x22\x0d\xb1\xd5\x4e\x9a\x68\xa6\x47\x7f\xea\x28\x8d\xd3\x16\xb6\xa9\x12",
}

for i = 1, #tests, 3 do
  local kind = tests[i]
  local input = tests[i + 1]
  local expected = tests[i + 2]
  local ok, actual = pcall(encoders[kind], input)
  if not ok then
    error("encoders." .. kind .. "(" .. dump(input) .. ") errored: " .. actual)
  end
  if actual ~= expected then
    error("encoders." .. kind .. "(" .. dump(input) .. ") should be " .. dump(expected) .. " but was " .. dump(actual))
  end
end

-- Test above had wrong sort order on purpose.  We need to fix it to do the decode test.
tests[17] = {
    { mode = modes.blob, hash = "8e9eb228a657ef6eb6acc31cc77d279fa3011c63", name = ".gitignore"},
    { mode = modes.blob, hash = "9bb8db6088ab2fc9b35a2347aa6b69365d3e9066", name = ".gitmodules"},
    { mode = modes.blob, hash = "426d23fa5454ca2ce1b3dd784ce2d6635bc63729", name = ".travis.yml"},
    { mode = modes.blob, hash = "31acbf043bc9fa4db678fbe819af4bf851838ef2", name = "CHANGELOG.md"},
    { mode = modes.blob, hash = "2d0af1fe328fba97544fd07cf38d43e696079695", name = "CMakeLists.txt"},
    { mode = modes.blob, hash = "d645695673349e3947e8e5ae42332d0ac3164cd7", name = "LICENSE.txt"},
    { mode = modes.blob, hash = "ab9413cae513746de3b080c4a5446990cc885d55", name = "Makefile"},
    { mode = modes.blob, hash = "04a8167099345935d558e4e3cd59ba1ebf31e47e", name = "README.md"},
    { mode = modes.blob, hash = "3ba44e645a76e7786e4fe10d1b336de3fd7757a7", name = "appveyor.yml"},
    { mode = modes.tree, hash = "07bee11133660674c182cba3a85be87e2308d01e", name = "cmake"},
    { mode = modes.tree, hash = "ce3be9f3a01701602b080ac8eef48a34ca73f051", name = "deps"},
    { mode = modes.blob, hash = "6001cab8388bf5e17903cc440c8e747cf1908a00", name = "make.bat"},
    { mode = modes.tree, hash = "215e61b297bccc78580be6fbe135dc11c4122f09", name = "packaging"},
    { mode = modes.tree, hash = "49f99fd5989f62921e47b7a5332548ee0e6d5226", name = "samples"},
    { mode = modes.tree, hash = "a89d220db1d54e9a68a6477fea288dd316b6a912", name = "src"},
}

local function deepEqual(a, b)
  if a == b then return true end
  if type(a) ~= type(b) or type(a) ~= "table" then return false end
  if #a ~= #b then return false end
  local count = 0
  for key, value in pairs(a) do
    count = count + 1
    if not deepEqual(value, b[key]) then return false end
  end
  for _ in pairs(b) do
    count = count - 1
  end
  if count ~= 0 then return false end
  return true
end

for i = 1, #tests, 3 do
  local kind = tests[i]
  local expected = tests[i + 1]
  local input = tests[i + 2]
  local ok, actual = pcall(decoders[kind], input)
  if not ok then
    error("decoders." .. kind .. "(" .. dump(input) .. ") errored: " .. actual)
  end
  if not deepEqual(actual, expected) then
    error("decoders." .. kind .. "(" .. dump(input) .. ") should be " .. dump(expected) .. " but was " .. dump(actual))
  end
end

local prefixes = {
  "blob 12\0",
  "blob 10\0",
  "blob 0\0",
  "tag 141\0",
  "commit 254\0",
  "tree 549\0",
}

for i = 1, #tests, 3 do
  local kind = tests[i]
  local encoded = tests[i + 2]
  local prefix = prefixes[(i + 2) / 3]
  local expected = prefix .. encoded
  local ok, actual = pcall(frame, kind, encoded)
  if not ok then
    error("frame(" .. dump(kind) .. ", " .. dump(encoded) .. ") errored: " .. actual)
  end
  if actual ~= expected then
    error("frame(" .. dump(kind) .. ", " .. dump(encoded) .. ") should be " .. dump(expected) .. " but was " .. dump(actual))
  end
  local data
  ok, actual, data = pcall(deframe, expected)
  if not ok then
    error("deframe(" .. dump(expected) .. ") errored: " .. actual)
  end
  if actual ~= kind or data ~= encoded then
    error("deframe(" .. dump(expected) .. ") should be " .. dump(kind) .. ", " .. dump(encoded) .. " but was " .. dump(actual) .. ", " .. dump(data))
  end
end

for i = 1, #tests, 3 do
  local kind = tests[i]
  local input = tests[i + 1]

  local framed = frame(kind, encoders[kind](input))
  local outKind, raw = deframe(framed)
  assert(outKind == kind, "Kind mismatch in round trip")
  assert(deepEqual(decoders[kind](raw), input), "Value mismatch in round trip")
end
