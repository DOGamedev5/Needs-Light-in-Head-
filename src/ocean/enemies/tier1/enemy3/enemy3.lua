local enemy = setmetatable({}, {__index = EnemyClass})

enemy.texture = love.graphics.newImage("src/ocean/enemies/tier1/enemy3/enemy3.png")
enemy.textureWidth = enemy.texture:getWidth()
enemy.width = 32
enemy.height = enemy.texture:getHeight() 
enemy.grid = anim8.newGrid(enemy.width, enemy.height, enemy.textureWidth, enemy.height)

enemy.sortOffset = enemy.height
enemy.toDie = false
enemy.effectTexture = love.graphics.newImage("src/ocean/enemies/effect.png")
enemy.offsetSpawn = 32
enemy.minimunDistance = 180
enemy.shieldRadius = 140

function enemy.new(x, y)
  local instance = setmetatable(EnemyClass.new(x, y, {
    speed = 10,
    health = 75,
    shape = love.physics.newCircleShape(16)
  }), {__index = enemy})
  instance.animations = {
    anim8.newAnimation(enemy.grid:getFrames("1-2", 1), 1.0),
    anim8.newAnimation(enemy.grid:getFrames("3-3", 1), 0.1, "pauseAtEnd"),
    anim8.newAnimation(enemy.grid:getFrames("4-5", 1), 1.0),
    anim8.newAnimation(enemy.grid:getFrames("6-6", 1), 0.1, "pauseAtEnd"),
    anim8.newAnimation(enemy.grid:getFrames("7-8", 1), 1.0),
    anim8.newAnimation(enemy.grid:getFrames("9-10", 1), 0.2, "pauseAtEnd"),
    anim8.newAnimation(enemy.grid:getFrames("11-14", 1), 0.12, "pauseAtEnd"),
  }

  instance.currentAnimation = 1
  instance.activaded = false
  instance.attacked = false
  instance.shieldAnimation = 0

  instance.particleHandler = love.graphics.newParticleSystem(enemy.effectTexture, 1000)
  instance.particleHandler:setEmissionArea("normal", instance.width/4, instance.height/4)
  instance.particleHandler:setParticleLifetime(0.3, 0.9)
  instance.particleHandler:setLinearAcceleration(0, 10, 0, 30)
  instance.particleHandler:setColors(1, 1, 1, 0.8, 1, 1, 1, 0)
  instance.particleHandler:setRelativeRotation(true)
  instance.particleHandler:setSpread(3.14*2)
  instance.particleHandler:setSpinVariation(1)
  instance.particleHandler:setSpeed(30)

  instance.shieldObj = BufferRegion.new(love.physics.newCircleShape(instance.shieldRadius), x, y, {"shield1"})
  
  instance.drop = {["darkEssence"] = 5}

  instance.stateMachine = StateMachine.new({
  	["IDLE"] = {
      owner = instance,
  		enter = function(self)
  			if instance.activaded then 
  				instance.currentAnimation = 3
  			else
          if instance.currentAnimation == 4 then
            instance.animations[4].status = "paused"
            instance.animations[2].timer = instance.animations[4].timer
            instance.animations[2].status = "playing"
          else
  				  instance.currentAnimation = 1
          end
  			end
  		end,
  		stateUpdate = function(self)
  			if instance.health <= 0 then
          return "DEAD"
        end
        if instance.attacked then
  				return "DAMAGED"
  			end
  			if #instance.enteredLights >= 1 then
  				return "SLOWED"
  			end
  		end,
  		update = function(self, delta)
  			if instance.currentAnimation == 2 and instance.animations[2].status == "paused" then
          instance.currentAnimation = 3
          instance.activaded = true
        end

        if instance:getDistance() < instance.minimunDistance then
          instance.body:setLinearVelocity(0, 0)
          if not instance.activaded and instance.currentAnimation ~= 2 then
            instance.currentAnimation = 2
            instance.animations[2]:pauseAtStart()
            instance.animations[2]:resume()
          end
  			else 
  				local dirX, dirY = instance:getDirection()
  				instance.body:setLinearVelocity(dirX * instance.speed, dirY * instance.speed)
  			end
  		end,
  		exit = function(self) end
  	},
  	["SLOWED"] = {
      owner = instance,
  		enter = function(self)
  			if instance.activaded then 
  				instance.currentAnimation = 5
  			else
  				instance.animations[4]:pauseAtStart()
          if instance.currentAnimation == 2 then
            instance.animations[2].status = "paused"
            instance.animations[4].timer = self.animations[2].timer
            instance.animations[4].status = "playing"
          end

  				instance.currentAnimation = 4
      		instance.animations[4]:resume()
  			end
  		end,
  		stateUpdate = function(self)
        if instance.health <= 0 then
          return "DEAD"
        end
  			if instance.attacked then
  				return "DAMAGED"
  			end
  			if #instance.enteredLights == 0 then
  				return "IDLE"
  			end
  		end,
  		update = function(self, delta)
        if instance.currentAnimation == 4 and instance.animations[4].status == "paused" then
          instance.currentAnimation = 5
          instance.activaded = true
        end
  			if instance:getDistance() < instance.minimunDistance then
  				instance.body:setLinearVelocity(0, 0)
  				if not instance.activaded and instance.currentAnimation ~= 4 then
            instance.currentAnimation = 4
            instance.animations[4]:pauseAtStart()
            instance.animations[4]:resume()
          end
  			else 
  				local dirX, dirY = instance:getDirection()
  				instance.body:setLinearVelocity(dirX * instance.speed, dirY * instance.speed)
  			end
  		end,
  		exit = function(self) end
  	},
    ["DAMAGED"] = {
      owner = instance,
      enter = function(self)
        instance.currentAnimation = 6
        instance.activaded = true
      end,
      stateUpdate = function(self)
        if instance.health <= 0 then
          return "DEAD"
        end

        if not instance.attacked then
          if #instance.enteredLights == 0 then
            return "IDLE"
          end
          
          return "SLOWED"
        end
      end,
      update = function(self, delta)
        instance.body:setLinearVelocity(0, 0)
      end,
      exit = function(self) end
    },
    ["DEAD"] = {
      owner = instance,
      enter = function(self)
        instance.currentAnimation = 7
        instance.animations[7]:pauseAtStart()
        instance.animations[7]:resume()
        
        instance.activaded = false
      end,
      stateUpdate = function(self)
        
      end,
      update = function(self, delta)
        instance.body:setLinearVelocity(0, 0)

        if instance.animations[7].status == "paused" then
          instance.toDie = true
        end
      end,
      exit = function(self) end
    }
  }, "IDLE")

  return instance
