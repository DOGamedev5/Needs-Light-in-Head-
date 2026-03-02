local lightHouse = {}

--lightHouse.texture = love.graphics.newImage("src/ocean/lightHouse/lighthouse.png")
lightHouse.texture = love.graphics.newImage("src/ocean/lightHouse/boat.png")
lightHouse.sortOffset = 15
lightHouse.light = nil
lightHouse.texturewidth, lightHouse.textureheight = lightHouse.texture:getDimensions()
lightHouse.texturegrid= anim8.newGrid(lightHouse.texturewidth / 4, lightHouse.textureheight/3, lightHouse.texturewidth, lightHouse.textureheight)
lightHouse.animations = {
  anim8.newAnimation(lightHouse.texturegrid('1-4', 1), 0.3),
  anim8.newAnimation(lightHouse.texturegrid('1-4', 2), 0.2, "pauseAtEnd"),
  anim8.newAnimation(lightHouse.texturegrid('1-1', 3), 1, "pauseAtEnd"),
}
lightHouse.width = lightHouse.texturewidth/4
lightHouse.height = lightHouse.textureheight/3

local shieldTimer = 0
local shieldTimerMax = 0.8

function lightHouse:init(light)
  self.light = light
  shieldTimerMax = 1.2
  
  self.currentAnimation = 1

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
  shieldTimer = shieldTimer - delta 
  self.animations[self.currentAnimation]:update(delta)
end

function lightHouse:draw()
  local offsetX = 0
  local offsetY = math.sin(love.timer.getTime()*0.25)*4
  love.graphics.setColor(1, 1, 1)

  if shieldTimer > 0 then
    local fade = 0.5 * (shieldTimer/shieldTimerMax) + 0.1*math.cos(shieldTimer*2.0)
    love.graphics.setColor(1-fade, 1-fade, 1-fade)
  end

  self.animations[self.currentAnimation]:draw(self.texture, self.x - self.width + offsetX, self.y - self.height-48 + offsetY, math.rad(0.2)*offsetY/2, 2, 2) ---self.width/2, -self.height)
  love.graphics.setColor(1, 1, 1)
end

function lightHouse:damage(dmg)
  if shieldTimer <= 0 then
    self.light:damageFuel(UpgradeManager:apply("light", "damageResist", dmg))
    shieldTimer = shieldTimerMax
  end
end

return lightHouse
