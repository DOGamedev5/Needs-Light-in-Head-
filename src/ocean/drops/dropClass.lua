DropClass = {}

function DropClass.new(x, y, prototype)
  local instance = setmetatable({}, {__index == DropClass})

  local sizeExplosion = prototype.size or 1
  local dir = math.deg(love.math.random(0, 360))
  
  instance.velX, instance.velY = math.cos(dir)*sizeExplosion, math.sin(dir)*sizeExplosion
  
  instance.body = love.physics.newBody(World, x + 0.5*instance.velX, y + 0.5*instance.velY, "dynamic")
  instance.body:setUserData("drop")
  instance.shape =  prototype.shape

  instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
  instance.fixture:setCategory(1)
  instance.fixture:setMask(1)
  instance.fixture:setUserData(instance)
  instance.scale = 0.2
  instance.lifetime = prototype.lifetime or 12

  instance.toCollect = false
  instance.toRemove = false

  instance.enteredLights = {}

  return instance
end

function DropClass:physics(delta)
  if self.lifetime > 1 then
    self.scale = tools.lerp(self.scale, 1.0, delta*6)
  else
    self.scale = Tween.interpolate("expo", self.lifetime, 0, 1, "in")
  end
  self.lifetime = self.lifetime - delta

	self.body:setX(self.body:getX() + self.velX*delta)
	self.body:setY(self.body:getY() + self.velY*delta)

	self.velX = self.velX* (4^(-1*delta))
	self.velY = self.velY* (4^(-1*delta))

  if self.body:getY() > windowSize.y then
    self.body:setY(windowSize.y)
  elseif self.body:getY() < 0 then
    self.body:setY(0)
  end
  if self.body:getX() > windowSize.x then
    self.body:setX(windowSize.x)
  elseif self.body:getX() < 0 then
    self.body:setX(0)
  end

  if self.lifetime <= 0 then
    self.toRemove = true
  end
end

function DropClass:getAlphaLifetime()
  if self.lifetime < 6 then
    return 0.5 + math.cos(self.lifetime*12.0)*0.25
  end
  return 1
end

function DropClass:collect()
  currentScene.ocean:registerDrop(self.id, self.body:getX(), self.body:getY())
  self:remove()
end

function DropClass:remove()
  self.fixture:destroy()
  self.fixture:release()
  self.body:release()
  self.shape:release()
end
