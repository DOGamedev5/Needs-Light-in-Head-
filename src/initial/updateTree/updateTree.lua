local tree = {}

tree.exit = Button.new(TranslateManager.newReference("menu", "exit"), windowSize.x/2, windowSize.y-30, 100, 30, function()
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

tree.scale = 1

function tree:init()
	self.posX = 0
	self.posY = 0
	self.icons = UpgradeManager:getAllButtons(self)
	self.select = nil
	self.pad = 50
	self.padMin = 60
	self.padMax = 150
end

function tree:update(delta)
	self.scale = math.max(math.min(self.scale, 2), 0.5)

	self.exit:update(delta)
	self.buy:update(delta)
	for i, v in ipairs(self.icons) do
		v:update(delta)
	end

	if self.select ~= nil then
		self.pad = tools.lerp(self.pad, self.padMax, 10*delta)
	else
		self.pad = tools.lerp(self.pad, self.padMin, 5*delta)
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
	if device == "mobile" then 
		self.buy:input(event, value)
	end
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:input(event, value) end
	end
end

function tree:mouseMoved(x, y, dx, dy, touch)
	local tx, ty = toGame(x, y)
	
	for i, v in ipairs(self.icons) do
		if v.onScreen and v.visible then v:mouseMoved(x, y, dx, dy, touch) end
	end
	if ty < windowSize.y-self.pad then
		
		if self.pressed then
			self.posX = self.posX - dx*0.9
			self.posY = self.posY - dy*0.9

			self.posX = math.max(math.min(self.posX, self.limitX), -self.limitX)
			self.posY = math.max(math.min(self.posY, self.limitY), -self.limitY)
		end
	else
		self.exit:mouseMoved(x, y, dx, dy, touch)
		if device == "mobile" then
			self.buy:mouseMoved(x, y, dx, dy, touch)
		end
	end
end

function tree:mousePressed(x, y, button, touch, presses)
	local tx, ty = toGame(x, y)
	
	if ty < windowSize.y-self.pad then
		self.pressed = true
		for i, v in ipairs(self.icons) do
			if v.onScreen and v.visible then v:mousePressed(x, y, button, touch, presses) end
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
		if v.onScreen and v.visible then v:mouseReleased(x, y, button, touch) end
	end
end

function tree:setSelect(icon)
	if icon then
		self.buy.dissabled = icon.state ~= 2
		self.select = icon
	end
	
	if device == "mobile" then
		return
	end
	
	self.select = icon
end

function tree:drawSelect()
	if self.pad <= self.padMin+5 or self.select == nil then return end

	local a = (self.pad-self.padMin-5)/(self.padMax-self.padMin-5)

	local name = TranslateManager:getReference("upgrades", self.select.pname) .. string.format(" %d/%d", self.select.level, self.select.levelMax)
	local desc = self.select:getDescription()
	
	love.graphics.setFont(fonts.normal)
	love.graphics.setColor(0.45, 0.1, 0.1, a*0.8)
	love.graphics.print(name, 10, windowSize.y - self.pad+7, 0, 2, 2)
	love.graphics.setColor(0.8, 0.7, 0.1, a)
	love.graphics.print(name, 10, windowSize.y - self.pad+5, 0, 2, 2)

	local offset = fonts.normal:getHeight(name)*2
	love.graphics.setFont(fonts.small)
	love.graphics.setColor(0.3, 0.3, 0.4, a*0.8)
	love.graphics.print(desc, 10, windowSize.y - self.pad+7+offset, 0, 2, 2)
	love.graphics.setColor(1, 1, 1, a)
	love.graphics.print(desc, 10, windowSize.y - self.pad+5+offset, 0, 2, 2)

	offset = offset + fonts.small:getHeight(desc)*2

	local baseX = 10
	for i, v in pairs(self.select.prices) do
		local text = tools.quantify(v)
		local Iwid, Ihei = currentScene.collectsIcon[i]:getDimensions()
		local Twid, Thei = fonts.small:getWidth(text), fonts.small:getHeight(text)
		
		local wid = fonts.small:getWidth(text)*2
		local hei = fonts.small:getHeight(text)*2-8
		local ioff = 0
		local toff = Ihei*2-hei
		
		if hei > Ihei*2 then
			ioff = hei - Ihei*2
			toff = 0
		end
		love.graphics.setColor(0.3, 0.3, 0.4, a*0.8)
		love.graphics.print(text, baseX + Iwid*2+5, windowSize.y - self.pad+7+offset+toff/2, 0, 2, 2)

		love.graphics.setColor(1, 1, 1, a)
		love.graphics.print(text, baseX + Iwid*2+5, windowSize.y - self.pad+5+offset+toff/2, 0, 2, 2)
		
		love.graphics.draw(currentScene.collectsIcon[i], baseX, windowSize.y - self.pad+10+offset+ioff/2, 0, 2, 2)
		baseX = baseX + Iwid*2 + Twid*2 + 20
	end

	if device == "mobile" then
		local offset2 = (self.padMax - self.padMin)/2
		self.buy.posY = windowSize.y - self.pad + offset2 - 30
		self.buy:draw()
	end
end

return tree