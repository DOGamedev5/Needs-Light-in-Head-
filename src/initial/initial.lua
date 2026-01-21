local initial = {}

initial.time = 0
initial.water = require("src.ocean.effects.waterEffect")


function initial:init( )
	self.time = 0
	self.water:setWaterColor({26/255, 39/255, 61/255})
	--self.water:updateOverColor({134/255*1.2, 178/255*1.2, 189/255*1.2, 0.75})
	self.water:updateOverColor({1, 1, 1, 0.75})
end

function initial:update(delta)
	self.water:update()
	self.time = self.time + delta
end

function initial:draw()

	self.water:draw()

	--[[local multiply = 1-Tween.interpolate("expo", self.time, 0.1, 0.75, "out")

	love.graphics.setColor(78/255*multiply, 61/255*multiply, 73/255*multiply, 1)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	love.graphics.setColor(multiply, multiply, multiply)
	]]


end

return initial