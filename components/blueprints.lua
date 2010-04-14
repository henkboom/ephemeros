local collision = require 'dokidoki.collision'
local game = require 'dokidoki.game'
local v2 = require 'dokidoki.v2'

player_ship = game.make_blueprint('player_ship',
  {'transform'},
  {'sprite', resource='ship_sprite'},
  {'collider', poly=collision.make_rectangle(12, 8)},
  {'player_ship_control'},
  {'real_ship'},
  {'recorder'},
  {'ship'})

ghost_ship = game.make_blueprint('ghost_ship',
  {'transform'},
  {'sprite', resource='ship_sprite', color={1, 1, 1, 0.5}},
  {'collider', poly=collision.make_rectangle(12, 8)},
  {'ghost_ship_control'},
  {'ship'})

obstacle = game.make_blueprint('obstacle',
  {'transform'},
  {'collider'},
  {'collider_renderer', color={0.7, 0.5, 0.5}})

checkpoint = game.make_blueprint('checkpoint',
  {'transform'},
  {'collider'},
  {'checkpoint'})
