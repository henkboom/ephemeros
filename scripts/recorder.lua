local base = require 'dokidoki.base'

local ghost = require 'ghost'

local recording
local time

local function reset_recording()
  local rank = recording and recording.get_rank() + 1 or 1
  recording = ghost.make('player_ghost_' .. rank, rank, self.ship.get_state())
  time = 0
end

function update()
  if not recording then
    reset_recording()
  end

  time = time + 1

  recording.add_frame(self.ship.controls)
end

function cut_recording()
  local ret = recording
  reset_recording()
  return ret
end
