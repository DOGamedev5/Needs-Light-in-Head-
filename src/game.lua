local game = {}

game.ocean = require("src.ocean.ocean")

function game:load()
  game.ocean:init() 
end

function game:exit()
  game.ocean:exit()
end

function game:update(delta)
  game.ocean:update(delta)
  Hud:update(delta)
end

function game:draw()
  game.ocean:draw()
  Hud:draw()
end

function game:input(event, value)
  game.ocean:input(event, value)
end

function game:mouseMoved(x, y, dx, dy, touch)
  game.ocean:mouseMoved(x, y, dx, dy, touch)
end

function game:beginContact(a, b, col)
  game.ocean:beginContact(a, b, col)
end

function game:afterContact(a, b, col)
  game.ocean:afterContact(a, b, col)
  
end

return game
