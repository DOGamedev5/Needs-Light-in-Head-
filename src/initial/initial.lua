local initial = {}

initial.time = 0


function initial:init( )
	self.time = 0
end

function initial:update(delta)
	self.time = self.time + delta
end

function initial:draw()
	local multiply = 1-Tween.interpolate("expo", self.time, 0.1, 0.75, "out")

	love.graphics.setColor(78/255*multiply, 61/255*multiply, 73/255*multiply, 1)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	love.graphics.setColor(multiply, multiply, multiply)



end

return initial