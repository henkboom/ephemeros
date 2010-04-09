assert(recording, 'missing recording argument')

local time = 1

function update()
  if not recording[time] then
    --self.dead = true
    --return
    time = 1
  end

  if time == 1 then
    self.ship.set_state(recording.initial_state)
  end

  for k, v in pairs(recording[time]) do
    self.ship.controls[k] = v
  end

  time = time + 1
end
