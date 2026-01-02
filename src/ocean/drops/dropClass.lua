DropClass = {}

function DropClass.new(x, y, prototype)
  local instance = setmetatable({}, {__index == DropClass})
  instance.body = love.physics.newBody(World, x, y, "dynamic")
  instance.body:setUserData("drop")
  instance.toCollect = false

  local sizeExplosion = prototype.size or 1
  local dir = math.deg(love.math.random(0, 360))
  instance.velX, instance.velY = math.cos(dir)*sizeExplosion, math.sin(dir)*sizeExplosion
  instance.enteredLights = {}

  return instance
end

function DropClass:physics(delta)
	self.body:setX(self.body:getX() + self.velX*delta)
	self.body:setY(self.body:getY() + self.velY*delta)

	self.velX = self.velX* (4^(-1*delta))
	self.velY = self.velY* (4^(-1*delta))
end