local tree = {}

tree.exit = Button.new("exit", windowSize.x/2, windowSize.y-25, 20, 20, function()
	currentScene.initial.currentScreen = 1
end) 
tree.exit.centered = true
tree.icons = {}
tree.pressed = false

tree.limitX = 500
tree.limitY = 500

function tree:init()
	self.posX = 0
	self.posY = 0
	self.icons = UpgradeManager:getAllButtons(self)
end

function tree:update(delta)
	self.exit:update(delta)
	for i, v in ipairs(self.icons) do
		v:update(delta)
	end
end

function tree:updateInfo()
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:updateInfo() end
	end
end

function tree:draw()
	love.graphics.setColor(0.12, 0.05, 0.15, 0.8)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	for i, v in ipairs(self.icons) do
		v:draw()
	end

	love.graphics.setColor(0, 0, 0.05, 0.9)
	love.graphics.rectangle("fill", 0, windowSize.y-50, windowSize.x, 50)
	love.graphics.setColor(1, 1, 1)
	self.exit:draw()
end


function tree:input(event, value)
	self.exit:input(event, value)
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:input(event, value) end
	end
end

function tree:mouseMoved(x, y, dx, dy, touch)
	local tx, ty = toGame(x, y)
	
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:mouseMoved(x, y, dx, dy, touch) end
	end
	if ty < windowSize.y-50 then
		
		if self.pressed then
			self.posX = self.posX - dx*0.9
			self.posY = self.posY - dy*0.9

			self.posX = math.max(math.min(self.posX, self.limitX), -self.limitX)
			self.posY = math.max(math.min(self.posY, self.limitY), -self.limitY)
		end
	else
		self.exit:mouseMoved(x, y, dx, dy, touch)
	end
end

function tree:mousePressed(x, y, button, touch, presses)
	local tx, ty = toGame(x, y)
	
	if ty < windowSize.y-50 then
		self.pressed = true
		for i, v in ipairs(self.icons) do
			if v.onScreen then v:mousePressed(x, y, button, touch, presses) end
		end
	else
		self.exit:mousePressed(x, y, button, touch, presses)
	end
end

function tree:mouseReleased(x, y, button, touch)
	self.exit:mouseReleased(x, y, button, touch)
	self.pressed = false
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:mouseReleased(x, y, button, touch) end
	end
end

return tree