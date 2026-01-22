sceneManager = {}

local sceneList = {
  require("src.menu.menu"),
  require("src.game")
}

currentScene = {}

function sceneManager.changeScene(id)
  assert(sceneList[id] ~= nil, string.format("sceneManager erro: does not have the scene id: %d", id))
  
  if currentScene.exit then
    currentScene:exit()
  end

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

function sceneManager.mouseReleased(x, y, button, touch, presses)
  if currentScene.mouseReleased then
    currentScene:mouseReleased(x, y, button, touch, presses)
  end
end

function sceneManager.mouseMoved(x, y, dx, dy, touch)
  if currentScene.mouseMoved then
    currentScene:mouseMoved(x, y, dx, dy, touch)
  end
end

function sceneManager.beginContact(a, b, col)
  if currentScene.beginContact then
    currentScene:beginContact(a, b, col)
  end
end

function sceneManager.afterContact(a, b, col)
  if currentScene.afterContact then
    currentScene:afterContact(a, b, col)
  end
end

function sceneManager.input(event, value)
  if currentScene.input then
    currentScene:input(event, value)
  end
end
