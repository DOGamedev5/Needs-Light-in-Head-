local daySelect = {}


daySelect.exit = Button.new("exit", 20, 20, 1, 1, function()
	currentScene.initial.currentScreen = 1
end)
daySelect.start = Button.new("start", 0, 0, 1, 1, function()
	daySelect.started = true
end)
daySelect.buttonList = ListOrder.new(windowSize.x/2, windowSize.y/2+10, 10, "x")
daySelect.buttonList.centered = true
daySelect.buttonList:addToList(daySelect.exit)
daySelect.buttonList:addToList(daySelect.start)
daySelect.started = false
daySelect.startTime = 0

function daySelect:init()
	self.started = false
	self.startTime = 0
end

function daySelect:update(delta)
	if not self.started then
		self.buttonList:update(delta)
	else
		if Tween.interpolate("expo", self.startTime, 0.0, 0.3, "out") <= 0.1 then
			currentScene:changeMode("ocean")
		end
		self.startTime = self.startTime + delta
	end
end

function daySelect:draw()
	love.graphics.setColor(0, 0, 0, 0.4)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	love.graphics.setColor(1, 1, 1)

	self.buttonList:draw()
	
	love.graphics.setFont(fonts.normal)
	local text = string.format("Week %d - Day %d of 6", currentScene.save.currentWeek, currentScene.save.currentDay)
	local wid = fonts.normal:getWidth(text)
  	local _, count = string.gsub(text, "\n", "")
  	local hei = fonts.normal:getHeight(text)*(count+1)

	love.graphics.setColor(1, 1, 1)

	love.graphics.print(text, windowSize.x/2- wid, windowSize.y/2-50, 0, 2, 2)

	love.graphics.setColor(0, 0, 0, 1-Tween.interpolate("expo", self.startTime, 0.0, 0.25, "out"))

end

function daySelect:input(event, value)
	if not self.started then
		self.buttonList:input(event, value)
	end
end

function daySelect:mouseMoved(x, y, dx, dy, touch)
	if not self.started then
		self.buttonList:mouseMoved(x, y, dx, dy, touch)
	end
end

function daySelect:mousePressed(x, y, button, touch, presses)
	if not self.started then
		self.buttonList:mousePressed(x, y, button, touch, presses)
	end
end

function daySelect:mouseReleased(x, y, button, touch)
	if not self.started then
		self.buttonList:mouseReleased(x, y, button, touch)
	end
end


return daySelect