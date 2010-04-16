local base = require 'dokidoki.base'
local collision = require 'dokidoki.collision'
local v2 = require 'dokidoki.v2'

local function data_to_polygon(data)
  local points = base.imap(function (p) return v2(unpack(p)) end, data)
  return collision.points_to_polygon(points)
end

function load(level)
  -- {{name, checkpoint}...}
  local checkpoints = {}

  for _, data in ipairs(level) do
    if data.type == 'obstacle' then
      local pos, poly = data_to_polygon(data)
      game.actors.new(game.blueprints.obstacle,
        {'transform', pos=pos},
        {'collider', poly=poly})
    elseif string.sub(data.type, 1, 10) == "checkpoint" then
      local pos, poly = data_to_polygon(data)
      local checkpoint = game.actors.new(game.blueprints.checkpoint,
        {'transform', pos=pos},
        {'collider', poly=poly})
      table.insert(checkpoints, {data.type, checkpoint})
    end
  end

  table.sort(checkpoints, function (a, b) return a[1] < b[1] end)
  for i = 1, #checkpoints do
    local next_i = (i == #checkpoints) and 1 or i+1
    checkpoints[i][2].checkpoint.next = checkpoints[next_i][2]
  end
end

game.actors.new_generic('obstacle_drawing_setup', function ()
  local gl = require 'gl'

  function draw_obstacles ()
    gl.glEnable(gl.GL_DEPTH_TEST)
    gl.glDepthFunc(gl.GL_ALWAYS)
    gl.glColorMask(false, false, false, false)

    gl.glClearDepth(1.0)
    gl.glClear(gl.GL_DEPTH_BUFFER_BIT)
  end

  function draw_terrain()
    local w = game.opengl_2d.width
    local h = game.opengl_2d.height

    gl.glDepthFunc(gl.GL_LEQUAL)
    gl.glColorMask(true, true, true, true)

    gl.glColor4d(1, 1, 1, 0.5)
    gl.glBegin(gl.GL_QUADS)
    gl.glVertex2d(0, 0)
    gl.glVertex2d(w, 0)
    gl.glVertex2d(w, h)
    gl.glVertex2d(0, h)
    gl.glEnd()
    gl.glColor3d(1, 1, 1)
    gl.glDisable(gl.GL_DEPTH_TEST)
  end
end)
