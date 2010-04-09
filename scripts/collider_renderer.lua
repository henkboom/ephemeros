local gl = require 'gl'

assert(color, 'missing color argument')

function draw()
  gl.glPushMatrix()
  gl.glTranslated(self.transform.pos.x, self.transform.pos.y, 0)
  local f = self.transform.facing
  gl.glRotated(180/math.pi * math.atan2(f.y, f.x), 0, 0, 1)

  gl.glColor4d(color[1], color[2], color[3], color[4] or 1)
  gl.glBegin(gl.GL_POLYGON)
  for _, v in ipairs(self.collider.poly.vertices) do
    gl.glVertex2d(v.x, v.y)
  end
  gl.glEnd()
  gl.glColor3d(1, 1, 1)

  gl.glPopMatrix()
end
