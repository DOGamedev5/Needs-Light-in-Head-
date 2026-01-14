local ocean = {}

ocean.waterShader = love.graphics.newShader("src/ocean/water.glsl")
ocean.waterTexture = love.graphics.newImage("assets/wave.png")
ocean.waterNormal = love.graphics.newImage("assets/normalTest.png")
ocean.waterGlow = love.graphics.newImage("assets/glowEffect.png")
ocean.waterTexture:setWrap("repeat", "repeat")
ocean.waterNormal:setWrap("repeat", "repeat")
ocean.waterGlow:setWrap("repeat", "repeat")
ocean.waterShader:send("overColor", {9/255*1.2, 18/255*1.2, 59/255*1.2, 0.75})
ocean.waterShader:send("normalMap", ocean.waterNormal)
ocean.waterShader:send("glowMap", ocean.waterGlow)

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
    local wid = fonts.normal:getWidth(text)*scale

    love.graphics.print(text, windowSize.x - wid - 10, 10, 0, scale, scale)

  end
}

function ocean:init()
  
  self.collects = {}
  self.light:init()
  self.lighthouse:init(self.light)
  
  self.currentDay = self.dayManager:getCurrentDayData(currentScene.save.currentDay)
  self.enemyManager:init(self.currentDay)
  self.counterHud = ListOrder.new(5, 5, 5)

  Hud:addToHud(self.counterHud)
  Hud:addToHud(self.timeCounter)
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

  self.waterShader:send("time", love.timer.getTime())
  self.enemyManager:update(delta)
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

  love.graphics.setShader(self.waterShader)
    love.graphics.setColor(3/255, 2/255, 6/255)
    love.graphics.draw(self.waterTexture, 0, 0, 0, windowSize.x/64, windowSize.y/64)

  
  love.graphics.setShader()

  love.graphics.setColor(1, 1, 1)
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