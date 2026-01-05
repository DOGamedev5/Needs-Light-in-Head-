local fuelBarr = {}

function fuelBarr:setup (light)
  print("A")
  self.light = light
end

function fuelBarr:draw()
  love.graphics.setColor(0.8, 0.6, 0.3, 0.7)
  local y = love.mouse.getY()
  if y > windowSize.y*gameScale - 40*gameScale then
    love.graphics.setColor(0.8, 0.6, 0.3, 0.2)
  end

  love.graphics.rectangle("fill", 0, windowSize.y-30, windowSize.x*(self.light.fuel/self.light.fuelMax), 30)
end

return fuelBarr