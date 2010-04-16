local glfw = require 'glfw'

function update()
  self.ship.controls.left = game.keyboard.key_held(glfw.KEY_LEFT)
  self.ship.controls.right = game.keyboard.key_held(glfw.KEY_RIGHT)
end
