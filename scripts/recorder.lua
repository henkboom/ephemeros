local base = require 'dokidoki.base'

local recording
local time

function update()
  if not recording then
    reset_recording()
  end

  time = time + 1

  recording[time] = base.copy(self.ship.controls)
end

function get_recording()
  return base.copy(recording)
end

function reset_recording()
  recording = {initial_state = self.ship.get_state()}
  time = 0
end

