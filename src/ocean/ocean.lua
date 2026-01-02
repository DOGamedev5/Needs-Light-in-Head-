local ocean = {}

ocean.lighthouse = require("src.ocean.lightHouse.lighthouse")
ocean.light = require("src.ocean.lightHouse.light")
ocean.Effect = require("src.ocean.effect")
ocean.effects = {}
ocean.already = false

ocean.enemiesTable = {
  require("src.ocean.enemies.tier1.enemy1.enemy1")
}
ocean.entities = {}
ocean.dayManager = require("src.ocean.daysManager")
ocean.enemyManager = require("src.ocean.enemies.enemySpawner")
ocean.dropManager = require("src.ocean.dropManager")
ocean.currentDay = {}

function ocean:init()
  self.light:init()
  self.lighthouse:init(self.light)
  
  if self.already then return end
  for i=1, 20 do
    self.effects[i] = self.Effect.new()
  end
  self.already = true
  self.enemyManager:load()
  self.currentDay = self.dayManager:getCurrentDayData(currentScene.save.currentDay)
  self.enemyManager:init(self.currentDay.enemies, self.currentDay.rules, self.currentDay.sides, self.currentDay.time)
 
end

function ocean:exit()
  self.light:exit() 
end

function ocean:update(delta)
  self.enemyManager:update(delta)
  self.dropManager:update(delta)
  
  for i=1, #self.effects do
    self.effects[i]:update(delta)
  end
  for i=#self.entities, 1, -1 do
    if self.entities[i].toDie then
      self.entities[i]:die()
      table.remove(self.entities, i)
    else
      self.entities[i]:update(delta)
    end
  end

  self.lighthouse:update(delta)
  self.light:update(delta)
  if self.light.fuel == 0 then
    currentScene:finish({
      beated = false
    })
  elseif self.enemyManager.timeAlive >= self.currentDay.time and #self.enemyManager.instances == 0 then
    currentScene:finish({
      beated = true
    })
  end

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
    unpack(EnemyClass.toDraw),
  }

  table.sort(drawObjects, tools.ysort)
  for i, o in ipairs(drawObjects) do
    love.graphics.setColor(1, 1, 1, 1)
    o:draw()
  end
  self.dropManager:draw()

  love.graphics.setColor(0.8, 0.6, 0.3, 0.7)
  local y = love.mouse.getY()
  if y > windowSize.y*gameScale - 40*gameScale then
    love.graphics.setColor(0.8, 0.6, 0.3, 0.2)
  end

  love.graphics.rectangle("fill", 0, windowSize.y-30, windowSize.x*(self.light.fuel/self.light.fuelMax), 30)
end

function ocean:mouseMoved(x, y, dx, dy, touch)
  self.light:mouseMoved(x, y, dx, dy, touch)
end

function ocean:beginContact(a, b, col)
  local dataA = a:getUserData()
  local dataB = b:getUserData()
  if dataA then
    if dataA.beginContact then
      dataA:beginContact(b)
    end
  end
  if dataB then
    if dataB.beginContact then
      dataB:beginContact(a)
    end
  end
end

function ocean:afterContact(a, b, col)
  local dataA = a:getUserData()
  local dataB = b:getUserData()
  if dataA then
    if dataA.afterContact then
      dataA:afterContact(b)
    end
  end
  if dataB then
    if dataB.afterContact then
      dataB:afterContact(a)
    end
  end
end

return ocean
