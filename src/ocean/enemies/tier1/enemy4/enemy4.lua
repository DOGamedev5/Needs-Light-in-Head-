local enemy = setmetatable({}, {__index = EnemyClass})

enemy.texture = love.graphics.newImage("src/ocean/enemies/tier1/enemy4/enemy4.png")
enemy.textureWidth = enemy.texture:getWidth()
enemy.width = 32
enemy.height = enemy.texture:getHeight() 
enemy.grid = anim8.newGrid(enemy.width, enemy.height, enemy.textureWidth, enemy.height)

enemy.sortOffset = 32
enemy.toDie = false
enemy.effectTexture = love.graphics.newImage("src/ocean/enemies/effect.png")
enemy.offsetSpawn = 32
enemy.minimunDistance = 220

enemy.drop = {[1] = 2, [2] = 4}

local chargeTimerMax = 4
local attackCooldownMax = 2.5
local projectile = require("src.ocean.enemies.tier1.enemy4.projectile")

local animations = {
  anim8.newAnimation(enemy.grid:getFrames("1-2", 1), 1.0),
  anim8.newAnimation(enemy.grid:getFrames("3-4", 1), 1.0),
  anim8.newAnimation(enemy.grid:getFrames("5-6", 1), 0.2, "pauseAtEnd"),
  anim8.newAnimation(enemy.grid:getFrames("8-9", 1), 1.0),
  anim8.newAnimation(enemy.grid:getFrames("10-11", 1), 1.0),
  anim8.newAnimation(enemy.grid:getFrames("12-13", 1), 0.2, "pauseAtEnd"),
  anim8.newAnimation(enemy.grid:getFrames("7-7", 1), 0.2, "pauseAtEnd"),
  anim8.newAnimation(enemy.grid:getFrames("14-15", 1), {0.2, 0.05}, "pauseAtEnd"),
  anim8.newAnimation(enemy.grid:getFrames("16-17", 1), {0.2, 0.05}, "pauseAtEnd"),
  anim8.newAnimation(enemy.grid:getFrames("18-21", 1), 0.12, "pauseAtEnd"),
}

local particleHandler = love.graphics.newParticleSystem(enemy.effectTexture, 1000)
particleHandler:setEmissionArea("normal", enemy.width/4, enemy.height/4)
particleHandler:setParticleLifetime(0.3, 0.9)
particleHandler:setLinearAcceleration(0, 10, 0, 30)
particleHandler:setColors(1, 1, 1, 0.8, 1, 1, 1, 0)
particleHandler:setRelativeRotation(true)
particleHandler:setSpread(3.14*2)
particleHandler:setSpinVariation(1)
particleHandler:setSpeed(30)

function enemy.new(x, y)
  local instance = setmetatable(EnemyClass.new(x, y, {
    speed = 20,
    health = 50,
    shape = love.physics.newCircleShape(16)
  }), {__index = enemy})
  instance.animations = {
    animations[1]:clone(),
    animations[2]:clone(),
    animations[3]:clone(),
    animations[4]:clone(),
    animations[5]:clone(),
    animations[6]:clone(),
    animations[7]:clone(),
    animations[8]:clone(),
    animations[9]:clone(),
    animations[10]:clone(),
  }

  instance.currentAnimation = 1
  instance.particleHandler = particleHandler:clone()

  instance.charged = false
  instance.chargeTimer = chargeTimerMax
  instance.attackCooldown = attackCooldownMax

  instance.stateMachine = StateMachine.new({
  	["IDLE"] = {
      owner = instance,
  		enter = function(self)
        if instance.charged then
          instance.currentAnimation = 4
        else
          instance.currentAnimation = 1
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
        if instance.attackCooldown <= 0 and instance.charged then
          return "ATTACKING"
        end
  		end,
  		update = function(self, delta)
        if instance.currentAnimation == 7 and instance.animations[7].status == "paused" then
          instance.currentAnimation = 4
        end
        instance.body:setLinearVelocity(0, 0)
        
        if instance:getDistance() > instance.minimunDistance then
  				local dirX, dirY = instance:getDirection()
  				instance.body:setLinearVelocity(dirX * instance.speed, dirY * instance.speed)
        elseif instance.chargeTimer <= 0 then
          instance.charged = true
          instance.chargeTimer = chargeTimerMax
          instance.attackCooldown = attackCooldownMax
          instance.currentAnimation = 7
          instance.animations[7]:pauseAtStart()
          instance.animations[7]:resume()

        elseif instance.charged == false then
          instance.chargeTimer = instance.chargeTimer - delta
        else
          instance.attackCooldown = instance.attackCooldown - delta
        end

  		end,
  		exit = function(self) end
  	},
  	["SLOWED"] = {
      owner = instance,
  		enter = function(self)
  			if instance.charged then
          instance.currentAnimation = 5
        else
          instance.currentAnimation = 2
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
        if instance.attackCooldown <= 0 and instance.charged then
          return "ATTACKING"
        end
  		end,
  		update = function(self, delta)
  			if instance:getDistance() <= instance.minimunDistance then
          if instance.charged then
            instance.attackCooldown = instance.attackCooldown - delta
          end

  				instance.body:setLinearVelocity(0, 0)
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
        if instance.charged then
          instance.currentAnimation = 6
        else
          instance.currentAnimation = 3
        end
        instance.animations[instance.currentAnimation]:pauseAtStart()
        instance.animations[instance.currentAnimation]:resume()

        instance.chargeTimer = chargeTimerMax
        instance.charged = false
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
        instance.currentAnimation = 10
      
      end,
      stateUpdate = function(self)
        
      end,
      update = function(self, delta)
        instance.body:setLinearVelocity(0, 0)

        if instance.animations[10].status == "paused" then
          instance.toDie = true
        end
      end,
      exit = function(self) end
    },
    ["ATTACKING"] = {
      owner = instance,
      enter = function(self)
        if #instance.enteredLights > 0 then
          instance.currentAnimation = 9
        else
          instance.currentAnimation = 8
        end
        instance.animations[instance.currentAnimation]:pauseAtStart()
        instance.animations[instance.currentAnimation]:resume()
        instance.charged = false
      end,
      stateUpdate = function(self)
        if instance.animations[instance.currentAnimation].status ~= "paused" then
          return
        end

        if instance.health <= 0 then
          return "DEAD"
        end
        if instance.attacked then
          return "DAMAGED"
        end
        if #instance.enteredLights == 0 then
          return "IDLE"
        else
          return "SLOWED"
        end
      end,
      update = function(self, delta)
        instance.body:setLinearVelocity(0, 0)
      end,
      exit = function(self)
        instance:shot()
      end
    }
  }, "IDLE")

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
  
  local x, y = self.body:getX() - self.width, self.body:getY() - self.height
  self:updateHandler(delta, x, y)
  self.stateMachine:update(delta)

  self.animations[self.currentAnimation]:update(delta)
 
  self.particleHandler:update(delta)
end

function enemy:damaged(d)
  self:damagedHandler(d)

  self.particleHandler:emit(6)
end 

function enemy:shot()
  currentScene.ocean:addEntity(projectile.new(self.body:getX(), self.body:getY()))
end

--function enemy:remove()
--  EnemyClass.remove(self)
--end

return enemy