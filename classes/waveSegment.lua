WaveSegment = {}

function WaveSegment.new(delay, side, enemies)
	--local self = setmetatable({}, {__index=WaveSegment})
	local self = {}
	self.delay = delay
	self.setup = false
	self.enemies = enemies
	self.side = side

	return self
end
