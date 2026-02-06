EnemyClass = {}

EnemyClass.toDraw = {}

function EnemyClass.new(x, y, prototype)
  local instance = setmetatable({}, {__index == EnemyClass})
  instance.body = love.physics.newBody(World, x, y, "dynamic")
  instance.body:setUserData("enemy")
  instance.attacked = false
  
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
  instance.buffs = {
    shield1 = 0
  }
  instance.enteredBuffers = {

  }

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
  elseif data == "buffer" then
    table.insert(self.enteredBuffers, 1, otherFixture)
    for i, v in ipairs(otherFixture:getUserData().buffers) do
      if self.buffs[v] == nil then self.buffs[v] = 0 end 
      self.buffs[v] = self.buffs[v] + 1
    end
  end
end

function EnemyClass:afterContact(otherFixture)
  local otherBody = otherFixture:getBody()
  local data = otherBody:getUserData()
  if data == "light" then
    tools.erase(self.enteredLights, otherFixture)
  elseif data == "buffer" then
    tools.erase(self.enteredBuffers, otherFixture)

    for i, v in ipairs(otherFixture:getUserData().buffers) do
      self.buffs[v] = self.buffs[v] - 1
    end
  end
end

function EnemyClass:addToDraw()
  table.insert(EnemyClass.toDraw, 1, self)
end

function EnemyClass:removeToDraw()
  tools.erase(EnemyClass.toDraw, self)
end

function EnemyClass:damagedHandler(d)
   if self.health <= 0 then
    return
  end

  self.scale = 1.2
  if self.buffs.shield1 >= 1 then
    d = d * 0.4
  end

  self.health = self.health - d
  self.attacked = true
  self.damageTimer:clear()

  if self.health > 0 then
    self.damageTimer:after(0.5, function ()
      self.attacked = false
    end)
  end
end

function EnemyClass:updateHandler(delta, x, y)
  self.damageTimer:update(delta)
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
  local distance = self:getDistanceAxis()
  return Vector.normalize(distance[1], distance[2])
end

function EnemyClass:getDistanceAxis( )
  return {windowSize.x/2 - self.body:getX(), windowSize.y/2 - self.body:getY()}
end

function EnemyClass:getDistance()
  local distance = self:getDistanceAxis()
  return (math.abs(distance[1])^2 + math.abs(distance[2])^2)^0.5
end

function EnemyClass:die()
  for k,v in pairs(self.drop) do
    local amount = math.floor(UpgradeManager:apply("drop", k, v))
    for i=1, amount do
      currentScene.ocean.dropManager:addDrop(k, self.body:getX(), self.body:getY(), love.math.random(30, 50))
    end
  end

  self.fixture:destroy()
  self.fixture:release()
  self.body:release()
  self.shape:release()
  self:removeToDraw()
end
