local lightHouse = {}

lightHouse.boatLight = love.graphics.newImage("src/ocean/lightHouse/boat.png")
lightHouse.hovered = false
lightHouse.scale = 2
lightHouse.pressed = false

function lightHouse:init(x, y, owner)
	self.owner = owner
	self.boatLightWidth = self.boatLight:getWidth()/4
	self.boatLightHeight = self.boatLight:getHeight()/3
	self.boatLightGrid = anim8.newGrid(self.boatLightWidth, self.boatLightHeight, self.boatLight:getWidth(), self.boatLight:getHeight())
	self.boatLightQuads = self.boatLightGrid:getFrames("1-2", 3)
	self.posX, self.posY = x, y
end

function lightHouse:mouseMoved(x, y)
	local tx, ty = toGame(x, y)
	self.hovered = tools.AABB.detectPoint(tx, ty, self.posX - self.boatLightWidth, self.posY - self.boatLightHeight, self.boatLightWidth*2, self.boatLightHeight*2)
end

function lightHouse:mousePressed(x, y)
	local tx, ty = toGame(x, y)

	if tools.AABB.detectPoint(tx, ty, self.posX - self.boatLightWidth, self.posY - self.boatLightHeight, self.boatLightWidth*2, self.boatLightHeight*2) then
		--currentScene:changeMode("ocean")

		self.owner.currentScreen = 2
	end
end

function lightHouse:draw()
	local offsetY = math.sin(love.timer.getTime()*0.25)*4
	local quad = 1
	if self.hovered then quad = 2 end

	love.graphics.draw(self.boatLight, self.boatLightQuads[quad], self.posX, self.posY+offsetY/2, math.rad(0.1)*offsetY, 2, 2, self.boatLightWidth/2, self.boatLightHeight/2)
end

return lightHouse