local light = {}

light.x = 0
light.y = 0
light.speed = 300
light.radius = 50
light.direction = 0

function light:init()
  self.x, self.y = love.mouse.getPosition()
  self.timer = Timer.new()
end

function light:update(delta)
  local targetX, targetY = love.mouse.getPosition()
  
  local distX, distY = targetX - self.x, targetY - self.y
  local dirX, dirY = Vector.normalize(distX, distY)

  if self.x ~= targetX or self.y ~= targetY then
    local oldX, oldY = self.x, self.y 
    
    self.x = self.x + dirX*self.speed*delta
    self.y = self.y + dirY*self.speed*delta

    if ((oldX < targetX and self.x > targetX) or (oldX > targetX and self.x < targetX)) then 
      self.x = tools.lerp(oldX, targetX, delta*4)
    end
    if ((oldY < targetY and self.y > targetY) or (oldY > targetY and self.y < targetY)) then
      self.y = tools.lerp(oldY, targetY, delta*4)
    end
  end
  self.timer:update(delta)
end

function light:draw()
  love.graphics.setColor(236*2/255, 201*2/255, 64*2/255, 0.3)
  love.graphics.circle("fill", self.x, self.y, self.radius)
  love.graphics.setColor(1, 1, 1, 1)
end

return light
