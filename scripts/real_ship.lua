local gl = require 'gl'
local v2 = require 'dokidoki.v2'

local ghost = require 'ghost'

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

--time = 0
--function update()
--  if time > 0 and time % 60 == 0 then
--    local recording = self.recorder.cut_recording()
--    -- good perpetual testing
--    recording = ghost.deserialize(
--      recording.get_initial_state(),
--      recording.serialize())
--    game.actors.new(game.blueprints.ghost_ship,
--      {'ghost_ship_control', recording=recording})
--  end
--
--  time = time + 1
--end

game.collision.add_collider(self, 'ghost_ship', function (other, correction)
  self.ship.collide(correction, other.ship.vel)
end)
