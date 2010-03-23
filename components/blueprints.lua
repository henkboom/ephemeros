local collision = require 'dokidoki.collision'
local game = require 'dokidoki.game'
local v2 = require 'dokidoki.v2'

player_ship = game.make_blueprint('player_ship',
  {'transform'},
  {'sprite', resource='ship_sprite'},
  {'collider', class='ship', poly=collision.make_rectangle(12, 8)},
  {'player_ship_control'},
  {'ship'})

obstacle = game.make_blueprint('obstacle',
  {'transform'},
  {'collider', class='obstacle'})
