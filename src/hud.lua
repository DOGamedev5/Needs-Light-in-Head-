Hud = {}
Hud.items = {}
Hud.hidden = false

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
			o:draw()
		end
	end
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