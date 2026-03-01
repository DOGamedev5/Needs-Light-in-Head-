ToolTip = {}
ToolTip.texture = lovepatch.load("assets/tooltip.png", 2, 2, 2, 2)
ToolTip.offset = 6

function ToolTip.new(content)
	local instance = setmetatable({}, {__index=ToolTip})
	instance.content = content
	instance.posX = 0
	instance.posY = 0

	return instance
end

function ToolTip:setPoint(x, y)
	self.posX = x
	self.posY = y
end

function ToolTip:update(delta)
	self.content:update(delta)
end

function ToolTip:draw()
	local w, h = 0.0, 0.0
	if type(self.content) == "string" then 
		w, h = StringHandler.getDimentions(string.lower(self.content), fonts.small)
		w = w*2 + self.offset/2
		h = h*2 - 2
	else
		w, h = self.content:getDimentions()
		w = w + self.offset/2
		h = h + self.offset/2
	end

	local tx, ty = self.posX - w/2 - self.offset/2, self.posY - h/2 - self.offset/2

	tx, ty = math.max(0, math.min(tx, windowSize.x - w - self.offset)), math.max(0, math.min(ty, windowSize.y - h  - self.offset))

	lovepatch.draw(self.texture, tx, ty, w + self.offset, h + self.offset, 2, 2)

	love.graphics.setColor(1, 1, 1)
	if type(self.content) == "string" then
		love.graphics.print(string.lower(self.content), fonts.small, tx + self.offset, ty + self.offset - 6, 0, 2, 2)
	else
		self.content:draw()
	end
end

