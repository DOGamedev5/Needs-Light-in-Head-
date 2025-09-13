local enemy = setmetatable({}, {__index = EnemyClass})

enemy.texture = love.graphics.newImage("src/ocean/enemies/tier1/enemy1/enemy1.png")
enemy.width, enemy.height = enemy.texture:getDimensions()
enemy.sortOffset = enemy.height


function enemy.new(x, y)
  local instance = setmetatable({}, {__index = enemy})
  instance.body = love.physics.newBody(World, x, y, "dynamic")
  instance.shape = love.physics.newCircleShape(16)
  instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
  instance.fixture:setCategory(1)
  instance.fixture:setMask(1)
  instance.speed = 20

  return instance
end

function enemy:draw()
  
  love.graphics.draw(self.texture, self.body:getX() - self.width, self.body:getY() - self.height, 0, 2, 2)
end

function enemy:update(delta)
  local dirX, dirY = Vector.normalize(windowSize.x/2 - self.body:getX(), windowSize.y/2 - self.body:getY())
  self.body:setLinearVelocity(dirX * self.speed, dirY * self.speed)

  print(dirX, dirY, self.body:isAwake())

end

return enemy
