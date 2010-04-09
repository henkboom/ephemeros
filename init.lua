require 'dokidoki.module' [[]]

local kernel = require 'dokidoki.kernel'
local game = require 'dokidoki.game'
local v2 = require 'dokidoki.v2'

kernel.start_main_loop(game.make_game(
  {'update_setup', 'update', 'collision_check', 'update_cleanup'},
  {'draw_setup', 'draw', 'draw_debug'},
  function (game)
    game.init_component('exit_handler')
    game.exit_handler.trap_esc = true
    game.init_component('keyboard')
    game.init_component('opengl_2d')
    game.opengl_2d.background_color = {1, 1, 1}

    game.init_component('blueprints')
    game.init_component('resources')
    game.init_component('debug')
    game.init_component('collision')
    game.init_component('level')
    game.level.load(loadfile(arg[1] or 'levels/eight.lua')())

    local player = game.actors.new(game.blueprints.player_ship,
      {'transform', pos=v2(100, 120)})
  end))
