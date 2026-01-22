local boatShop = {}

boatShop.boatShop = love.graphics.newImage("src/initial/boatShop.png")
boatShop.hovered = false

function boatShop:init()
	self.boatShopWidthtext = self.boatShop:getWidth()
	self.boatShopWidth = self.boatShopWidthtext/2
	self.boatShopHeight =  self.boatShop:getHeight()
	self.boatShopGrid = anim8.newGrid(self.boatShopWidth, self.boatShopHeight, self.boatShopWidthtext, self.boatShopHeight)
	self.boatShopQuads = self.boatShopGrid:getFrames("1-2", 1)
	self.posX = windowSize.x/2+12
	self.posY = 138
end

function boatShop:mouseMoved(x, y)
	self.hovered = tools.AABB.detectPoint(x, y, self.posX - self.boatShopWidth, self.posY - self.boatShopHeight, self.boatShopWidth*2, self.boatShopHeight*2)
end

function boatShop:draw()
	local offsetY = math.sin(love.timer.getTime()*0.3)*4
	local quad = 1
	if self.hovered then quad = 2 end

	love.graphics.draw(self.boatShop, self.boatShopQuads[quad], self.posX, self.posY+offsetY, math.rad(0.1)*offsetY, 2, 2, self.boatShopWidth/2, self.boatShopHeight/2)
end

return boatShop