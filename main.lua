entities = {}

tools = {
  AABB = require("tools.aabbDetect")
}

function love.load()
  
end

function love.update(delta)
  for index, entity in ipairs(entities) do
    entity:update()
  end     
end

function love.draw()
  for index, entity in ipairs(entities) do
    entity:draw()
  end

  love.graphics.print(tostring(tools.AABB.detect(2, 2, 10, 10, 1, 1, 6, 6)), 100, 100, 0, 10)
end

