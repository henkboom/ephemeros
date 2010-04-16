#! /usr/bin/env lua

require 'lsqlite3'

local conf = dofile('conf.lua')

local model, api

local function first(iter, ...)
  return iter(...)
end

---- MODEL --------------------------------------------------------------------

local MAX_CHAIN = 10

do
  model = {}

  local function connect()
    local db, _, err = sqlite3.open(conf.db_filename)
    assert(db, err)

    db:exec [[
      CREATE TABLE IF NOT EXISTS ghosts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        parent_id INTEGER REFERENCES ghosts (id),
        rank INTEGER NOT NULL,
        frame_count INTEGER NOT NULL,
        data BLOB NOT NULL
      );
    ]]

    return db
  end
  
  function model.get_racers()
    local db = connect()

    local ghost = first(db:nrows([[
      SELECT * FROM ghosts
      WHERE id NOT IN (SELECT parent_id FROM ghosts)
         AND rank < ]] .. MAX_CHAIN .. [[
      ORDER BY RANDOM()
      LIMIT 1;
    ]]))

    if not ghost then
      return false
    end

    local get_ghost = db:prepare [[
      SELECT * FROM ghosts WHERE id = :id LIMIT 1;
    ]]

    local racers = {}
    racers[ghost.rank] = ghost
    for i = ghost.rank-1, 1, -1 do
      get_ghost:bind_names{id = racers[i+1].parent_id}
      racers[i] = first(get_ghost:nrows())
      get_ghost:reset()
    end
    return racers
  end

  function model.submit_ghost(name, parent_id, frame_count, data)
    local db = connect()

    -- TODO: validate

    local get_rank = db:prepare [[
      SELECT rank FROM ghosts WHERE id = :id LIMIT 1;
    ]]

    get_rank:bind_names{id = parent_id}
    local parent = first(get_rank:nrows())
    local rank = parent and parent.rank+1 or 1

    local sql = [[
      INSERT INTO ghosts (name, parent_id, rank, frame_count, data)
        VALUES (:name, :parent_id, :rank, :frame_count, :data);
    ]]

    local stmt = db:prepare(sql)
    stmt:bind_names{name=name, parent_id=parent_id, rank=rank,
                    frame_count=frame_count, data=data}
    stmt:step()
  end

  function model.dump_debug_info()
    local db = connect()

    local stmt = db:prepare [[
      SELECT * FROM ghosts;
    ]]

    print('--------')
    for ghost in stmt:nrows() do
      io.write(string.format('id:%i\tname:%s\tparent_id:%i\trank:%i\tframes:%i ',
        ghost.id, ghost.name, ghost.parent_id, ghost.rank, ghost.frame_count))
      io.write('0x')
      for i = 1, #ghost.data do
        io.write(string.format('%.2x', ghost.data:sub(i, i):byte()))
      end
      print('\n--------')
    end
  end
end

---- API ----------------------------------------------------------------------

api = {}

do
  function api.get_race()
    print 'content-type: application/octet-stream\n'
  
    local racers = model.get_racers()

    if racers then
      io.write(racers[#racers].id, ':')
      for _, racer in ipairs(racers) do
        io.write(racer.name, ':', racer.rank, ':', racer.frame_count, ':',
                 racer.data)
      end
    else
      io.write('0:')
    end
  end
  
  function api.show_test_form()
    print 'content-type: text/html\n'
  
    print('<form action="." method="POST">' ..
            '<textarea name="data"></textarea>' ..
            '<input type="submit" name="submit"></input></textarea>' ..
          '</form>')
  end
  
  function api.show_index()
    print 'content-type: text/plain\n'
  
    print '<index>'
  end
  
  function api.submit_ghost()
    print 'content-type: text/plain\n'

    local input = io.read('*a')
    local _, ending, parent_id, name, _, frame_count =
      input:find("^([0-9]*):([a-zA-Z0-9_]*):([0-9]*):([0-9]*):", start)
    frame_count = tonumber(frame_count)
    assert(ending, 'corrupt ghost data')
    data_start = ending + 1
    data_ending = ending + math.ceil(frame_count * 2/8)
    assert(data_ending <= #input, 'premature end for ghost data')

    local data = input:sub(data_start, data_ending)
  
    model.submit_ghost(name, parent_id, frame_count, data)
  end

  function api.show_debug_info()
    print 'content-type: text/plain\n'

    model.dump_debug_info()
  end
end

---- INIT ---------------------------------------------------------------------

local method = os.getenv('REQUEST_METHOD')
local query = os.getenv('QUERY_STRING')

if method == 'GET' then
  if query == 'get-race' then
    api.get_race()
  elseif query == 'test-form' then
    api.show_test_form()
  elseif query == 'debug-info' then
    api.show_debug_info()
  else
    api.show_index()
  end
elseif method == 'POST' then
  api.submit_ghost()
else
  print 'Status: 404 Not Found\n'
  print 'Not found :('
end
