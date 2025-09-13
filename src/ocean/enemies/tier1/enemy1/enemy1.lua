local enemy = setmetatable({}, {__index = EnemyClass})

enemy.texture = love.graphics.newImage("src/ocean/enemies/tier1/enemy1/enemy1.png")
enemy.textureWidth = enemy.texture:getWidth()
enemy.width = enemy.textureWidth / 6
enemy.height = enemy.texture:getHeight() 
enemy.grid = anim8.newGrid(enemy.width, enemy.height, enemy.textureWidth, enemy.height)
enemy.animations = {
  anim8.newAnimation(enemy.grid:getFrames("1-2", 1), 1.4),
  anim8.newAnimation(enemy.grid:getFrames("3-4", 1), 1.4),
  anim8.newAnimation(enemy.grid:getFrames("5-6", 1), 0.2, "pauseAtEnd")
}

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
  instance.currentAnimation = 1
  instance.damageTimer = Timer.new()
  instance.currentState = 1
  instance.flip = false

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
  local flip = 1
  if self.flip then
    flip = -1
  end
  local x, y = self.body:getX() - self.width* flip, self.body:getY() - self.height

  self.animations[self.currentAnimation]:draw(self.texture, x, y, 0, 2*flip, 2)
  if #self.enteredLights > 0 then
    love.graphics.setBlendMode("add")
    self.animations[self.currentAnimation]:draw(self.texture, x, y, 0, 2*flip, 2)
    self.animations[self.currentAnimation]:draw(self.texture, x, y, 0, 2*flip, 2)
    love.graphics.setBlendMode("alpha")
  end
end

function enemy:update(delta)
  local dirX, dirY = Vector.normalize(windowSize.x/2 - self.body:getX(), windowSize.y/2 - self.body:getY())
  local debuf = 1

  self.flip = dirX < 0

  if self.currentState == 2 then
    debuf = 0
    if self.currentAnimation ~= 3 then
      self.currentAnimation = 3
      self.animations[3]:pauseAtStart()
      self.animations[3]:resume()
    end
  
  elseif #self.enteredLights >= 1 then
    debuf = 0.5
    self.currentAnimation = 2  
  
  else
    self.currentAnimation = 1
  
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
  self.animations[self.currentAnimation]:update(delta)
  self.damageTimer:update(delta)
end

function enemy:damaged(d)
  if self.toDie == true then
    return
  end
  
  self.health = self.health - d
  self.currentState = 2
  self.damageTimer:clear()
  self.damageTimer:after(0.5, function ()
    self.currentState = 1
  end)

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
