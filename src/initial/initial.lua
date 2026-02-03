local initial = {}

initial.time = 0
initial.water = require("src.ocean.effects.waterEffect")
initial.piler = love.graphics.newImage("src/initial/tilemap/pilersSheet.png")
initial.pilerWidth = initial.piler:getWidth()
initial.pilerHeight = initial.piler:getHeight()
initial.grid = anim8.newGrid(initial.pilerWidth/2, initial.pilerHeight/2, initial.pilerWidth, initial.pilerHeight)
initial.animation = anim8.newAnimation(initial.grid:getFrames("1-2", 1), 1.0)
initial.animationOver = anim8.newAnimation(initial.grid:getFrames("1-2", 2), 1.0)

initial.boatLight = require("src.initial.lightHouse.lightHouse") 
initial.boatShop = require("src.initial.boatShop.boatShop")

initial.currentScreen = 1

initial.daySelect = require("src.initial.daySelect")

initial.collects = {}
initial.counterList = nil

local counter = require("src.ocean.hudElements.counter")

function initial:init( )
	self.currentScreen = 1
	currentScene:writeSave()
	self.boatShop:init(self)
	self.daySelect:init(self)
	
	self.boatLight:init(windowSize.x/2-70, windowSize.y/2+42, self)
	self.time = 0
	self.water:setWaterColor({26/255, 39/255, 61/255})
	--self.water:updateOverColor({134/255*1.2, 178/255*1.2, 189/255*1.2, 0.75})
	self.water:updateOverColor({1, 1, 1, 0.75})

	self.collects = ListOrder.new(5, 5, 5)

	for k, v in pairs(currentScene.save.collects) do
		local path = string.gsub("src/ocean/drops/$a/$aIcon.png", "$a", k)

		local count = counter.new(love.graphics.newImage(path))

		count:valueTracker(currentScene.save.collects, k)
		count.autoTracker = true

		self.collects:addToList(count)
	end
end

function initial:update(delta)
	self.water:update()
	self.time = self.time + delta
	self.animation:update(delta)
	self.collects:update()
	if self.currentScreen == 2 then self.daySelect:update(delta) end
end

function initial:draw()

	self.water:draw()

	self.boatShop:draw()
	self.animation:draw(self.piler, windowSize.x/2, windowSize.y/2+32, 0, 2, 2, self.pilerWidth/4, self.pilerHeight/4)
	
	self.boatLight:draw()	
	self.animationOver:draw(self.piler, windowSize.x/2, windowSize.y/2+32, 0, 2, 2, self.pilerWidth/4, self.pilerHeight/4)

	self.collects:draw()

	if self.currentScreen == 2 then
		self.daySelect:draw()
	end


	local alpha = Tween.interpolate("expo", self.time, 0.1, 0.75, "out")

	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)

end

function initial:mouseMoved(x, y, dx, dy, touch)
	if self.currentScreen == 1 then
		self.boatLight:mouseMoved(x, y)
		self.boatShop:mouseMoved(x, y)
	else
		self.daySelect:mouseMoved(x, y)
	end
end

function initial:mousePressed(x, y, button, touch, presses)
	if self.currentScreen == 1 then
		self.boatLight:mousePressed(x, y, button, touch, presses)
		self.boatShop:mousePressed(x, y, button, touch, presses)
	else
		self.daySelect:mousePressed(x, y, button, touch, presses)
	end
end

function initial:mouseReleased(x, y, button, touch, presses)
	if self.currentScreen == 2 then
		self.daySelect:mouseReleased(x, y, button, touch, presses)
	end
end


function initial:input(event, value)
	if self.currentScreen == 1 then
		self.boatLight:input(event, value)
		self.boatShop:input(event, value)
	else
		self.daySelect:input(event, value)
	end
end

return initial