end

function enemy:draw()
  self:drawHandler(self.animations[self.currentAnimation], self.texture)
  love.graphics.draw(self.particleHandler, self.body:getX(), self.body:getY(), 0, 2, 2)
  if self.activaded then self:circleDraw() end
end

function enemy:update(delta)
  local dirX, dirY = self:getDirection()
  local debuf = 1
  self.flip = dirX < 0
  if self.activaded then self.shieldAnimation = self.shieldAnimation + delta end

  local x, y = self.body:getX() - self.width, self.body:getY() - self.height
  self:updateHandler(delta, x, y)
  self.stateMachine:update(delta)
  self.shieldObj:setPosition(self.body:getX(), self.body:getY())

  self.animations[self.currentAnimation]:update(delta)
 
  self.particleHandler:update(delta)
end

function enemy:damaged(d)
  self:damagedHandler(d)
 

  self.particleHandler:emit(6)
end 

function enemy:circleDraw()
  local x, y = self.body:getPosition()
  local rad = self.shieldRadius * (1-Tween.interpolate("expo", self.shieldAnimation, 0, 0.4, "out"))

  love.graphics.setColor(0.8, 0.1, 0.7, 0.1 + 0.3*(1-Tween.interpolate("sine", self.shieldAnimation, 0, 0.4, "in")))
  love.graphics.circle("fill", x, y, rad)
  love.graphics.setColor(0.9, 0.1, 0.2, 0.4)
  love.graphics.circle("line", x, y, rad)

end

return enemy