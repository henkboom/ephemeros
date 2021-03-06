local v2 = require 'dokidoki.v2'

local BASE_URL = 'http://stuff.henk.ca/dart450/api/'

local GHOST_OFFSET_TIME = 20
local TOTAL_TIME = 60 * 20
local INITIAL_STATE = {
  pos = v2(250, 250),
  facing = v2(1, 0),
  vel = v2(0, 0),
  buffered_turn = 0
}
local FADE_TIME = 30

game.actors.new_generic('game_flow', function ()
  local http = require 'socket.http'
  local gl = require 'gl'
  local kernel = require 'dokidoki.kernel'

  local ghost = require 'ghost'
  local race = require 'race'

  local ghosts = {}
  local parent_id
  local ghost_to_send

  local function get_ghosts()
    print 'loading ghosts...'

    local data, code = http.request(BASE_URL .. '?get-race')
    if not data then
      print('network error: ' .. code)
      return false
    elseif code ~= 200 then
      print('recieved http response code: ' .. code)
      return false
    end

    local _, ending
    _, ending, parent_id = data:find('^([0-9]*):')
    local start = ending + 1
    while start <= #data do
      local recording
      recording, start = ghost.deserialize(INITIAL_STATE, data, start)
      table.insert(ghosts, recording)
    end

    print('loaded ' .. #ghosts .. ' ghosts')
    return true
  end

  local function send_ghost()
    if not ghost_data_to_send then
      local player = game.actors.get('player_ship')[1]
      ghost_data_to_send = parent_id .. ':'
                           .. player.recorder.cut_recording().serialize()
    end
    print('sending player ghost...')

    local response, code = http.request(BASE_URL, ghost_data_to_send)
    if not response then
      print('network error: ' .. code)
      return false
    elseif code ~= 200 then
      print('recieved http response code: ' .. code)
      return false
    end

    print('done sending')
    return true
  end

  local time = 0

  function update()
    if time == 0 then
      if not get_ghosts() then
        return -- try again next frame
      end
    end

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
      if not send_ghost() then
        return
      end
      kernel.switch_scene(race.make())
    end

    time = time + 1
  end

  function draw_transitions()
    local visibility = math.min(time, (TOTAL_TIME - 1 - time)) / FADE_TIME
    if visibility < 1 then
      local w, h = game.opengl_2d.width, game.opengl_2d.height
      gl.glColor4d(0, 0, 0, 1-visibility)
      gl.glBegin(gl.GL_QUADS)
      gl.glVertex2d(0, 0)
      gl.glVertex2d(w, 0)
      gl.glVertex2d(w, h)
      gl.glVertex2d(0, h)
      gl.glEnd()
      gl.glColor3d(1, 1, 1)
    end
  end
end)
