local options = {}
options.file = "configuration.lua"

function options:load(menu)
	self.conf = {}
	self.conf.languege = "en"
	self.conf.version = "v0.1"
	
	if not FileSystem.fileExist(self.file) then
		FileSystem.writeFile(self.file, self.conf)
	else
		self.conf = FileSystem.loadFile(self.file)
	end

	self.buttons = Button.new("exit", windowSize.x/2 - 100, windowSize.y - 100, 200, 50, menu.exitOptions)
end

function options:update(delta)
	self.buttons:update(delta)
end

function options:draw()
	love.graphics.setColor(0, 0, 0, 0.75)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
	love.graphics.setColor(1, 1, 1, 1)
	self.buttons:draw()
end

function options:mousePressed(x, y, button, touch, presses)
	self.buttons:mousePressed(x, y, button, touch, presses)
end

function options:mouseMoved(x, y, dx, dy, touch)
	self.buttons:mouseMoved(x, y, dx, dy, touch)
end

function options:input(event, value)
	self.buttons:input(event, value)
end

return options