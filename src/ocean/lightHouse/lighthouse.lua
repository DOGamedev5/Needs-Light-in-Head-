local lightHouse = {}

--lightHouse.texture = love.graphics.newImage("src/ocean/lightHouse/lighthouse.png")
lightHouse.texture = love.graphics.newImage("src/ocean/lightHouse/boat.png")
lightHouse.sortOffset = 15
lightHouse.light = nil


function lightHouse:init(light)
  self.light = light
  self.texturewidth, self.textureheight = self.texture:getDimensions()
  self.texturegrid= anim8.newGrid(self.texturewidth / 4, self.textureheight/3, self.texturewidth, self.textureheight)
  self.animations = {
    anim8.newAnimation(self.texturegrid('1-4', 1), 0.3),
    anim8.newAnimation(self.texturegrid('1-4', 2), 0.2, "pauseAtEnd"),
    anim8.newAnimation(self.texturegrid('1-1', 3), 1, "pauseAtEnd"),
  }
  self.currentAnimation = 1
  self.width = self.texturewidth/4
  self.height = self.textureheight/3

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
  if self.light.fuel == 0 then
    if self.currentAnimation ~= 2 then
      self.currentAnimation = 2
      self.animations[self.currentAnimation].timer = 0
    end
    if self.animations[self.currentAnimation].status == "paused" then
      currentScene.ocean:finished(false)
    end
  end
  self.animations[self.currentAnimation]:update(delta)
end

function lightHouse:draw()
  local offsetX = 0
  local offsetY = math.sin(love.timer.getTime()*0.25)*4
  --love.graphics.setColor(0.7, 0.75, 0.9)
  self.animations[self.currentAnimation]:draw(self.texture, self.x - self.width + offsetX, self.y - self.height-48 + offsetY, math.rad(0.2)*offsetY/2, 2, 2) ---self.width/2, -self.height)
  love.graphics.setColor(1, 1, 1)
end

function lightHouse:damage(dmg)
  self.light:damageFuel(dmg)
end

return lightHouse
