local base = require 'dokidoki.base'

local ghost = require 'ghost'

local recording
local time

local function reset_recording()
  recording = ghost.make('player', self.ship.rank, self.ship.get_state())
  time = 0
end

function update()
  if not recording then
    reset_recording()
  end

  time = time + 1

  recording.add_frame(self.ship.controls)
end

function get_recording()
  return recording
end
