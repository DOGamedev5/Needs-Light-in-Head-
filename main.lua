tools = {
	AABB = require("tools.aabbDetect"),
	WF = require("plugins.windfield"),
}

function love.load()
  require("startup")
  sceneManager.changeScene(1)
end

function love.update(delta)
  sceneManager.update(delta)
end

function love.draw()
  sceneManager.draw()
  love.graphics.clear()
end
