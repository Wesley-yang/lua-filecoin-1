local bit = require 'bit'
local band = bit.band
local bor = bit.bor
local lshift = bit.lshift
local byte = string.byte
local ffi = require 'ffi'

local newBuffer = ffi.typeof('uint8_t[?]')

-- Convert a read function that reads raw chunks and return a new read function
-- that returns deframed messages with the length header stripped.
-- If the stream closes with a partial frame, an error is emitted.
-- If read is called again after returning error or EOS, it will throw an error.
-- read can return lua style errors (nil, err) as well.
--   deframe(read) -> read
--     input  read() -> chunk or nil
--     output read() -> frame or nil
return function(read)
  -- Extra data from the last frame.
  local chunk = nil
  local index = 0

  -- Get next byte as a number
  -- Returns nil on EOS
  local function next()
    while true do
      if not chunk then
        chunk = read()
        index = 1
      end
      if not chunk then
        return
      end
      if index <= #chunk then
        local b = byte(chunk, index)
        index = index + 1
        return b
      else
        chunk = nil
      end
    end
  end

  -- Returns the next payload or nil on EOS
  return function()
    -- Parse the varint length header first.
    local length = 0
    local bits = 0
    while true do
      local b = next()
      if not b then
        return
      end
      length = bor(length, lshift(band(b, 0x7f), bits))
      if b < 0x80 then
        break
      end
      bits = bits + 7
    end

    -- Consume the body using a mutable buffer.
    local buffer = newBuffer(length)
    for i = 0, length - 1 do
      local b = next()
      if not b then
        return
      end
      buffer[i] = b
    end

    -- Return the body as a lua string.
    return ffi.string(buffer, length)
  end
end