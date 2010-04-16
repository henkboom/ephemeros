require 'dokidoki.module' [[]]

local kernel = require 'dokidoki.kernel'
local game = require 'dokidoki.game'
local v2 = require 'dokidoki.v2'

kernel.start_main_loop(game.make_game(
  {'update_setup', 'update', 'collision_check', 'update_cleanup'},
  {'draw_setup', 'draw_obstacles', 'draw_terrain', 'draw', 'draw_debug'},
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

    game.actors.new(game.blueprints.player_ship,
      {'transform', pos=v2(100, 120)})

    -- debug
    game.actors.new_generic('debug_network', function ()
      local http = require 'socket.http'
      local ghost = require 'ghost'

      local initial_state = game.actors.get('player_ship')[1].ship.get_state()

      function update()
        if game.keyboard.key_pressed(string.byte('S')) then
          local player = game.actors.get('player_ship')[1]
          local data = '0:' ..  player.recorder.cut_recording().serialize()
          print('----sending begin')
          print(http.request('http://localhost/miniracer/', data))
          print('----sending end')
        end

        if game.keyboard.key_pressed(string.byte('L')) then
          print('----loading begin')
          local data = http.request('http://localhost/miniracer/?get-race')
          print(data)
          local _, ending, parent_id =
            data:find('^([0-9]*):')
          local start = ending + 1
          while start <= #data do
            local recording
            print('decoding ' .. data:sub(start))
            recording, start = ghost.deserialize(initial_state, data, start)
            game.actors.new(game.blueprints.ghost_ship,
              {'ghost_ship_control', recording=recording})
          end
          print('----loading end')
        end

      end
    end)
  end))
