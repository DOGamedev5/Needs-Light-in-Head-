local ocean = {}

ocean.lighthouse = require("src.ocean.lightHouse.lighthouse")
ocean.light = require("src.ocean.lightHouse.light")

function ocean:init()
  self.lighthouse:init()
  self.light:init()
end

function ocean:update(delta)
  self.lighthouse:update(delta)
  self.light:update(delta)
end
 
function ocean:draw()
  love.graphics.setColor(3/255, 1/255, 12/255)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(1, 1, 1)
  local drawObjects = {
    self.lighthouse,
    self.light
  }
  table.sort(drawObjects, tools.ysort)
  --camera:attach()
  for i, o in ipairs(drawObjects) do
    o:draw()
  end
  --camera:detach()
end

function ocean:mouseMoved(x, y, dx, dy, touch)
  self.light:mouseMoved(x, y, dx, dy, touch)
end

return ocean
