local Counter ={}

--Counter.font = love.graphics.newFont("assets/fonts/BoldPixels.ttf", 8, "normal")
Counter.font = fonts.small

function Counter.new(image)
	local instance = setmetatable({}, {__index=Counter})

	instance.image = image
	instance.count = 0
	instance.posX = 0
	instance.posY = 0
	instance.imageWidth, instance.imageHeight = image:getDimensions()


	return instance
end

function Counter:updateCounter(value)
	self.count = value
end

function Counter:draw()

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.image, self.posX, self.posY, 0, 2, 2)
	love.graphics.setFont(self.font)
	
	local text = tostring(self.count)

	local wid = self.font:getWidth(text)*2
	local _, count = string.gsub(text, "\n", "")
	local hei = self.font:getHeight(text)*(count+1)*2

	love.graphics.print(text, self.font,
		self.posX + self.imageWidth*2 + 5,
		self.posY + (self.imageHeight*2-hei), 0, 2, 2
	)
end

function Counter:getDimentions()
	return self.imageWidth*2, self.imageHeight*2
end

return Counter