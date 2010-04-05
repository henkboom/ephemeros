local v2 = require 'dokidoki.v2'

self.tags.ship = true

-- controls access
controls = {
  turn = 0,
  brake = false
}

local vel = v2(0, 0)
local buffered_turn = 0
local brake_duration = 0
local boost_duration = 0

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

function update()
  -- boost triggering
  if controls.brake then
    boost_duration = 0
    brake_duration = brake_duration + 1
  elseif brake_duration > 0 then
    boost_duration = math.min(20, math.floor(brake_duration / 5))
    brake_duration = 0
  end

  -- rotation
  buffered_turn = buffered_turn * 0.90 + controls.turn * 0.10
  self.transform.facing =
    v2.norm(v2.rotate(self.transform.facing, buffered_turn * 0.07))

  -- acceleration
  local current_accel = 0
  if not controls.brake then
    current_accel = 0.1 + (boost_duration > 0 and 0.3 or 0)
  end
  vel = vel + self.transform.facing * current_accel

  -- general damping
  vel = damp_v2(vel, 0.005, 0.998)

  if not controls.brake then
    -- normal damping
    vel =
      v2.project(vel, self.transform.facing)  * 0.99 +
      damp_v2(v2.project(vel, v2.rotate90(self.transform.facing)), 0.005, 0.94)
  else
    -- braking damping
    vel =
      v2.project(vel, self.transform.facing)  * 0.99 +
      damp_v2(v2.project(vel, v2.rotate90(self.transform.facing)), 0.005, 0.96)
  end

  self.transform.pos = self.transform.pos + vel
  boost_duration = math.max(boost_duration - 1, 0)
end

function self.collider.on_collide(normal)
  local normal_vel = v2.project(vel, normal)
  local tangent_vel = vel - normal_vel
  if v2.dot(normal_vel, normal) < 0 then
    vel = -0.2 * normal_vel +
          damp_v2(tangent_vel, v2.mag(normal_vel)*0.75, 1)
  end
end
