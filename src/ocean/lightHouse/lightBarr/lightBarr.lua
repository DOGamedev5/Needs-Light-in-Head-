LightBarr = {}

LightBarr.lightBarrTexture = {
  lovepatch.load("src/ocean/lightHouse/lightBarr/lightFuel1.png", 2, 2, 1, 1),
  lovepatch.load("src/ocean/lightHouse/lightBarr/lightFuel2.png", 2, 2, 1, 1)
}

LightBarr.max = 80
LightBarr.current = 10

function LightBarr.new(max)
  local instance = setmetatable({}, {__index = LightBarr}) 

  instance.max = max
  instance.current = max

  return instance
end

function LightBarr:init()
  self.x = windowSize.x/2
  self.y = windowSize.y/2
end

function LightBarr:updateFuel(value)
	self.current = value
end

function LightBarr:getCurrentValue()
	return self.current
end

function LightBarr:draw()
  love.graphics.setColor(1, 1, 1, 0.7)
  lovepatch.draw(self.lightBarrTexture[1], self.x- self.max/2, self.y+20, self.max, 12, 2, 2)
  if self.current > 5 then
    lovepatch.draw(self.lightBarrTexture[2], self.x- self.max/2, self.y+20, self.current, 12, 2, 2)
  end
  love.graphics.setColor(1, 1, 1, 1)
end