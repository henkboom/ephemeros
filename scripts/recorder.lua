local base = require 'dokidoki.base'

local recording
local time

function update()
  if not recording then
    recording = {initial_state = self.ship.get_state()}
    time = 1
  end

  recording[time] = base.copy(self.ship.controls)

  time = time + 1
end

function get_recording()
  return base.copy(recording)
end

function reset_recording()
  recording = nil
  time = nil
end
