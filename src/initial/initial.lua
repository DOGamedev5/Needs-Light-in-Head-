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
--initial.boatLightQuads = love.graphics.newQuad(0, initial.boatLightHeight*2, initial.boatLightWidth, initial.boatLightHeight, initial.boatLight)

initial.boatShop = require("src.initial.boatShop.boatShop")

function initial:init( )
	self.boatShop:init()
	self.boatLight:init(windowSize.x/2-70, windowSize.y/2+42)
	self.time = 0
	self.water:setWaterColor({26/255, 39/255, 61/255})
	--self.water:updateOverColor({134/255*1.2, 178/255*1.2, 189/255*1.2, 0.75})
	self.water:updateOverColor({1, 1, 1, 0.75})
end

function initial:update(delta)
	self.water:update()
	self.time = self.time + delta
	self.animation:update(delta)
end

function initial:draw()

	self.water:draw()

	self.boatShop:draw()
	self.animation:draw(self.piler, windowSize.x/2, windowSize.y/2+32, 0, 2, 2, self.pilerWidth/4, self.pilerHeight/4)
	
	self.boatLight:draw()	
	self.animationOver:draw(self.piler, windowSize.x/2, windowSize.y/2+32, 0, 2, 2, self.pilerWidth/4, self.pilerHeight/4)


	local alpha = Tween.interpolate("expo", self.time, 0.1, 0.75, "out")

	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle("fill", 0, 0, windowSize.x, windowSize.y)
end

function initial:mouseMoved(x, y, dx, dy, touch)
	self.boatLight:mouseMoved(x, y)
	self.boatShop:mouseMoved(x, y)
end

function initial:mousePressed(x, y, button, touch, presses)

end

function initial:input(event, value)

end

return initial