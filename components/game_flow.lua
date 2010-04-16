local v2 = require 'dokidoki.v2'

local GHOST_OFFSET_TIME = 30
local TOTAL_TIME = 60 * 10
local INITIAL_STATE = {
  pos = v2(100, 120),
  facing = v2(1, 0),
  vel = v2(0, 0),
  buffered_turn = 0
}

game.actors.new_generic('game_flow', function ()
  local http = require 'socket.http'

  local kernel = require 'dokidoki.kernel'
  local ghost = require 'ghost'

  local ghosts = {}
  local parent_id

  print 'loading ghosts...'
  local data = http.request('http://localhost/miniracer/?get-race')
  local _, ending
  _, ending, parent_id = data:find('^([0-9]*):')
  local start = ending + 1
  while start <= #data do
    local recording
    recording, start = ghost.deserialize(INITIAL_STATE, data, start)
    table.insert(ghosts, recording)
  end
  print('loaded ' .. #ghosts .. ' ghosts')

  local time = 0

  function update()
    if time % GHOST_OFFSET_TIME == 0 then
      local index = time / GHOST_OFFSET_TIME
      if ghosts[index] then
        game.actors.new(game.blueprints.ghost_ship,
          {'ghost_ship_control', recording=ghosts[index]})
      end
    end
    if time == (#ghosts+1) * GHOST_OFFSET_TIME then
      print 'spawning player'
      local player = game.actors.new(game.blueprints.player_ship)
      player.ship.set_state(INITIAL_STATE)
    end
    if time == TOTAL_TIME then
      local player = game.actors.get('player_ship')[1]
      local data = parent_id .. ':'
                   .. player.recorder.cut_recording().serialize()
      print('sending player ghost...')
      print(http.request('http://localhost/miniracer/', data))
      print('done sending')
      error('exit')
    end
    time = time + 1
  end
end)
