local gl = require 'gl'
local base = require 'dokidoki.base'

local brightness = 0.5
local color = base.irandomize{0, brightness, math.random()*brightness}

function draw_setup()
  local w, h = game.opengl_2d.width, game.opengl_2d.height


  game.resources.background:draw()
  gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE)
  gl.glColor3d(unpack(color))
  gl.glBegin(gl.GL_QUADS)
  gl.glVertex2d(0, 0)
  gl.glVertex2d(w, 0)
  gl.glVertex2d(w, h)
  gl.glVertex2d(0, h)
  gl.glEnd()
  gl.glColor3d(1, 1, 1)
  gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)

end

