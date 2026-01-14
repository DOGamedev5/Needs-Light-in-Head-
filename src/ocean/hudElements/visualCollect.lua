local visualCollect = {}

function visualCollect.new(image, posX, posY, destinationX, destinationY)
	local instance = setmetatable({}, {__index=visualCollect})
	instance.image = image
	instance.posX = posX
	instance.posY = posY
	instance.destinationX = destinationX
	instance.destinationY = destinationY
	instance.counter = 0
	instance.toRemove = false

	return instance
end

function visualCollect:update(delta)
	self.counter = self.counter + delta
end

function visualCollect:draw()
	local distanceX = self.posX - self.destinationX
	local distanceY = self.posY - self.destinationY
	local scale = 0.5 
	if self.counter < 0.3 then
		scale = 1 + Tween.interpolate("quad", self.counter, 0, 0.3, "in") 
	else 
		scale = 2 - 1*Tween.interpolate("expo", self.counter, 0.3, 0.45, "in")
	end

	local x = self.posX - distanceX*Tween.interpolate("expo", self.counter, 0.1, 0.75, "in")
	local y = self.posY - distanceY*Tween.interpolate("expo", self.counter, 0.1, 0.75, "in")

	love.graphics.draw(self.image, x, y, 0, scale, scale)
	if math.abs(x) < 10 and math.abs(y) < 10 then
		self.toRemove = true
	end
end

return visualCollect