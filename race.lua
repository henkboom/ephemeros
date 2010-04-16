require 'dokidoki.module' [[ make ]]

local game = require 'dokidoki.game'
local v2 = require 'dokidoki.v2'

function make()
  return game.make_game(
    {'update_setup', 'update', 'collision_check', 'update_cleanup'},
    {'draw_setup', 'draw_obstacles', 'draw_terrain', 'draw', 'draw_transitions',
     'draw_debug'},
    function (game)
      game.init_component('exit_handler')
      game.exit_handler.trap_esc = true
      game.init_component('keyboard')
      game.init_component('opengl_2d')
      game.opengl_2d.background_color = {1, 1, 1}
      game.opengl_2d.width = 1024
      game.opengl_2d.height = 768

      game.init_component('camera')
      game.init_component('blueprints')
      game.init_component('resources')
      game.init_component('debug')
      game.init_component('collision')

      game.actors.new(game.blueprints.background)

      game.init_component('level')
      game.level.load(loadfile(arg[1] or 'levels/long.lua')())

      game.init_component('game_flow')
      collectgarbage('collect')
    end)
end

return get_module_exports()