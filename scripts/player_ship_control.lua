local glfw = require 'glfw'

function update()
  self.ship.controls.turn =
    (game.keyboard.key_held(glfw.KEY_LEFT) and 1 or 0) -
    (game.keyboard.key_held(glfw.KEY_RIGHT) and 1 or 0)
  self.ship.controls.brake = game.keyboard.key_held(string.byte('Z'))
end
