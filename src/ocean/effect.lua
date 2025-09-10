local effect = {}

function effect:_delay()
  self.ready = false
  self.timer:after(love.math.random(0., 1.2), function ()
    self:_setup()
  end)
end

function effect:_setup()
  self.id = love.math.random(1, #self.variants)
  local variant = self.variants[self.id]
  self.animation = anim8.newAnimation(variant.grid("1-"..tostring(variant.frames), 1), 0.6, 'pauseAtEnd')
  self.x, self.y = love.math.random(16, windowSize.x - 16), love.math.random(16, windowSize.y - 16)  
  self.ready = true
end

function effect._addVariant(path, frames, gridX, gridY)
  local result = {}
  result.texture = love.graphics.newImage(path)
  result.texturewidth, result.height = result.texture:getDimensions()
  result.grid = anim8.newGrid(gridX, gridY, result.texturewidth, result.height)
  --result.animation = anim8.newAnimation(result.grid("1-"..tostring(frames), 1), 3, 'pauseAtEnd')
  result.width = result.texturewidth/frames
  result.frames = frames
  return result
end


effect.variants = {
  effect._addVariant("src/ocean/effects/effect1.png", 5, 16, 16)
}

function effect.new()
  local instance = setmetatable({}, {__index=effect})
  instance.timer = Timer.new()
  instance:_delay()
  return instance
end

function effect:getPosition()
  local x, y = love.math.random(16, windowSize.x - 16), love.math.random(16, windowSize.y - 16)  
  return x, y
end


function effect:update(delta)
  self.timer:update(delta)
  if not self.ready then
    return
  end
  if self.animation.position == self.variants[self.id].frames then
    self.animation:pauseAtStart()
    self:_delay()
  end
  self.animation:update(delta)
end

function effect:draw()
  if self.ready then
    self.animation:draw(self.variants[self.id].texture, self.x, self.y, 0, 2, 2)
  end
end

return effect
