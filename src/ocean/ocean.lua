local ocean = {}

ocean.startStatus = 0
ocean.startTimer = 0

ocean.water = require("src.ocean.effects.waterEffect")

ocean.lighthouse = require("src.ocean.lightHouse.lighthouse")
ocean.light = require("src.ocean.lightHouse.light")
ocean.Effect = require("src.ocean.effect")
ocean.effects = {}
ocean.already = false

ocean.entities = {}
ocean.dayManager = require("src.ocean.daysManager")
ocean.enemyManager = require("src.ocean.enemies.enemySpawner")
ocean.enemyManager:load()
ocean.dropManager = require("src.ocean.dropManager")
ocean.counter = require("src.ocean.hudElements.counter")
ocean.counterList = {}
ocean.visualCollect = require("src.ocean.hudElements.visualCollect")

ocean.currentDay = {}
ocean.timeCounter = {
  --font = love.graphics.newImageFont("assets/fonts/SimpleFont.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-+/\\:,;=", 1),
  draw = function(self)
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.setFont(fonts.normal)
    local scale = 2
    local remain = ocean.enemyManager.timeMax - ocean.enemyManager.timeAlive 
    local seconds = math.floor(remain)

    if seconds <= 10 then
      love.graphics.setColor(0.9, 0.1, 0.3, 0.7)
      scale = 1 + scale + 1*(remain - seconds)
    end
    
    local text = string.format("%ds", seconds)
    local dayText = string.format("Day %d - %d", currentScene.save.currentDay, currentScene.save.currentWeek)
    local wid = fonts.normal:getWidth(text)*scale
    local dayWid = fonts.normal:getWidth(dayText)*2
    local dayHei = fonts.normal:getHeight(dayText)*2

    love.graphics.print(dayText, windowSize.x - dayWid - 10, 5, 0, 2, 2)
    love.graphics.print(text, windowSize.x - wid - 10, dayHei + 2, 0, scale, scale)

  end
}


function ocean:init()
  self.startStatus = 0
  self.startTimer = 0
  Hud.hidden = true

  self.water:setWaterColor({5/255, 4/255, 8/255})
  self.water:updateOverColor({9/255*1.4, 18/255*1.4, 59/255*1.2, 0.9})

  --self.water:setWaterColor({4/255, 2/255, 15/255})
  --self.water:updateOverColor({12/255*1.2, 20/255*1.2, 70/255*1.2, 0.95})
  
  self.collects = {}
  self.light:init()
  self.lighthouse:init(self.light)
  
  self.currentDay = self.dayManager:getCurrentDayData(currentScene.save.currentDay, currentScene.save.currentWeek)
  self.enemyManager:init(self.currentDay)
  self.counterHud = ListOrder.new(5, 5, 5)

  
  if self.already then return end
  self.already = true

  for i, v in ipairs(currentScene.save.knowCollects) do
    self:addCounter(v)
  end
  

end

function ocean:exit()
  self.light:exit() 
end

function ocean:update(delta)
  if self.startStatus == 0 then
    if self.startTimer >= 0.8 then
      self.startStatus = 1
    end
    self.startTimer = self.startTimer + delta
  elseif self.startStatus == 1 then
    Hud:addToHud(self.counterHud)
    Hud:addToHud(self.timeCounter)
    Hud.hidden = false
    self.startStatus = 2
  end


  self.water:update()
  if self.startStatus > 0 then self.enemyManager:update(delta) end
  self.dropManager:update(delta)
  self.counterHud:update(delta)
  
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

  if self.enemyManager.timeAlive >= self.currentDay.time and self.light.fuel > 0 then
    self:finished(true)
  end
end
 
function ocean:finished(beat)
  currentScene:finish({
    beated = beat,
    collects = self.collects,
    counters = self.counterList
  })
end

function ocean:draw()
  self.water:draw()

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

  love.graphics.setColor(0, 0, 0, 1-Tween.interpolate("expo", self.startTimer, 0.2, 0.4, "in"))
  love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)

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

function ocean:registerDrop(drop, x, y)
  if self.collects[drop] == nil then
    self:addCounter(drop)
    currentScene.save.knowCollects[#currentScene.save.knowCollects + 1] = drop
  end

  self.collects[drop] = self.collects[drop] + 1

  self.counterList[drop]:updateCounter(self.collects[drop])
  Hud:addToHud(self.visualCollect.new(self.counterList[drop].image, x, y, self.counterList[drop].posX, self.counterList[drop].posY))

end

function ocean:addCounter(drop)
  self.collects[drop] = 0
  local image = string.gsub("src/ocean/drops/$d/$dIcon.png", "$d", drop)
  self.counterList[drop] = self.counter.new(
    love.graphics.newImage(image)
  )
  self.counterHud:addToList(self.counterList["darkEssence"])
end

return ocean