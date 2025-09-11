local ocean = {}

ocean.lighthouse = require("src.ocean.lightHouse.lighthouse")
ocean.light = require("src.ocean.lightHouse.light")
ocean.Effect = require("src.ocean.effect")
ocean.effects = {}
ocean.already = false

require("src.ocean.enemies.enemyClass")

ocean.enemiesTable = {
  require("src.ocean.enemies.tier1.enemy1.enemy1")
}
ocean.entities = {}

function ocean:init()
  self.lighthouse:init()
  self.light:init()
  
  if self.already then return end
  for i=1, 20 do
    self.effects[i] = self.Effect.new()
  end
  self.already = true

  --self.entities[1] = self.enemiesTable[1].new(40, 40)
  --self.entities[2] = self.enemiesTable[1].new(400, 400)

end

function ocean:exit()
  self.light:exit() 
end

function ocean:update(delta)
  for i=1, #self.effects do
    self.effects[i]:update(delta)
  end
  for i=1, #self.entities do
    --self.entities[i]:update()
  end

  self.lighthouse:update(delta)
  self.light:update(delta)
end
 
function ocean:draw()
  love.graphics.setColor(3/255, 1/255, 12/255)
  love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
  love.graphics.setColor(1, 1, 1)

  for i=1, #self.effects do
    self.effects[i]:draw()
  end

  local drawObjects = {
    self.lighthouse,
    self.light,
    unpack(self.entities)
  }
  table.sort(drawObjects, tools.ysort)
  --camera:attach()
  for i, o in ipairs(drawObjects) do
    love.graphics.setColor(1, 1, 1, 1)
    o:draw()
  end
  --camera:detach()
end

function ocean:mouseMoved(x, y, dx, dy, touch)
  self.light:mouseMoved(x, y, dx, dy, touch)
end

return ocean
