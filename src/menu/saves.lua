local saves = {}

function saves:load(menu)
	self.buttons = {
		Button.new("exit", windowSize.x/2, windowSize.y - 100, 200, 50, menu.exitOptions),
		Button.new("", windowSize.x/2-220, windowSize.y/2-100, 200, 200, menu.startGame),
		Button.new("", windowSize.x/2, windowSize.y/2-100, 200, 200, menu.startGame),
		Button.new("", windowSize.x/2+220, windowSize.y/2-100, 200, 200, menu.startGame),
	}
	self.buttons[1].centered = true
	self.buttons[2].centered = true
	self.buttons[3].centered = true
	self.buttons[4].centered = true
	self.buttons[2]:setupArgs({1})
	self.buttons[3]:setupArgs({2})
	self.buttons[4]:setupArgs({3})
end

function saves:update(delta)
	for i, b in ipairs(self.buttons) do
      b:update(delta)
    end
	
end

function saves:draw()
	love.graphics.setColor(0, 0, 0, 0.75)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	love.graphics.setColor(1, 1, 1, 1)
	for i, b in ipairs(self.buttons) do
      b:draw()
    end
end

function saves:mousePressed(x, y, button, touch, presses)
	for i, b in ipairs(self.buttons) do
      b:mousePressed(x, y, button, touch, presses)
    end
end

function saves:mouseReleased(x, y, button, touch)
	for i, b in ipairs(self.buttons) do
      b:mouseReleased(x, y, button, touch)
    end
end

function saves:mouseMoved(x, y, dx, dy, touch)
	for i, b in ipairs(self.buttons) do
      b:mouseMoved(x, y, dx, dy, touch)
    end
end

function saves:input(event, value)
	for i, b in ipairs(self.buttons) do
      b:input(event, value)
    end
end


return saves