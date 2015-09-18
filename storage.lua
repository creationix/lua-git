
--[[
Low Level Storage Commands
==========================

These are the filesystem abstractions needed by a git database

storage.write(path, raw)     - Write mutable data by path
storage.put(path, raw)       - Write immutable data by path
storage.read(path) -> raw    - Read mutable data by path (nil if not found)
storage.delete(path)         - Delete an entry (removes empty parent directories)
storage.nodes(path) -> iter  - Iterate over node children of path
                               (empty iter if not found)
storage.leaves(path) -> iter - Iterate over node children of path
                               (empty iter if not found)
]]

return function (fs)

  local storage = { fs = fs }

  local function dirname(path)
    return path:match("^(.*)/") or ""
  end

  -- Perform an atomic write (with temp file and rename) for mutable data
  function storage.write(path, data)
    -- Ensure the parent directory exists first.
    assert(fs.mkdirp(dirname(path)))
    -- Write the data out to a temporary file.
    local tempPath = path .. "~"
    do
      local fd, success, err
      fd = assert(fs.open(tempPath, "w", 384))
      success, err = fs.write(fd, data)
      fs.close(fd)
      assert(success, err)
    end
    -- Rename the temp file on top of the old file for atomic commit.
    assert(fs.rename(tempPath, path))
  end

  -- Write immutable data with an exclusive open.
  function storage.put(path, data)
    local fd, success, err
    assert(fs.mkdirp(dirname(path)))
    fd = assert(fs.open(path, "wx"))
    success, err = fs.write(fd, data)
    if success then
      success, err = fs.fchmod(fd, 256)
    end
    fs.close(fd)
    assert(success, err)
  end

  function storage.read(path)
    local data, err = fs.readFile(path)
    if data then return data end
    if err:match("^ENOENT:") then return end
    assert(data, err)
  end

  function storage.delete(path)
    assert(fs.unlink(path))
    local dirPath = path
    while true do
      dirPath = dirname(dirPath)
      local iter = assert(fs.scandir(dirPath))
      if iter() then return end
      assert(fs.rmdir(dirPath))
    end
  end

  local function iter(path, filter)
    local it, err = fs.scandir(path)
    if not it then
      if err:match("^ENOENT:") then
        return function() end
      end
      assert(it, err)
    end
    return function ()
      while true do
        local item = it()
        if not item then return end
        if item.type == filter then
          return item.name
        end
      end
    end
  end

  function storage.nodes(path)
    return iter(path, "directory")
  end

  function storage.leaves(path)
    return iter(path, "file")
  end

  return storage
end
