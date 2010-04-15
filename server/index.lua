#! /usr/bin/env lua

require 'lsqlite3'

local conf = dofile('conf.lua')

local model, api

local function first(iter, ...)
  return iter(...)
end

---- MODEL --------------------------------------------------------------------

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
        data BLOB NOT NULL
      );
    ]]

    return db
  end
  
  function model.get_racers()
    local db = connect()

    local ghost = first(db:nrows [[
      SELECT * FROM ghosts
      WHERE id NOT IN (SELECT parent_id FROM ghosts)
      ORDER BY RANDOM()
      LIMIT 1;
    ]])

    if not ghost then
      return false
    end

    local get_ghost = db:prepare [[
      SELECT * FROM ghosts where ghosts.id = :id LIMIT 1;
    ]]

    local racers = {}
    racers[ghost.rank] = ghost
    for i = ghost.rank-1, 1, -1 do
      get_ghost:bind{id = racers[i+1].parent_id}
      racers[i] = first(get_ghost:nrows())
    end
    return racers
  end

  -- data is {name=string, parent_id=integer, rank=integer, data=string}
  function model.submit_ghost(values)
    local db = model.connect()

    -- TODO: validate

    local sql = [[
      INSERT INTO ghosts (name, parent_id, rank, data)
        VALUES (:name, :parent_id, :rank, :data)
    ]]

    local stmt = db:prepare(sql)
    stmt:bind_names(values)
    stmt:step()
  end

  function model.dump_debug_info()
  end
end

---- API ----------------------------------------------------------------------

api = {}

do
  function api.get_race()
    print 'content-type: text/plain\n'
  
    local racers = model.get_racers()

    if racers then
      local encoded_racers = {racers[#racers].id .. ':'}
      for _, racer in ipairs(racers) do
        table.insert(encoded_racers, racer.name .. ':' .. #racer.data .. ':'
        .. racer.data)
      end
      print(table.concat(encoded_racers))
    else
      print('-1:')
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
  
    print '<submit ghost please>'
    print('"' .. io.read('*a') .. '"')
    print '<end>'
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
  else
    api.show_index()
  end
elseif method == 'POST' then
  submit_race()
else
  print 'Status: 404 Not Found\n'
  print 'Not found :('
end
