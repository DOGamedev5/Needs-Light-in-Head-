local enemy = setmetatable({}, {__index = EnemyClass})

enemy.texture = love.graphics.newImage("src/ocean/enemies/tier1/enemy1/enemy1.png")

function enemy.new(x, y)
  local instance = setmetatable({}, {__index = enemy})
  instance.body = love.physics.newBody(World, x, y)
  instance.shape = love.physics.newCircleShape(16)
  instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
  
  return instance
end

function enemy:draw()
  
  love.graphics.draw(self.texture, self.body:getX(), self.body:getY(), 0, 2, 2)
end

return enemy
