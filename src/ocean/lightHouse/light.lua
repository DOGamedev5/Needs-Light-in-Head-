local light = {}

light.x = 0
light.y = 0
light.speed = 300
light.radius = 50
light.direction = 0
light.target = {x = 0, y = 0}

function light:init()
  self.x, self.y = toGame(lastMousePosition.x, lastMousePosition.y)
  self.timer = Timer.new()
  self.target.x, self.target.y = self.x, self.y
end

function light:update(delta)
  local distX, distY = self.target.x - self.x, self.target.y - self.y
  local dirX, dirY = Vector.normalize(distX, distY)
  
  if self.x ~= self.target.x or self.y ~= self.target.y then
    local oldX, oldY = self.x, self.y 
    
    self.x = self.x + dirX*self.speed*delta
    self.y = self.y + dirY*self.speed*delta

    if ((oldX < self.target.x and self.x > self.target.x) or (oldX > self.target.x and self.x < self.target.x)) then 
      self.x = tools.lerp(oldX, self.target.x, delta*0.5)
    end
    if ((oldY < self.target.y and self.y > self.target.y) or (oldY > self.target.y and self.y < self.target.y)) then
      self.y = tools.lerp(oldY, self.target.y, delta*0.5)
    end
  end
  self.timer:update(delta)
end

function light:draw()
  love.graphics.setColor(236*2/255, 201*2/255, 64*2/255, 0.2)
  love.graphics.circle("fill", self.x, self.y, self.radius)
  love.graphics.setColor(236*2/255, 201*2/255, 64*2/255, 0.1)

  local poligon = self:rayLight()
  love.graphics.polygon("fill", unpack(poligon))
  love.graphics.setColor(1, 1, 1, 1)
end

function light:rayLight()
  local poligon = {}
  poligon[1] = windowSize.x/2
  poligon[2] = windowSize.y/2 - 88
  
  --local angleMin = ((36-2) * math.pi)/36
  local dir = math.atan2(poligon[2] - self.y, poligon[1] - self.x) + math.pi
  local circle = {}

  for i=-8, 27, 1 do
    local newDir = (dir + math.pi*3/4) - (i/18*math.pi)
    circle[1+(i+8)*2] = self.x + ((math.cos(newDir))*self.radius)
    circle[2+(i+8)*2] = self.y + ((math.sin(newDir))*self.radius)
  end
  if Vector.len(self.x - poligon[1], self.y - poligon[2]) <= self.radius then
    return circle
  end
  local offset = 0
  
  for i = 10+offset, (16-offset)*2, 1 do
    poligon[3+(i-(10+offset))*2] = circle[1 + (i*2)]
    poligon[4+(i-(10+offset))*2] = circle[2 + (i*2)]
  end
  
  return poligon
end

function light:mouseMoved(x, y, dx, dy, touch)
  self.target.x, self.target.y = toGame(x, y)
end

return light
