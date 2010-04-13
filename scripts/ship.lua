local v2 = require 'dokidoki.v2'

self.tags.ship = true

-- controls access
controls = {
  turn = 0,
}

vel = v2(0, 0)

local buffered_turn = 0

local function damp(value, scalar, multiplier)
  local sign = value > 0 and 1 or -1
  return math.max(value * sign - scalar, 0) * multiplier * sign
end

local function damp_v2(vect, scalar, multiplier)
  local mag = v2.mag(vect)
  if mag > 0 then
    return vect * damp(v2.mag(vect), scalar, multiplier) / mag
  else
    return vect
  end
end

function get_state()
  return {
    pos = self.transform.pos,
    facing = self.transform.facing,
    vel = vel,
    buffered_turn = buffered_turn
  }
end

function set_state(state)
  self.transform.pos = state.pos
  self.transform.facing = state.facing
  vel = state.vel
  buffered_turn = state.buffered_turn
end

function update()
  -- rotation
  buffered_turn = buffered_turn * 0.90 + controls.turn * 0.10
  self.transform.facing =
    v2.norm(v2.rotate(self.transform.facing, buffered_turn * 0.07))

  -- acceleration
  vel = vel + self.transform.facing * 0.1

  -- general damping
  vel = damp_v2(vel, 0.005, 0.998)

  -- car damping
  vel =
    v2.project(vel, self.transform.facing)  * 0.99 +
    damp_v2(v2.project(vel, v2.rotate90(self.transform.facing)), 0.005, 0.94)

  self.transform.pos = self.transform.pos + vel
end

function collide (correction, collision_vel)
  self.transform.pos = self.transform.pos + correction * 0.1

  local relative_vel = vel - collision_vel
  local normal_vel = v2.project(relative_vel, correction)
  local tangent_vel = relative_vel - normal_vel
  if v2.dot(normal_vel, correction) < 0 then
    vel = collision_vel - 0.2 * normal_vel
          + damp_v2(tangent_vel, v2.mag(normal_vel)*0.75, 1)
  end
end

