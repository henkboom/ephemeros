local base = require 'dokidoki.base'
local collision = require 'dokidoki.collision'
local v2 = require 'dokidoki.v2'

local function data_to_polygon(data)
  local points = base.imap(function (p) return v2(unpack(p)) end, data)
  return collision.points_to_polygon(points)
end

function load(level)
  local checkpoints = {}

  for _, data in ipairs(level) do
    if data.type == 'obstacle' then
      local pos, poly = data_to_polygon(data)
      game.actors.new(game.blueprints.obstacle,
        {'transform', pos=pos},
        {'collider', poly=poly})
    elseif string.sub(data.type, 1, 10) == "checkpoint" then
      table.insert(checkpoints, data)
    end

  end

  table.sort(checkpoints, function (a, b) return a.type < b.type end)
  for i, data in pairs(checkpoints) do
    local pos, poly = data_to_polygon(data)
    game.actors.new(game.blueprints.checkpoint,
      {'transform', pos=pos},
      {'collider', poly=poly})
  end
end
