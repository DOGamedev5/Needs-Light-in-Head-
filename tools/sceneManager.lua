sceneManager = {}

local sceneList = {
  require("src.menu"),
  require("src.game")
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

function sceneManager.mousePressed(x, y, button, touch, presses)
  if currentScene.mousePressed then
    currentScene:mousePressed(x, y, button, touch, presses)
  end
end

function sceneManager.mouseRelease(x, y, button, touch, presses)
  if currentScene.mouseRelease then
    currentScene:mouseRelease(x, y, button, touch, presses)
  end
end

function sceneManager.mouseMoved(x, y, dx, dy, touch)
  if currentScene.mouseMoved then
    currentScene:mouseMoved(x, y, dx, dy, touch)
  end
end

function sceneManager.input(event, value)
  if currentScene.input then
    currentScene:input(event, value)
  end
end
