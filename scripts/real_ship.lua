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

time = 0
function update()
  time = time + 1
  if time % 60 == 0 then
    game.actors.new(game.blueprints.ghost_ship,
      {'ghost_ship_control', recording=self.recorder.get_recording()})

    self.recorder.reset_recording()
  end
end

game.collision.add_collider(self, 'obstacle', function (other, correction)
  self.ship.collide(correction, v2.zero)
  self.recorder.record_collision(correction, v2.zero)
end)
game.collision.add_collider(self, 'ghost_ship', function (other, correction)
  self.ship.collide(correction, other.ship.vel)
  self.recorder.record_collision(correction, other.ship.vel)
end)
