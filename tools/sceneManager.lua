sceneManager = {}

local sceneList = {
  require("src.menu")
}

local currentScene = {}

function sceneManager.changeScene(id)
  assert(sceneList[id] ~= nil, string.format("sceneManager erro: does not have the scene id: %d", id))

  currentScene = sceneList[id]
  if currentScene.load then
    currentScene:load()
  end
end

function sceneManager.update(delta)
  if currentScene.update then
    currentScene:update(delta)
  end
end

function sceneManager.draw()
  if currentScene.draw then
    currentScene:draw()
  end
end

function sceneManager.mousePressed()
  
end
