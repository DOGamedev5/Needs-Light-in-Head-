local darkEssence = setmetatable({}, {__index = DropClass})

darkEssence.image = love.graphics.newImage("src/ocean/drops/darkEssence/darkEssence.png")
darkEssence.textureWidth = darkEssence.image:getWidth()
darkEssence.width = 10
darkEssence.height = 10
darkEssence.grid = anim8.newGrid(darkEssence.width, darkEssence.height, darkEssence.textureWidth, darkEssence.height)
darkEssence.name = "darkEssence"

function darkEssence.new(x, y, sizeEx)
	local instance = setmetatable(DropClass.new(x, y, {size = sizeEx, shape = love.physics.newCircleShape(4)}), {__index  = darkEssence})
	
  	instance.animation = anim8.newAnimation(darkEssence.grid:getFrames("1-4", 1), 0.4)

  	return instance
end

function darkEssence:draw()
	love.graphics.setColor(1, 1, 1, 1)
	self.animation:draw(self.image, self.body:getX()-8, self.body:getY()-8, 0, 2, 2)
end

function darkEssence:update(delta)
	self.animation:update(delta)
	self:physics(delta)
end



return darkEssence