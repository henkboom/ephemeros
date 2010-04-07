local gl = require 'gl'

--TODO: better
local next_checkpoint = game.actors.get('checkpoint')[1]
next_checkpoint.checkpoint.activate()

game.collision.add_collider(self, 'checkpoint', function (other, correction)
  if other == next_checkpoint then
    print('checkpoint')
    next_checkpoint.checkpoint.deactivate()
    next_checkpoint = other.checkpoint.next
    next_checkpoint.checkpoint.activate()
  end
end)

