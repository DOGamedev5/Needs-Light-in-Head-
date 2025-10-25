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
enemy.effectTexture = love.graphics.newImage("src/ocean/enemies/effect.png")

function enemy.new(x, y)
  local instance = setmetatable(EnemyClass.new(x, y, {
    speed = 20,
    health = 50
  }), {__index = enemy})
  instance.shape = love.physics.newCircleShape(14)
  instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
  instance.fixture:setCategory(1)
  instance.fixture:setMask(1)
  instance.fixture:setUserData(instance)
  instance.currentAnimation = 1
  instance.damageTimer = Timer.new()
  instance.currentState = 1
  
  instance.particleHandler = love.graphics.newParticleSystem(enemy.effectTexture, 1000)
  instance.particleHandler:setEmissionArea("normal", instance.width/4, instance.height/4)
  instance.particleHandler:setParticleLifetime(0.3, 0.9)
  instance.particleHandler:setLinearAcceleration(0, 10, 0, 30)
  instance.particleHandler:setColors(1, 1, 1, 0.8, 1, 1, 1, 0)
  instance.particleHandler:setRelativeRotation(true)
  instance.particleHandler:setSpread(3.14*2)
  instance.particleHandler:setSpinVariation(1)
  instance.particleHandler:setSpeed(30)

  return instance
end

function enemy:draw()
  self:drawHandler(self.animations[self.currentAnimation], self.texture)
  love.graphics.draw(self.particleHandler, self.body:getX(), self.body:getY(), 0, 2, 2)
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
  self:updateHandler(delta, x, y)
  self.body:setLinearVelocity(dirX * self.speed * debuf, dirY * self.speed * debuf)
  self.animations[self.currentAnimation]:update(delta)
  self.damageTimer:update(delta)
 
  self.particleHandler:update(delta)
end

function enemy:damaged(d)
  if self.toDie == true then
    return
  end
  
  self.scale = 1.2
  self.health = self.health - d
  self.currentState = 2
  self.damageTimer:clear()
  self.damageTimer:after(0.5, function ()
    self.currentState = 1
  end)

  if self.health <= 0 then
    self.toDie = true
  end
  self.particleHandler:emit(4)
end

function enemy:die()
  self.fixture:destroy()
  self.fixture:release()
  self.body:release()
  self.shape:release()
  self:removeToDraw()
end

return enemy  
