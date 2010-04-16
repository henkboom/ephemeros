local gl = require 'gl'

assert(color, 'missing color argument')

function draw_obstacles()
  gl.glPushMatrix()
  gl.glTranslated(self.transform.pos.x, self.transform.pos.y, 0)
  local f = self.transform.facing
  gl.glRotated(180/math.pi * math.atan2(f.y, f.x), 0, 0, 1)

  gl.glBegin(gl.GL_POLYGON)
  for _, v in ipairs(self.collider.poly.vertices) do
    gl.glVertex3d(v.x, v.y, -0.5)
  end
  gl.glEnd()

  gl.glPopMatrix()
end
