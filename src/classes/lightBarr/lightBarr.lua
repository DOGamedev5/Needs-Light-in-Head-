LightBarr = {}

LightBarr.lightBarrTexture = {
  lovepatch.load("src/classes/lightBarr/lightFuel1.png", 2, 2, 1, 1),
  lovepatch.load("src/classes/lightBarr/lightFuel2.png", 2, 2, 1, 1)
}

LightBarr.max = 80
LightBarr.current = 10

function LightBarr.new(max, size)
  local instance = setmetatable({}, {__index = LightBarr}) 

  instance.max = max
  instance.current = max
  instance.size = size
  instance.x = 0
  instance.y = 0

  return instance
end

function LightBarr:setPosition(x, y)
  self.x = x
  self.y = y
end

function LightBarr:updateFuel(value)
	self.current = value
end

function LightBarr:getCurrentValue()
	return self.current
end

function LightBarr:draw()
  love.graphics.setColor(1, 1, 1, 0.7)
  lovepatch.draw(self.lightBarrTexture[1], self.x- self.size/2, self.y, self.size, 12, 2, 2)

  local percent = self.current / self.max

  if percent*self.size > 5 then
    lovepatch.draw(self.lightBarrTexture[2], self.x- self.size/2, self.y, percent*self.size, 12, 2, 2)
  end
  love.graphics.setColor(1, 1, 1, 1)
end