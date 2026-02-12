local corruptEssence = setmetatable({}, {__index = DropClass})

corruptEssence.image = love.graphics.newImage("src/ocean/drops/corruptEssence/corruptEssence.png")
corruptEssence.textureWidth = corruptEssence.image:getWidth()
corruptEssence.width = 10
corruptEssence.height = 10
corruptEssence.grid = anim8.newGrid(corruptEssence.width, corruptEssence.height, corruptEssence.textureWidth, corruptEssence.height)
corruptEssence.name = "corruptEssence"
corruptEssence.id = 2

function corruptEssence.new(x, y, sizeEx)
	local instance = setmetatable(DropClass.new(x, y, {size = sizeEx, shape = love.physics.newCircleShape(4)}), {__index  = corruptEssence})
	
  	instance.animation = anim8.newAnimation(corruptEssence.grid:getFrames("1-4", 1), {0.25, 0.05, 0.05, 0.05})

  	return instance
end

function corruptEssence:draw()
	love.graphics.setColor(1, 1, 1, self:getAlphaLifetime())
	self.animation:draw(self.image, self.body:getX(), self.body:getY(), 0, 2*self.scale, 2*self.scale, 5, 5)
end

function corruptEssence:update(delta)
	self.animation:update(delta)
	self:physics(delta)
end

return corruptEssence