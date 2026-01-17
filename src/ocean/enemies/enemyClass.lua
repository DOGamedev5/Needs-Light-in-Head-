EnemyClass = {}

EnemyClass.toDraw = {}

function EnemyClass.new(x, y, prototype)
  local instance = setmetatable({}, {__index == EnemyClass})
  instance.body = love.physics.newBody(World, x, y, "dynamic")
  instance.body:setUserData("enemy")
  
  instance.shape = prototype.shape
  instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
  instance.fixture:setCategory(1)
  instance.fixture:setMask(1)
  instance.fixture:setUserData(instance)
  instance.damageTimer = Timer.new()
  instance.currentState = 1
  instance.attackTime = 1
  
  instance.enteredLights = {}
  instance.attacking = {}
  instance.drawList = false
  instance.toDie = false
  instance.flip = false
  instance.scale = 1
  instance.speed = prototype.speed or 20
  instance.health = prototype.health or 50
  return instance
end

function EnemyClass:beginContact(otherFixture)
  local otherBody = otherFixture:getBody()
  local data = otherBody:getUserData() 
  if data == "light" then
    table.insert(self.enteredLights, 1, otherFixture)
  elseif data == "lightHouse" then
    table.insert(self.attacking, 1, otherFixture)
  end
end

function EnemyClass:afterContact(otherFixture)
  local otherBody = otherFixture:getBody()
  local data = otherBody:getUserData()
  if data == "light" then
    tools.erase(self.enteredLights, otherFixture)
  end
end

function EnemyClass:addToDraw()
  table.insert(EnemyClass.toDraw, 1, self)
end

function EnemyClass:removeToDraw()
  tools.erase(EnemyClass.toDraw, self)
end

function EnemyClass:updateHandler(delta, x, y)
  self.scale = tools.lerp(self.scale, 1, delta*4)
  self:canDrawDetect(x, y)
end

function EnemyClass:drawHandler(animation, texture)
  local flip = 1
  if self.flip then
    flip = -1
  end
  local x, y = self.body:getX() - self.width* flip, self.body:getY() - self.height
  local ex, ey = self.body:getX() - self.width* flip*self.scale, self.body:getY() - self.height*self.scale

  --self.animations[self.currentAnimation]:draw(self.texture, x, y, 0, 2*flip, 2)
  animation:draw(texture, x, y, 0, 2*flip, 2)
  if #self.enteredLights > 0 then
    love.graphics.setBlendMode("add")
    animation:draw(texture, ex, ey, 0, 2*flip*self.scale, 2)
    animation:draw(texture, ex, ey, 0, 2*flip*self.scale, 2)
    love.graphics.setBlendMode("alpha")
  end
end

function EnemyClass:canDrawDetect(x, y)
  if tools.AABB.detect(x, y, self.width*2, self.height*2, 0, 0, windowSize.x, windowSize.y) then
    if not self.drawList then
      self:addToDraw()
      self.drawList = true
    end
  elseif self.drawList then
    self:removeToDraw()
  end
end

function EnemyClass:remove()
  self.fixture:destroy()
  self.fixture:release()
  self.body:release()
  self.shape:release()
  self:removeToDraw()
end

function EnemyClass:getDirection( )
  return Vector.normalize(windowSize.x/2 - self.body:getX(), windowSize.y/2 - self.body:getY())
end