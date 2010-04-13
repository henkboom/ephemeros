local base = require 'dokidoki.base'

local recording
local time

function update()
  if not recording then
    recording = {initial_state = self.ship.get_state()}
    time = 0
  end

  time = time + 1

  recording[time] = base.copy(self.ship.controls)
end

function record_collision(...)
  if recording then
    recording[time].collisions = recording[time].collisions or {}
    table.insert(recording[time].collisions, {...})
  end
end

function get_recording()
  return base.copy(recording)
end

function reset_recording()
  recording = nil
  time = nil
end
