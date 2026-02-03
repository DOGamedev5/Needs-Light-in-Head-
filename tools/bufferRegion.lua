BufferRegion = {}

function BufferRegion.new(shape, x, y, buffers)	
	local instance = setmetatable({}, {__index=BufferRegion})
	instance.buffers = buffers

	instance.shape = shape
	instance.body = love.physics.newBody(World, x, y, "dynamic")

	instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
	instance.fixture:setSensor(true)
	instance.fixture:setCategory(2)
	instance.fixture:setUserData(instance)
	instance.body:isFixedRotation(true)
	instance.body:setUserData("buffer")

	instance.entered = {}

	return instance
end

function BufferRegion:setPosition(x, y)
	self.body:setPosition(x, y)
end