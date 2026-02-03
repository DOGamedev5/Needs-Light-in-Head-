local results = {}

results.alpha = 0.0
results.titleFont = love.graphics.newFont("assets/fonts/BoldPixels.ttf", 16, "normal")
results.valueFont = fonts.normal
results.timeAnim = 0.0
results.counters = {

}
results.buttons = {
	repeatPhase = Button.new("Retry", windowSize.x/2 - 200, windowSize.y-110, 200, 50, function()
		currentScene:changeMode("ocean")
	end),
	continue = Button.new("continue", windowSize.x/2 - 100, windowSize.y-110, 200, 50, function()
		currentScene:changeMode("initial")
	end),
}
results.buttonList = ListOrder.new(windowSize.x/2 - 200, windowSize.y-110, 10, "x")
results.buttonList:addToList(results.buttons.repeatPhase)
results.buttonList:addToList(results.buttons.continue)
results.finished = false

function results:init()
	self.alpha = -1.25
	self.timeAnim = 0.0
end

function results:setupInfo(info)
	self.counters = {}

	for k, v in pairs(info.collects) do
		self.counters[#self.counters+1] = {
			k,
			v,
			info.counters[k].image
		}
	end

	self.finished = info.beated
end

function results:update(delta)
	if self.alpha < 0.8 then
		self.alpha = self.alpha + delta * 1
		if self.alpha > 0.8 then self.alpha = 0.8 end
	end
	self.timeAnim = self.timeAnim + delta
	local posY = windowSize.y-110 + 110*Tween.interpolate("quad", self.timeAnim, 3.9, 0.2, "out")
	self.buttonList.posY = posY
	self.buttonList:update(delta)
end

function results:draw()
	love.graphics.setColor(0.02, 0.01, 0.07, self.alpha)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	self:title()
	self:values()
	self:buttonsDraw()
	self:beatedDraw()
end

function results:title()
	love.graphics.setFont(self.titleFont)
	love.graphics.setColor(1, 1, 1)
	local wid = self.titleFont:getWidth("results screen")
	local porc = Tween.interpolate("sine", self.timeAnim, 2.55, 0.4, "out")
	local offset = (windowSize.x/2 + wid) * porc

	love.graphics.print("results screen", windowSize.x/2-wid - offset, 40, 0, 2, 2)
end

function results:values()
	local posX = windowSize.x/2 -100
	local posY = 100
	love.graphics.setFont(self.valueFont)
	local porc = 1-Tween.interpolate("expo", self.timeAnim, 3.1, 0.75, "out")
	love.graphics.setColor(1, 1, 1, porc)
	posY = posY + (windowSize.y -100) * (1-porc)

	for i,v in ipairs(self.counters) do
		local text = tostring(self.counters[i][2])
		local textPosX = windowSize.x/2 + 100 - self.valueFont:getWidth(text) * (2 + 8*(1-porc))
		

		love.graphics.draw(self.counters[i][3], posX, posY, math.rad(155)*(1-porc), 2 + 4*(1-porc), 2 + 4*(1-porc))
		love.graphics.print(text, textPosX, posY - (self.valueFont:getHeight(text) * (2 + 8*(1-porc)))/4, 0, 2 + 8*(1-porc), 2 + 8*(1-porc))
		posY = posY + self.counters[i][3]:getHeight()*2 + 2 + 300*(1-porc)
	end
end

function results:beatedDraw()
	if self.timeAnim < 4 then return end

	local porc = 1-Tween.interpolate("expo", self.timeAnim, 4, 0.8, "out")
	love.graphics.setFont(self.valueFont)
	local text = "YOU DID IT :D !!!"
	local offset = math.cos(love.timer.getTime()*2.1)*2
	local offset2 = math.cos(love.timer.getTime()*1.6+10)*2
	local scale = 0.1 + math.cos(love.timer.getTime()*2.8)*0.2
	local rotation = math.cos(love.timer.getTime()*2.2)*0.1

	love.graphics.setColor(0.5, 0.3, 0.1, 0.4*porc)
	love.graphics.print(text, windowSize.x/2-2+offset2, windowSize.y - 154 + offset2, -1.05 + 1.1*porc+rotation, 7.1-porc*5+scale, 7.1-porc*5+scale, self.valueFont:getWidth(text)/2, self.valueFont:getHeight(text)/2)
	love.graphics.setColor(0.9, 0.8, 0.2, 0.9*porc)
	love.graphics.print(text, windowSize.x/2+offset, windowSize.y - 150 + offset, -0.95 + 1.1*porc+rotation, 4-porc*2+scale, 4-porc*2+scale, self.valueFont:getWidth(text)/2, self.valueFont:getHeight(text)/2)
end

function results:buttonsDraw()
	if self.timeAnim < 3.9 then return end
	
	if self.finished then
		self.buttons.continue.posX = windowSize.x/2 - 100
		self.buttons.continue:draw()
	else
		self.buttonList:draw()
	end
end

function results:input(event, value)
	if self.timeAnim < 4.1 then return end
	self.buttonList:input(event, value)
end

function results:mouseMoved(x, y, dx, dy, touch)
	if self.timeAnim < 4.1 then return end
	self.buttonList:mouseMoved(x, y, dx, dy, touch)
end

function results:mousePressed(x, y, button, touch, presses)
	if self.timeAnim < 4.1 then return end
	self.buttonList:mousePressed(x, y, button, touch, presses)
end

function results:mouseReleased(x, y, button, touch, presses)
	if self.timeAnim < 4.1 then return end
	self.buttonList:mouseReleased(x, y, button, touch, presses)
end

return results