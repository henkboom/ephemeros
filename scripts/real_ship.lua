local gl = require 'gl'

--TODO: better
local next_checkpoint = game.actors.get('checkpoint')[1]
next_checkpoint.checkpoint.activate()

game.collision.add_collider(self, 'checkpoint', function (other, correction)
  if other == next_checkpoint then
    next_checkpoint.checkpoint.deactivate()
    next_checkpoint = other.checkpoint.next
    next_checkpoint.checkpoint.activate()

    game.actors.new(game.blueprints.ghost_ship,
      {'ghost_ship_control', recording=self.recorder.get_recording()})

    self.recorder.reset_recording()
  end
end)

