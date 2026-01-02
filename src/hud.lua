Hud = {}
Hud.items = {}

function Hud:addToHud(object)
	self.items[#self.items+1] = object
	
	if object.init then
		self.items[#self.items]:init()
	end
end

function Hud:clear()
	for i, v in ipairs(self.items) do
		tools.erase(self.items, v)	
	end
end

function Hud:remove(object)
	tools.erase(self.items, object)
end

function Hud:draw()
	for i, o in ipairs(self.items) do
		if o.draw then
			o:draw()
		end
	end
end

function Hud:update(delta)
	for i, o in ipairs(self.items) do
		if o.update then
			o:update(delta)
		end
	end
end