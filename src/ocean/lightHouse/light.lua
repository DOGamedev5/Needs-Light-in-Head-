local light = {}

light.x = 0
light.y = 0
light.direction = 0
light.target = {x = 0, y = 0}
light.reference = "light"
light.sortOffset = light.radius
light.entered = {}
light.attackHandler = nil
light.force = 1
light.sfx = love.audio.newSource("src/ocean/lightHouse/attackEffect.wav", "static")

light.hud = {
  attackBarr = LightBarr.new(100)
}
light.fuelBarr = require("src.ocean.lightHouse.fuelBarr")


function light:init()
  self.radius = UpgradeManager:apply("light", "size", 50)
  self.speed = UpgradeManager:apply("light", "speed", 100)

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

  self.damage = UpgradeManager:apply("light", "damage", 20)

  self.timeToDamage = 1
  self.fuelMax = UpgradeManager:apply("light", "oil", 80)
  self.fuel = self.fuelMax
  
  self.attackTimerMax = 2
  self.attackTimer = self.attackTimerMax

  self.fuelBarr:setup(self)
  Hud:addToHud(self.hud.attackBarr)
  Hud:addToHud(self.fuelBarr)

  self:start()
end

function light:start()
  self.attackTimer = self.attackTimerMax
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

function light:exit()
  self.fixture:destroy()
  self.fixture:release()
  self.body:release()
  self.shape:release()
  Hud:remove(self.hud.attackBarr)
end

function light:update(delta)
  local distX, distY = self.target.x - self.body:getX(), self.target.y - self.body:getY()
  local dirX, dirY = Vector.normalize(distX, distY)
  
  if self.body:getX() ~= self.target.x or self.body:getY() ~= self.target.y then
    local oldX, oldY = self.body:getPosition()--self.x, self.y 
    
    local speedX = dirX*self.speed
    if math.abs(distX) < math.abs(speedX)*delta then
      speedX = distX
    end
    local speedY = dirY*self.speed
    if math.abs(distY) < math.abs(speedY)*delta then
      speedY = distY
    end

    self.body:setLinearVelocity(speedX, speedY)

    if ((oldX < self.target.x and self.x > self.target.x) or (oldX > self.target.x and self.x < self.target.x)) then 
      self.x = tools.lerp(oldX, self.target.x, delta*0.5)
      self.body:setX(self.x)

    end
    if ((oldY < self.target.y and self.y > self.target.y) or (oldY > self.target.y and self.y < self.target.y)) then
      self.y = tools.lerp(oldY, self.target.y, delta*0.5)
      self.body:setY(self.y)
    end
  else
    self.body:setLinearVelocity(0, 0)
  end
  
  self.x, self.y = self.body:getPosition()
  
  if self.fuel > 0 then
    self.force = tools.lerp(self.force, 1, delta*3)
    self.hud.attackBarr:updateFuel(100 - (self.attackTimer / self.attackTimerMax * 100))
  
    self.attackTimer = self.attackTimer - delta

    if self.attackTimer <= 0 then
      self.attackTimer = self.attackTimerMax
      self:attack()
    end
    self.fuel = self.fuel - UpgradeManager:apply("light", "fuelUse", delta*4)
    if self.fuel <= 0 then
      self.fuel = 0
      Hud:remove(self.hud.attackBarr)
      self.fixture:setCategory(1)
   end
  end
  
end

function light:draw()
  if self.fuel > 0 then
    love.graphics.setColor(236*2/255, 201*2/255, 64*2/255, 0.25*self.force)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.setColor(236*2/255, 201*2/255, 64*2/255, 0.2*self.force)

    local poligon = self:rayLight()
    love.graphics.polygon("fill", unpack(poligon))
  
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.circle("line", self.x, self.y, self.radius)
    love.graphics.polygon("line", unpack(poligon))
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

function light:attack()
  self.force = 3
  
  if #self.entered == 0 then
    self.force = 1
  else
    
    self.sfx:stop()
    local p = love.math.random(60, 85)
    self.sfx:setPitch(p/100)
    self.sfx:setVolume(0.3)
    self.sfx:play()
 
  end
  for i, e in ipairs(self.entered) do
    local enemy = e:getUserData()
    if enemy.toDie then
      tools.erase(self.entered, e)
    elseif enemy.damaged then
      enemy:damaged(self.damage)
    end
  end
end

function light:damageFuel(dmg)
  self.fuel = self.fuel - dmg
  if self.fuel < 0 then
    self.fuel = 0
    Hud:remove(self.hud.attackBarr)
    self.fixture:setCategory(1)
  end
end

return light
