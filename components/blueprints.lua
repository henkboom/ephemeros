local collision = require 'dokidoki.collision'
local game = require 'dokidoki.game'
local v2 = require 'dokidoki.v2'

player_ship = game.make_blueprint('player_ship',
  {'transform'},
  {'sprite', resource='ship_sprite'},
  {'collider', poly=collision.make_rectangle(12, 8)},
  {'player_ship_control'},
  {'ship'},
  {'real_ship'})

obstacle = game.make_blueprint('obstacle',
  {'transform'},
  {'collider'},
  {'collider_renderer', color={0.7, 0.5, 0.5}})

checkpoint = game.make_blueprint('checkpoint',
  {'transform'},
  {'collider'},
  {'collider_renderer', color={0, 0, 1, 0.1}},
  {'checkpoint'})
