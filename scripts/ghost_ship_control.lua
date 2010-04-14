assert(recording, 'missing recording argument')
assert(rank, 'missing rank argument')

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

game.collision.add_collider(self, 'ghost_ship', function (other, correction)
  if rank > other.ghost_ship_control.rank then
    self.ship.collide(correction, other.ship.vel)
  end
end)
