local Counter ={}

--Counter.font = love.graphics.newFont("assets/fonts/BoldPixels.ttf", 8, "normal")
Counter.font = fonts.small

function Counter.new(id)
	local instance = setmetatable({}, {__index=Counter})

	instance.autoTracker = false
	instance.tracker = nil
	instance.image = currentScene.collectsIcon[id]
	instance.count = 0
	instance.posX = 0
	instance.posY = 0
	instance.imageWidth, instance.imageHeight = instance.image:getDimensions()

	return instance
end

function Counter:updateCounter(value)
	self.count = value
end

function Counter:valueTracker(tab, key)
	self.tracker = {tab, key}
end

function Counter:draw()
	local text = tools.quantify(self.count)

	local wid = self.font:getWidth(text)*2
	local _, count = string.gsub(text, "\n", "")
	local hei = self.font:getHeight(text)*(count+1)*2
	local ioff = 0
	local toff = self.imageHeight*2-hei
	if hei > self.imageHeight*2 then
		ioff = hei - self.imageHeight*2
		toff = 0
	end

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.image, self.posX, self.posY + ioff/2, 0, 2, 2)
	love.graphics.setFont(self.font)
	
	if self.autoTracker and self.tracker then
		self.count = self.tracker[1][self.tracker[2]]
	end

	love.graphics.print(text, self.font,
		self.posX + self.imageWidth*2 + 5,
		self.posY + toff/2, 0, 2, 2
	)
end

function Counter:getDimentions()
	local sx, sy = self.imageWidth*2, self.imageHeight*2
	if self.autoTracker and self.tracker then
		self.count = self.tracker[1][self.tracker[2]]
	end

	local text = tools.quantify(self.count)
	sx = sx + self.font:getWidth(tools.quantify(self.count))*2 + 5
	local hei = self.font:getHeight(text)*2
	sy = math.max(hei, sy)
	
	return sx, sy
end

return Counter