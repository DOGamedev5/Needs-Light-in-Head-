local light = {}

light.x = 0
light.y = 0
light.speed = 300
light.radius = 50
light.direction = 0
light.target = {x = 0, y = 0}
light.reference = "light"
light.sortOffset = light.radius
light.entered = {}
light.attackHandler = nil

function light:init()
  self.x, self.y = toGame(lastMousePosition.x, lastMousePosition.y)
  self.timer = Timer.new()
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

  self.damage = 20
  self.timeToDamage = 1
  self:start()
end

function light:start()
  if self.attackHandler then
    Timer.cancel(self.attackHandler)
  end
  self.attackHandler = self.timer:every(self.timeToDamage, function ()
    self:attack()
  end)
end

function light:beginContact(otherFixture)
  local otherBody = otherFixture:getBody()
  if otherBody:getUserData() == "enemy" then
    table.insert(self.entered, 1, otherFixture)
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
  self.timer = nil
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

  self.timer:update(delta)
end

function light:draw()
  love.graphics.setColor(236*2/255, 201*2/255, 64*2/255, 0.25)
  love.graphics.circle("fill", self.x, self.y, self.radius)
  love.graphics.setColor(236*2/255, 201*2/255, 64*2/255, 0.2)

  local poligon = self:rayLight()
  love.graphics.polygon("fill", unpack(poligon))
  
  love.graphics.setColor(1, 1, 1, 0.2)
  love.graphics.circle("line", self.x, self.y, self.radius)
  love.graphics.polygon("line", unpack(poligon))
end

function light:rayLight()
  local poligon = {}
  poligon[1] = windowSize.x/2
  poligon[2] = windowSize.y/2 - 88
  
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
  for i, e in ipairs(self.entered) do
    local enemy = e:getUserData()
    if enemy.toDie then
      tools.erase(self.entered, e)
    elseif enemy.damaged then
      enemy:damaged(self.damage)
    end
  end
end

return light
