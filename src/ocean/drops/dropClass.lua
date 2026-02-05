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

  instance.toCollect = false

  instance.enteredLights = {}

  return instance
end

function DropClass:physics(delta)
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
end

function DropClass:collect()
  currentScene.ocean:registerDrop(self.name, self.body:getX(), self.body:getY())
  self.fixture:destroy()
  self.fixture:release()
  self.body:release()
  self.shape:release()
end