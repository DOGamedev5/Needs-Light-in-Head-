local results = {}

results.alpha = 0.0

function results:init(info)
	self.alpha = -0.75
end

function results:update(delta)
	if self.alpha < 0.8 then
		self.alpha = self.alpha + delta * 1
		if self.alpha > 0.8 then self.alpha = 0.8 end
	end
end

function results:draw()
	love.graphics.setColor(0.02, 0, 0.07, self.alpha)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
end

return results