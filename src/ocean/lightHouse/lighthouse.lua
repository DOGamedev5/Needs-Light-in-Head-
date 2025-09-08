local lightHouse = {}

lightHouse.texture = love.graphics.newImage("src/ocean/lightHouse/lighthouse.png")
lightHouse.sortOffset = 6


function lightHouse:init()
  self.texturewidth, self.height = self.texture:getDimensions()
  self.texturegrid= anim8.newGrid(32, 64, self.texturewidth, self.height)
  self.animation = anim8.newAnimation(self.texturegrid('1-4', 1), 0.3)
  self.width = self.texturewidth/4
  --local wx, wy = love.graphics.getDimensions()
  self.x = windowSize.x/2
  self.y = windowSize.y/2

end

function lightHouse:update(delta)
  self.animation:update(delta)
end

function lightHouse:draw()
  --local wx, wy = love.graphics.getDimensions()
  --local x = wx/2
  --local y = wy/2

--  love.graphics.draw(self.texture, x - self.width, y - self.height-48, 0, 2, 2)
  self.animation:draw(self.texture, self.x - self.width, self.y - self.height-48, 0, 2, 2)


end

return lightHouse
