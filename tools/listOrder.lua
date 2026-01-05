ListOrder = {}

function ListOrder.new(posX, posY, separator, axis)
	local instance = setmetatable({}, {__index=ListOrder})
	instance.items = {}
	instance.posX = posX
	instance.posY = posY
	instance.axis = axis or "y"
	instance.separator = separator

	return instance
end

function ListOrder:addToList(item)
	self.items[#self.items + 1] = item
end

function ListOrder:update(delta)
	local posY = self.posY
	local posX = self.posX

	for i,v in ipairs(self.items) do
		local w, h = self.items[i]:getDimentions()
		self.items[i].posY = posY
		self.items[i].posX = posX

		if self.items[i].update then
			self.items[i]:update(delta)
		end
		if self.axis == "y" then posY = posY + h + self.separator end
		if self.axis == "x" then posX = posX + w + self.separator end
	end
end

function ListOrder:draw()
	for i,v in ipairs(self.items) do
		self.items[i]:draw()
	end
end

function ListOrder:input(event, value)
	for i,v in ipairs(self.items) do
		if self.items[i].input then
			self.items[i]:input(event, value)
		end
	end
end

function ListOrder:mouseMoved(x, y, dx, dy, touch)
	for i,v in ipairs(self.items) do
		if self.items[i].mouseMoved then
			self.items[i]:mouseMoved(x, y, dx, dy, touch)
		end
	end
end

function ListOrder:mousePressed(x, y, button, touch, presses)
	for i,v in ipairs(self.items) do
		if self.items[i].mousePressed then
			self.items[i]:mousePressed(x, y, button, touch, presses)
		end
	end
end
