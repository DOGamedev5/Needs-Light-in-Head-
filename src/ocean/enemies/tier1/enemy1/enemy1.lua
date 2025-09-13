local enemy = setmetatable({}, {__index = EnemyClass})

enemy.texture = love.graphics.newImage("src/ocean/enemies/tier1/enemy1/enemy1.png")
enemy.width, enemy.height = enemy.texture:getDimensions()
enemy.sortOffset = enemy.height
enemy.toDie = false

function enemy.new(x, y)
  local instance = setmetatable({}, {__index = enemy})
  instance.body = love.physics.newBody(World, x, y, "dynamic")
  instance.shape = love.physics.newCircleShape(14)
  instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
  instance.fixture:setCategory(1)
  instance.fixture:setMask(1)
  instance.fixture:setUserData(instance)
  instance.body:setUserData("enemy")
  instance.speed = 20
  instance.enteredLights = {}
  instance.health = 50
  instance.drawList = false
  instance.toDie = false
  return instance
end

function enemy:beginContact(otherFixture)
  local otherBody = otherFixture:getBody()
  if otherBody:getUserData() == "light" then
    table.insert(self.enteredLights, 1, otherFixture)
  end
end

function enemy:afterContact(otherFixture)
  local otherBody = otherFixture:getBody()
  if otherBody:getUserData() == "light" then
    tools.erase(self.enteredLights, otherFixture)
  end
end

function enemy:draw()
  local x, y = self.body:getX() - self.width, self.body:getY() - self.height
  love.graphics.draw(self.texture, x, y, 0, 2, 2)
  if #self.enteredLights > 0 then
    love.graphics.setBlendMode("add")
    love.graphics.draw(self.texture, x, y, 0, 2, 2)
    love.graphics.draw(self.texture, x, y, 0, 2, 2)
    love.graphics.setBlendMode("alpha")
  end
end

function enemy:update(delta)
  local dirX, dirY = Vector.normalize(windowSize.x/2 - self.body:getX(), windowSize.y/2 - self.body:getY())
  local debuf = 1
  if #self.enteredLights >= 1 then
    debuf = 0.3
  end
  local x, y = self.body:getX() - self.width, self.body:getY() - self.height

  if tools.AABB.detect(x, y, self.width*2, self.height*2, 0, 0, windowSize.x, windowSize.y) then
    if not self.drawList then
      self:addToDraw()
      self.drawList = true
    end
  elseif self.drawList then
    self:removeToDraw()
  end

  self.body:setLinearVelocity(dirX * self.speed * debuf, dirY * self.speed * debuf)
end

function enemy:damaged(d)
  if self.toDie == true then
    return
  end
  
  self.health = self.health - d
  if self.health <= 0 then
    self.toDie = true
  end
end

function enemy:die()
  self.fixture:destroy()
  self.fixture:release()
  self.body:release()
  self.shape:release()
  self:removeToDraw()
end

return enemy
