local game = {}

game.ocean = require("src.ocean.ocean")

function game:load()
  game.ocean:init() 
end

function game:update(delta)
  game.ocean:update(delta)
end

function game:draw()
  game.ocean:draw()
end

function game:input(event, value)
  
end

return game
