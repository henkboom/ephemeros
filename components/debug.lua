local gl = require 'gl'
local kernel = require 'dokidoki.kernel'
local graphics = require 'dokidoki.graphics'

local font = (require 'dokidoki.default_font').load()

game.actors.new_generic('debug', function ()
  function draw_debug()
    gl.glPushMatrix()
    gl.glTranslated(2, game.opengl_2d.height-2, 0)
    gl.glScaled(2, 2, 2)

    gl.glColor3d(0, 0, 0)
    graphics.draw_text(font,
      string.format("%.2f", kernel.get_framerate()) .. ' fps\n' ..
      #game.actors.get('ghost_ship') .. ' ghosts')
    gl.glColor3d(1, 1, 1)

    gl.glPopMatrix()
  end
end)
