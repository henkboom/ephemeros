-- one variable `next` which is filled in after initialization

self.tags.checkpoint = true

local activate_count = 0

local function update_color()
  if activate_count == 0 then
    self.collider_renderer.color = {0, 0, 1, 0.1}
  else
    self.collider_renderer.color = {0, 0, 1, 0.2}
  end
end

function activate()
  activate_count = activate_count + 1
  update_color()
end

function deactivate()
  activate_count = activate_count - 1
  update_color()
end

