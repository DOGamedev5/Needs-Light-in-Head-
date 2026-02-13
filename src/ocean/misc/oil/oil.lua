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
	local x = love.math.random(-200, 200) + windowSize.x/2
	local y = love.math.random(-200, 200) + windowSize.y/2

	local instance = setmetatable(DropClass.new(x, y, {
		size = 0,
		shape = love.physics.newCircleShape(14),
		special = true
	}), {__index  = oil})
	
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
	local x = love.math.random(-200, 200) + windowSize.x/2
	local y = love.math.random(-200, 200) + windowSize.y/2
	self.cooldown = cooldownMax
	self.scale = 0.0
	self.body:setX(x)
	self.body:setY(y)
end

return oil