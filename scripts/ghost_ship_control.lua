assert(recording, 'missing recording argument')

local time

function update()
  time = (time or 0) + 1

  if not recording[time] then
    time = 1
  end

  if time == 1 then
    self.ship.set_state(recording.initial_state)
  end

  for k, v in pairs(recording[time]) do
    self.ship.controls[k] = v
  end

end

function collision_check()
  if time then
    if recording[time].collisions then
      for _, args in ipairs(recording[time].collisions) do
        self.ship.collide(unpack(args))
      end
    end
  end
end
