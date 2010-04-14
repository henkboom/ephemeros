local gl = require 'gl'
local v2 = require 'dokidoki.v2'

--TODO: better
local next_checkpoint = game.actors.get('checkpoint')[1]
next_checkpoint.checkpoint.activate()

game.collision.add_collider(self, 'checkpoint', function (other, correction)
  if other == next_checkpoint then
    next_checkpoint.checkpoint.deactivate()
    next_checkpoint = other.checkpoint.next
    next_checkpoint.checkpoint.activate()
  end
end)

local next_rank = 1
time = 0
function update()
  if time > 0 and time % 60 == 0 then
    game.actors.new(game.blueprints.ghost_ship,
      {'ghost_ship_control',
       recording=self.recorder.get_recording(),
       rank=next_rank})
    next_rank = next_rank + 1

    self.recorder.reset_recording()
  end

  time = time + 1
end

game.collision.add_collider(self, 'ghost_ship', function (other, correction)
  self.ship.collide(correction, other.ship.vel)
end)
