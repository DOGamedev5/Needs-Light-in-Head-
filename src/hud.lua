Hud = {}
Hud.items = {}
Hud.hidden = false
Hud.buffer = {}

function Hud:addToHud(object)
	self.items[#self.items+1] = object
	
	if object.init then
		self.items[#self.items]:init()
	end
end

function Hud:clear()
	for i, v in ipairs(self.items) do
		self.items[i] = nil
	end
end

function Hud:remove(object)
	tools.erase(self.items, object)
end

function Hud:draw()
	if self.hidden then return end
	for i, o in ipairs(self.items) do
		if o.draw then
			love.graphics.setColor(1, 1, 1)
			o:draw()
		end
	end
	for i, v in ipairs(self.buffer) do
		love.graphics.setColor(1, 1, 1)
		v[1](table.unpack(v[2]))
	end

	self.buffer = {}
end

function Hud:bufferDraw(draw, args)
	self.buffer[#self.buffer + 1] = {draw, args}
end

function Hud:update(delta)
	for i=#self.items, 1, -1 do
		if self.items[i].update then
			self.items[i]:update(delta)
		end
		if self.items[i].toRemove then
			table.remove(self.items, i)
		end
	end
end