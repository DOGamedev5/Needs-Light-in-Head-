local tree = {}

tree.exit = Button.new(TranslateManager.newReference("menu", "exit"), windowSize.x/2, windowSize.y-25, 20, 20, function()
	currentScene.initial.currentScreen = 1
end) 
tree.buy = Button.new(TranslateManager.newReference("initial", "buy"), windowSize.x - 20, windowSize.y-25, 100, 60, function()
	if tree.select ~= nil then
		tree.select:press()
	end
end)
tree.exit.centered = true
tree.buy.anchorRight = true
tree.icons = {}
tree.pressed = false

tree.limitX = 500
tree.limitY = 500

function tree:init()
	self.posX = 0
	self.posY = 0
	self.icons = UpgradeManager:getAllButtons(self)
	self.select = nil
	self.pad = 50
end

function tree:update(delta)
	self.exit:update(delta)
	for i, v in ipairs(self.icons) do
		v:update(delta)
	end

	if self.select ~= nil then
		self.pad = tools.lerp(self.pad, 120, 10*delta)
	else
		self.pad = tools.lerp(self.pad, 50, 5*delta)
	end
end

function tree:updateInfo()
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:updateInfo() end
	end
end

function tree:draw()
	love.graphics.setColor(0.12, 0.07, 0.17, 0.8)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	for i, v in ipairs(self.icons) do
		v:draw()
	end

	love.graphics.setColor(0, 0, 0.05, 0.9)
	
	love.graphics.rectangle("fill", 0, windowSize.y-self.pad, windowSize.x, self.pad)
	love.graphics.setColor(1, 1, 1)
	self:drawSelect()
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
	
	if ty < windowSize.y-self.pad then
		self.pressed = true
		for i, v in ipairs(self.icons) do
			if v.onScreen then v:mousePressed(x, y, button, touch, presses) end
		end
	else
		self.exit:mousePressed(x, y, button, touch, presses)
		if device == "mobile" then
			self.buy:mousePressed(x, y, button, touch, presses)
		end
	end
end

function tree:mouseReleased(x, y, button, touch)
	self.exit:mouseReleased(x, y, button, touch)
	if device == "mobile" then
		self.buy:mouseReleased(x, y, button, touch)
	end
	self.pressed = false
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:mouseReleased(x, y, button, touch) end
	end
end

function tree:setSelect(icon)
	self.select = icon
	if icon then
		self.buy = icon.state ~= 2
	end
end

function tree:drawSelect()
	if self.pad < 60 or self.select == nil then return end

	local name = TranslateManager:getReference("upgrades", self.select.pname)
	local desc =  TranslateManager:getReference("upgradesDesc", self.select.description)
	
	love.graphics.setFont(fonts.normal)
	love.graphics.print(name, 10, windowSize.y - self.pad+5, 0, 2, 2)
	local offset = fonts.normal:getWidth(name) - 45
	love.graphics.setFont(fonts.small)
	love.graphics.print(desc, 10, windowSize.y - self.pad+5+offset, 0, 2, 2)

	if device == "mobile" then
		self.buy.posY = windowSize.y - self.pad + 10
		self.buy:draw()
	end
end

return tree