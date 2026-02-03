local enemy = setmetatable({}, {__index = EnemyClass})

enemy.texture = love.graphics.newImage("src/ocean/enemies/tier1/enemy2/enemy2.png")
enemy.textureWidth = enemy.texture:getWidth()
enemy.width = 48
enemy.height = enemy.texture:getHeight() 
enemy.grid = anim8.newGrid(enemy.width, enemy.height, enemy.textureWidth, enemy.height)

enemy.sortOffset = enemy.height
enemy.toDie = false
enemy.effectTexture = love.graphics.newImage("src/ocean/enemies/effect.png")
enemy.offsetSpawn = 24

function enemy.new(x, y)
  local instance = setmetatable(EnemyClass.new(x, y, {
    speed = 35,
    health = 30,
    shape = love.physics.newCircleShape(14)
  }), {__index = enemy})
  instance.animations = {
    anim8.newAnimation(enemy.grid:getFrames("1-2", 1), 1.0),
    anim8.newAnimation(enemy.grid:getFrames("3-4", 1), 1.0),
    anim8.newAnimation(enemy.grid:getFrames("5-6", 1), 0.2, "pauseAtEnd"),
    anim8.newAnimation(enemy.grid:getFrames("7-10", 1), {0.03, 0.05, 0.05, 0.05}, "pauseAtEnd"),
    anim8.newAnimation(enemy.grid:getFrames("11-14", 1), 0.15, "pauseAtEnd"),
  }

  instance.currentAnimation = 1

  instance.particleHandler = love.graphics.newParticleSystem(enemy.effectTexture, 1000)
  instance.particleHandler:setEmissionArea("normal", instance.width/4, instance.height/4)
  instance.particleHandler:setParticleLifetime(0.3, 0.9)
  instance.particleHandler:setLinearAcceleration(0, 10, 0, 30)
  instance.particleHandler:setColors(1, 1, 1, 0.8, 1, 1, 1, 0)
  instance.particleHandler:setRelativeRotation(true)
  instance.particleHandler:setSpread(3.14*2)
  instance.particleHandler:setSpinVariation(1)
  instance.particleHandler:setSpeed(30)

  instance.drop = {["darkEssence"] = 3}

  return instance
end

function enemy:draw()
  self:drawHandler(self.animations[self.currentAnimation], self.texture)
  love.graphics.draw(self.particleHandler, self.body:getX(), self.body:getY(), 0, 2, 2)
end

function enemy:update(delta)
  local dirX, dirY = self:getDirection()
  local debuf = 1


  self.flip = dirX < 0
  if self.health <= 0 then -- dying State
    if self.currentAnimation ~= 5 then
      self.currentAnimation = 5
      self.animations[5]:pauseAtStart()
      self.animations[5]:resume()

    elseif self.animations[5].status == "paused" then
      self.toDie = true
    end

  elseif self.currentState == 3 then -- attacking State
    if self.currentAnimation ~= 4 then
      self.currentAnimation = 4
      self.animations[4]:pauseAtStart()
      self.animations[4]:resume()

    elseif self.animations[4].status == "paused" then
      self.attackTime = 1
      self.currentState = 1

      for _, o in ipairs(self.attacking) do
        o:getUserData():damage(3)  
      end
    end

  elseif self.attacked then --attacked State
    debuf = 0
    if self.currentAnimation ~= 3 then
      self.currentAnimation = 3
      self.animations[3]:pauseAtStart()
      self.animations[3]:resume()
    end
  
  elseif #self.enteredLights >= 1 then -- slowed State
    debuf = 0.5
    self.currentAnimation = 2  
  
  else -- Normal State
    self.currentAnimation = 1

  end

  local x, y = self.body:getX() - self.width, self.body:getY() - self.height
  self:updateHandler(delta, x, y)

  if self.health <= 0 then
    self.body:setLinearVelocity(0, 0)
  elseif #self.attacking == 0 then
    self.body:setLinearVelocity(dirX * self.speed * debuf, dirY * self.speed * debuf)
  else
    self.body:setLinearVelocity(0, 0)
    if #self.enteredLights == 0 then
      self.attackTime = self.attackTime - delta
      if self.attackTime <= 0 then
        self.attackTime = 0
        self.currentState = 3
      end
    end
  end

  self.animations[self.currentAnimation]:update(delta)
 
  self.particleHandler:update(delta)
end

function enemy:damaged(d)
  self:damagedHandler(d)

  self.particleHandler:emit(4)
end 

return enemy