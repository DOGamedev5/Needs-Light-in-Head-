local oil = setmetatable({}, {__index=DropClass})

oil.image = love.graphics.newImage("src/ocean/misc/oil/oil.png")
oil.textureWidth = oil.image:getWidth()
oil.width = 16
oil.height = 16
oil.grid = anim8.newGrid(oil.width, oil.height, oil.textureWidth, oil.height)
oil.name = "oil"
oil.id = 1
local cooldownMax = 3.0

function oil.new()

	local instance = setmetatable(DropClass.new(0, 0, {
		size = 0,
		shape = love.physics.newCircleShape(14),
		special = true
	}), {__index  = oil})
	
	instance:setPosition()
	
  	instance.animation = anim8.newAnimation(oil.grid:getFrames("1-6", 1), 0.2)
  	instance.cooldown = cooldownMax

  	return instance
end

function oil:draw()
	if self.cooldown > 0 then
		self.scale = 0
		return
	end
	love.graphics.setColor(1, 1, 1)
	self.animation:draw(self.image, self.body:getX(), self.body:getY(), 0, 2*self.scale, 2*self.scale, 8, 8)
end

function oil:update(delta)
	self.cooldown = self.cooldown - delta
	self.animation:update(delta)
	self:physics(delta)
end

function oil:collect()
	self.toCollect = false
	if self.cooldown > 0 then
		return
	end
	currentScene.ocean.light:refil(UpgradeManager:apply("oil", "oilAmount", 13))

	self.cooldown = cooldownMax
	self.scale = 0.0
	self:setPosition()
end

function oil:setPosition()
	local dir = math.rad(love.math.random(0, 360))

	self.body:setX(math.cos(dir)*150 + windowSize.x/2)
	self.body:setY(math.sin(dir)*150 + windowSize.y/2)
end

return oil