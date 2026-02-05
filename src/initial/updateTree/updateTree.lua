local tree = {}

tree.exit = Button.new("exit", windowSize.x/2, windowSize.y-25, 20, 20, function()
	currentScene.initial.currentScreen = 1
end) 
tree.exit.centered = true
tree.icons = {}

local IconButton = require("src.initial.updateTree.iconButton")

function tree:init()
	self.icons[1] = IconButton.new(self, "light", "damage", "basic", windowSize.x/2, windowSize.y/2-40)
end

function tree:update(delta)
	self.exit:update(delta)
	for i, v in ipairs(self.icons) do
		v:update(delta)
	end
end

function tree:draw()
	love.graphics.setColor(0.12, 0.05, 0.15, 0.8)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	love.graphics.setColor(0, 0, 0.05, 0.9)
	love.graphics.rectangle("fill", 0, windowSize.y-50, windowSize.x, 50)
	love.graphics.setColor(1, 1, 1)
	self.exit:draw()
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:draw() end
	end
end


function tree:input(event, value)
	self.exit:input(event, value)
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:input(event, value) end
	end
end

function tree:mouseMoved(x, y, dx, dy, touch)
	self.exit:mouseMoved(x, y, dx, dy, touch)
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:mouseMoved(x, y, dx, dy, touch) end
	end
end

function tree:mousePressed(x, y, button, touch, presses)
	self.exit:mousePressed(x, y, button, touch, presses)
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:mousePressed(x, y, button, touch, presses) end
	end
end

function tree:mouseReleased(x, y, button, touch)
	self.exit:mouseReleased(x, y, button, touch)
	for i, v in ipairs(self.icons) do
		if v.onScreen then v:mouseReleased(x, y, button, touch) end
	end
end

return tree