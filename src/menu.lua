local menu = {}



function menu:load()
  self.currentScreen = 0

  self.buttons = {}
  self.buttons[1] = Button.new("play", 40, 40, 200, 50, self.playPressed)
  self.buttons[2] = Button.new("options", 40, 90, 200, 50, self.optionsPressed)
  self.buttons[3] = Button.new("exit", 40, 140, 200, 50, self.exitPressed)

  self.buttons[1]:setNextUI(nil, self.buttons[2])
  self.buttons[2]:setNextUI(self.buttons[1], self.buttons[3])
  self.buttons[3]:setNextUI(self.buttons[3])
  self.options = require("src.options")
  self.options:load(self)
  self.saves = require("src.saves")
  self.saves:load(self)
end

function menu:update(delta)
  if self.currentScreen == 0 then
    for i, b in ipairs(self.buttons) do
      b:update(delta)
    end
  elseif self.currentScreen == 1 then
    self.options:update(delta)
  elseif self.currentScreen == 2 then
    self.saves:update(delta)
  end
end

function menu:draw()
  --camera:attach()
  for i, b in ipairs(self.buttons) do
    b:draw()
  end
  --camera:detach()
  if self.currentScreen == 1 then
    self.options:draw()
  elseif self.currentScreen == 2 then
    self.saves:draw()
  end
end

function menu:input(event, value)
  if self.currentScreen == 0 then
    for i, b in ipairs(self.buttons) do
      b:input(event, value)
    end
  elseif self.currentScreen == 1 then
    self.options:input(event, value)
  elseif self.currentScreen == 2 then
    self.saves:input(event, value)
  end
end

function menu:mouseMoved(x, y, dx, dy, touch)
  if self.currentScreen == 0 then
    for i, b in ipairs(self.buttons) do
      b:mouseMoved(x, y, dx, dy, touch)
    end
  elseif self.currentScreen == 1 then
    self.options:mouseMoved(x, y, dx, dy, touch)
  elseif self.currentScreen == 2 then
    self.saves:mouseMoved(x, y, dx, dy, touch)
  end
end

function menu.playPressed()
  menu.currentScreen = 2
end

function menu.optionsPressed()
  menu.currentScreen = 1
end

function menu.exitPressed()
  love.event.quit(0)
end

function menu.exitOptions()
  menu.currentScreen = 0
end

function menu.startGame(file)
  currentGameFile = file
  sceneManager.changeScene(2)
end

function menu:mousePressed(x, y, button, touch, presses)
  if self.currentScreen == 0 then
    for i, b in ipairs(self.buttons) do
      b:mousePressed(x, y, button, touch, presses)
    end
  elseif self.currentScreen == 1 then
    self.options:mousePressed(x, y, button, touch, presses)
  elseif self.currentScreen == 2 then
    self.saves:mousePressed(x, y, button, touch, presses)
  end
end

return menu
