local light = {}

light.x = 0
light.y = 0
light.direction = 0
light.target = {x = 0, y = 0}
light.reference = "light"
light.sortOffset = 0
light.entered = {}
light.attackHandler = nil
light.force = 1
light.sfx = love.audio.newSource("src/ocean/lightHouse/attackEffect.wav", "static")

light.hud = {
  attackBarr = LightBarr.new(100)
}
light.fuelBarr = require("src.ocean.lightHouse.fuelBarr")


function light:init()
  -- [[status upgradeds setup]]
  self.radius = UpgradeManager:apply("light", "size", 30)
  self.speed = UpgradeManager:apply("light", "speed", 150)
  self.fuelUse = UpgradeManager:apply("light", "fuelUse", 10) 
  self.damage = UpgradeManager:apply("light", "damage", 20)
  self.fuelMax = UpgradeManager:apply("light", "oil", 100)
  self.attackTimerMax = UpgradeManager:apply("light", "attackCooldown", 2)

  -- [[status set]]
  self.fuel = self.fuelMax
  self.attackTimer = self.attackTimerMax
  self.sortOffset = self.radius

  self.fuelBarr:setup(self)

  -- [[setup physics and systems]]

  self.x, self.y = toGame(lastMousePosition.x, lastMousePosition.y)
  self.target.x, self.target.y = self.x, self.y
  self.body = love.physics.newBody(World, self.x, self.y, "dynamic")
  self.shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setSensor(true)
  self.fixture:setCategory(2)
  self.fixture:setUserData(self)
  self.body:isFixedRotation(true)
  self.body:setUserData("light")

  self.entered = {}

  Hud:addToHud(self.hud.attackBarr)
  Hud:addToHud(self.fuelBarr)
end


function light:beginContact(otherFixture)
  local otherBody = otherFixture:getBody()
  local data = otherBody:getUserData()
  if data == "enemy" then
    table.insert(self.entered, 1, otherFixture)
  elseif data == "drop" then
    local obj = otherFixture:getUserData()
    obj.toCollect = true
  end
end

function light:afterContact(otherFixture)
  local otherBody = otherFixture:getBody()
  if otherBody:getUserData() == "enemy" then
    tools.erase(self.entered, otherFixture)
  end
end

-- [[Ligth Logic functions]]

function light:damageFuel(dmg)
  self.fuel = self.fuel - dmg
  local sx, sy = Vector.normalize(love.math.random(-2, 2), love.math.random(-2, 2))

  screenShake.x = sx*2
  screenShake.y = sy*2
  if self.fuel < 0 then
    self.fuel = 0
    Hud:remove(self.hud.attackBarr)
    self.fixture:setCategory(1)
  end
end

function light:refil(amount)
  self.fuel = math.min(self.fuel + amount, self.fuelMax)
end

function light:physics(delta)
  local distX, distY = self.target.x - self.body:getX(), self.target.y - self.body:getY()
  local dirX, dirY = Vector.normalize(distX, distY)
  local speedX = 0
  local speedY = 0

  if self.body:getX() ~= self.target.x or self.body:getY() ~= self.target.y then
    local oldX, oldY = self.body:getPosition()--self.x, self.y 
    speedX = dirX*self.speed
    speedY = dirY*self.speed

    if math.abs(distX) < math.abs(speedX)*delta then speedX = distX end
    if math.abs(distY) < math.abs(speedY)*delta then speedY = distY end

    if ((oldX < self.target.x and self.x > self.target.x) or (oldX > self.target.x and self.x < self.target.x)) then 
      self.body:setX(tools.lerp(oldX, self.target.x, delta*0.5))
    end

    if ((oldY < self.target.y and self.y > self.target.y) or (oldY > self.target.y and self.y < self.target.y)) then
      self.body:setY(tools.lerp(oldY, self.target.y, delta*0.5))
    end
  end

  self.body:setLinearVelocity(speedX, speedY)

  self.x, self.y = self.body:getPosition()
end

function light:attack()
  self.force = 3
  
  if #self.entered == 0 then
    self.force = 1
  else
    
    self.sfx:stop()
    local p = love.math.random(600, 850)/10
    self.sfx:setPitch(p/100)
    self.sfx:setVolume(0.3)
    self.sfx:play()
 
  end
  if #self.entered == 0 then return end

  self.fuel = self.fuel - self.fuelUse

  for i, object in ipairs(self.entered) do
    local enemy = object:getUserData()

    if enemy.toDie then tools.erase(self.entered, object)

    elseif enemy.damaged then
      enemy:damaged(self.damage)
      if enemy.toDie then tools.erase(self.entered, object) end

    end
  end
end

function light:fuelLogic(delta)
  if self.fuel > 0 then
    self.force = tools.lerp(self.force, 1, delta*3)
    self.hud.attackBarr:updateFuel(100 - (self.attackTimer / self.attackTimerMax * 100))
  
    self.attackTimer = self.attackTimer - delta

    if self.attackTimer <= 0 then
      self.attackTimer = self.attackTimerMax
      self:attack()
    end

    --self.fuel = self.fuel - UpgradeManager:apply("light", "fuelUse", delta*5)
    
    if self.fuel <= 0 then
      self.fuel = 0
      Hud:remove(self.hud.attackBarr)
      self.fixture:setCategory(1)
    end
  end
end

function light:update(delta)
  self:physics(delta)  
  self:fuelLogic(delta)
end

-- [[draw functions]]

function light:draw()
  if self.fuel > 0 then
    love.graphics.setBlendMode("add")
    love.graphics.setColor(236*2/255*self.force, 201*2/255*self.force, 64*2/255*self.force, 0.3*self.force)
    love.graphics.circle("fill", self.x, self.y, self.radius)

    local poligon = self:rayLight()
    love.graphics.setColor(236/255*self.force, 201/255*self.force, 64/255*self.force, 0.4*self.force)
    love.graphics.polygon("fill", unpack(poligon))
  
    love.graphics.setBlendMode("alpha")
  end
  
end

function light:rayLight()
  local poligon = {}
  poligon[1] = windowSize.x/2
  poligon[2] = windowSize.y/2 - 100
  
  --local angleMin = ((36-2) * math.pi)/36
  local dir = math.atan2(poligon[2] - self.y, poligon[1] - self.x) + math.pi
  local circle = {}

  for i=-8, 27, 1 do
    local newDir = (dir + math.pi*3/4) - (i/18*math.pi)
    circle[1+(i+8)*2] = self.x + ((math.cos(newDir))*self.radius)
    circle[2+(i+8)*2] = self.y + ((math.sin(newDir))*self.radius)
  end
  if Vector.len(self.x - poligon[1], self.y - poligon[2]) <= self.radius then
    return circle
  end
  local offset = 0
  
  for i = 10+offset, (16-offset)*2, 1 do
    poligon[3+(i-(10+offset))*2] = circle[1 + (i*2)]
    poligon[4+(i-(10+offset))*2] = circle[2 + (i*2)]
  end
  
  return poligon
end

function light:mouseMoved(x, y, dx, dy, touch)
  if x < pading.x or x > windowSize.x*gameScale+pading.x or y < pading.y or y > windowSize.y*gameScale+pading.y then
    return
  end

  self.target.x, self.target.y = toGame(x, y)
end

function light:exit()
  self.fixture:destroy()
  self.fixture:release()
  self.body:destroy()
  self.body:release()
  self.shape:release()
  Hud:remove(self.hud.attackBarr)
end

return light
