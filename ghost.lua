local public = {}

-- start is optional
-- returns the ghost and the index of the first character after the ghost data
function public.deserialize(initial_state, data, start)
  local _, ending, name, rank, frame_count =
    data:find("^([a-zA-Z0-9_]*):([0-9]*):([0-9]*):", start)
  rank = tonumber(rank)
  frame_count = tonumber(frame_count)
  assert(ending, 'corrupt ghost data')
  data_start = ending + 1
  data_ending = ending + math.ceil(frame_count * 2/8)
  assert(data_ending <= #data, 'premature end for ghost data')

  local frames = {}

  local bitmask = 0
  local byte = 0
  local next_byte_index = data_start
  for frame = 1, frame_count do
    if bitmask == 0 then
      bitmask = 2^7
      byte = data:byte(next_byte_index)
      next_byte_index = next_byte_index + 1
    end

    local left = byte / bitmask >= 1
    byte = byte % bitmask
    bitmask = math.floor(bitmask / 2)
    local right = byte / bitmask >= 1
    byte = byte % bitmask
    bitmask = math.floor(bitmask / 2)

    table.insert(frames, {left = left, right = right})
  end

  return public.make(name, rank, initial_state, frames), data_ending + 1
end

function public.make(name, rank, initial_state, frames)
  frames = frames or {}

  local ghost = {}

  function ghost.get_name()
    return name
  end

  function ghost.get_rank()
    return rank
  end

  function ghost.get_initial_state()
    return initial_state
  end

  function ghost.add_frame(controls)
    frames[#frames+1] = {
      left = controls.left,
      right = controls.right
    }
  end

  function ghost.get_frame(time)
    return frames[time]
  end

  function ghost.serialize()
    local data = {name, ':', rank, ':', #frames, ':'}

    local byte = 0
    local bitmask = 2^7
    for frames_saved = 0, #frames-1 do
      if bitmask == 0 then
        table.insert(data, string.char(byte))
        byte = 0
        bitmask = 2^7
      end

      byte = byte + (frames[frames_saved+1].left and bitmask or 0)
      bitmask = math.floor(bitmask / 2)
      byte = byte + (frames[frames_saved+1].right and bitmask or 0)
      bitmask = math.floor(bitmask / 2)

      frames_saved = frames_saved + 1
    end
    table.insert(data, string.char(byte))

    return table.concat(data)
  end

  return ghost
end

return public
