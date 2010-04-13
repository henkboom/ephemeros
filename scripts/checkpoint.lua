-- one variable `next` which is filled in after initialization

self.tags.checkpoint = true

local activate_count = 0

function activate()
  activate_count = activate_count + 1
end

function deactivate()
  activate_count = activate_count - 1
end

