local base = require 'dokidoki.base'

local ghost = require 'ghost'

local recording
local time

local function reset_recording()
  recording = ghost.make_ghost(self.ship.get_state())
  time = 0
end

function update()
  if not recording then
    reset_recording()
  end

  time = time + 1

  recording.add_frame(self.ship.controls)
end

-- gets and resets recording
function cut_recording()
  local ret = recording
  reset_recording()
  return ret
end
