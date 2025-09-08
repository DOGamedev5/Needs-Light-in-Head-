local menu = {}

function menu:load()
  self.buttons = {}
  self.buttons[1] = Button.new("play", 40, 40, 200, 50, self.playPressed)
  self.buttons[2] = Button.new("options", 40, 90, 200, 50, self.optionsPressed)
  self.buttons[3] = Button.new("exit", 40, 140, 200, 50, self.exitPressed)

  self.buttons[1]:setNextUI(nil, self.buttons[2])
  self.buttons[2]:setNextUI(self.buttons[1], self.buttons[3])
  self.buttons[3]:setNextUI(self.buttons[3])
end

function menu:update(delta)
  for i, b in ipairs(self.buttons) do
    b:update(delta)
  end
end

function menu:draw()
  --camera:attach()
  for i, b in ipairs(self.buttons) do
    b:draw()
  end
  --camera:detach()
end

function menu:input(event, value)
  for i, b in ipairs(self.buttons) do
    b:input(event, value)
  end
end

function menu:mouseMoved(x, y, dx, dy, touch)
  for i, b in ipairs(self.buttons) do
    b:mouseMoved(x, y, dx, dy, touch)
  end
end

function menu.playPressed()
  sceneManager.changeScene(2)
end

function menu.optionsPressed()

end

function menu.exitPressed()
  love.event.quit(0)
end

function menu:mousePressed(x, y, button, touch, presses)
  for i, b in ipairs(self.buttons) do
    b:mousePressed(x, y, button, touch, presses)
  end
end

return menu
