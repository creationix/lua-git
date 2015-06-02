# lua-git

Git implementation in pure lua for luvit.

## Get Git

Install using the [lit](https://github.com/luvit/lit) toolkit.

```sh
lit install creationix/git
```

## git.mount(fs) -> db

The primary interface to the git module is a mount command that accepts a fs
interface instance and returns a git database.  Under the hood it mounts a git
repository using the same filesystem format as the native git tool.  This
includes support for reading packed objects and refs.

The `fs` interface is required to implement the same API as a coro-fs chroot that
is rooted at the database root.

```lua
local makeChroot = require('coro-fs').chroot
local mount = require('git').mount

local db = mount(makeChroot("path/to/.git"))

--[[
db.has(hash) -> bool                   - check if db has an object
db.load(hash) -> raw                   - load raw data, nil if not found
db.loadAny(hash) -> kind, value        - pre-decode data, error if not found
db.loadAs(kind, hash) -> value         - pre-decode and check type or error
db.save(raw) -> hash                   - save pre-encoded and framed data
db.saveAs(kind, value) -> hash         - encode, frame and save to objects/$ha/$sh
db.hashes() -> iter                    - Iterate over all hashes

db.getHead() -> hash                   - Read the hash via HEAD
db.getRef(ref) -> hash                 - Read hash of a ref
db.resolve(ref) -> hash                - Given a hash, tag, branch, or HEAD, return the hash
db.nodes(prefix) -> iter               - iterate over non-leaf refs
db.leaves(prefix) -> iter              - iterate over leaf refs
]]
```

## git.modes

The modes table contains constants and helpers for working with git tree entry modes.

TODO: show example usage.

## git.encoders

This table contains the internal encoder functions for constructing the binary
representation of git objects.

## git.decoders

This table contains decoders for reading binary git objects into lua.
