local gl = require 'gl'
local collision = require 'dokidoki.collision'
local v2 = require 'dokidoki.v2'

local ships = {}
local obstacles = {}
local checkpoints = {}

function add_collider(actor)
  if actor.collider.class == 'ship' then
    table.insert(ships, actor)
  elseif actor.collider.class == 'obstacle' then
    table.insert(obstacles, actor)
  elseif actor.collider.class == 'checkpoint' then
    table.insert(checkpoints, actor)
  else
    error('unknown collision type: ' .. actor.collider.class)
  end
end

game.actors.new_generic('collision', function ()
  function collision_check()
    local function set_body(body, actor)
      body.pos = actor.transform.pos
      body.facing = actor.transform.facing
      body.poly = actor.collider.poly
    end

    local body1 = {}
    local body2 = {}
    for _, s in ipairs(ships) do
      set_body(body1, s)
      for _, o in ipairs(obstacles) do
        set_body(body2, o)
        local correction = collision.collide(body1, body2)
        if correction then
          s.transform.pos = s.transform.pos + correction
          s.collider.on_collide(v2.norm(correction))
          set_body(body1, s)
        end
      end
    end
  end
end)
