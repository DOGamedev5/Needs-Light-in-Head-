local lightHouse = {}

--lightHouse.texture = love.graphics.newImage("src/ocean/lightHouse/lighthouse.png")
lightHouse.texture = love.graphics.newImage("src/ocean/lightHouse/boat.png")
lightHouse.sortOffset = 15
lightHouse.light = nil


function lightHouse:init(light)
  self.light = light
  self.texturewidth, self.height = self.texture:getDimensions()
  self.texturegrid= anim8.newGrid(self.texturewidth / 4, self.height, self.texturewidth, self.height)
  self.animation = anim8.newAnimation(self.texturegrid('1-4', 1), 0.3)
  self.width = self.texturewidth/4
  --local wx, wy = love.graphics.getDimensions()
  self.x = windowSize.x/2
  self.y = windowSize.y/2

  self.body = love.physics.newBody(World, self.x, self.y, "dynamic")
  self.shape = love.physics.newCircleShape(64)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setSensor(true)
  self.fixture:setCategory(3)
  self.fixture:setUserData(self)
  self.body:setUserData("lightHouse")

end

function lightHouse:update(delta)
  self.animation:update(delta)
end

function lightHouse:draw()
  self.animation:draw(self.texture, self.x - self.width, self.y - self.height-48, 0, 2, 2)
end

function lightHouse:damage(dmg)
  self.light:damageFuel(dmg)
end

return lightHouse
