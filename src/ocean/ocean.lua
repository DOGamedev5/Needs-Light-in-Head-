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
ocean.counter = require("src.ocean.hudElements.counter")
ocean.counterList = {}

ocean.currentDay = {}

function ocean:init()
  self.collects = {}
  self.light:init()
  self.lighthouse:init(self.light)
  
  if self.already then return end
  for i=1, 20 do
    self.effects[i] = self.Effect.new()
  end
  self.already = true
  self.enemyManager:load()
  self.currentDay = self.dayManager:getCurrentDayData(currentScene.save.currentDay)
  self.enemyManager:init(self.currentDay)
  self.counterHud = ListOrder.new(5, 5, 5)

  Hud:addToHud(self.counterHud)
end

function ocean:exit()
  self.light:exit() 
end

function ocean:update(delta)
  self.enemyManager:update(delta)
  self.dropManager:update(delta)
  self.counterHud:update(delta)
  
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

  local function finished(beat)
    currentScene:finish({
      beated = beat,
      collects = self.collects,
      counters = self.counterList
    })
  end

  if self.light.fuel == 0 then
    finished(false)
  elseif self.enemyManager.timeAlive >= self.currentDay.time then
    finished(true)
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

  love.graphics.setColor(1, 1, 1, 1)
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

function ocean:registerDrop(drop)
  if self.collects[drop] == nil then
    self.collects[drop] = 0
    local image = string.gsub("src/ocean/drops/$d/$dIcon.png", "$d", drop)
    self.counterList[drop] = self.counter.new(
      love.graphics.newImage(image)
    )
  self.counterHud:addToList(self.counterList["darkEssence"])
  end

  self.collects[drop] = self.collects[drop] + 1

  self.counterList[drop]:updateCounter(self.collects[drop])
end

return ocean
