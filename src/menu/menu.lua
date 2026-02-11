local menu = {}

--menu.backGround = love.graphics.newImage("assets/menu/background.png")
menu.lightTowerBackgroundTexture = love.graphics.newImage("assets/menu/lightTowerBackgroundAlt.png")
menu.lightTowerWid = menu.lightTowerBackgroundTexture:getWidth()
menu.lightTowerHei = menu.lightTowerBackgroundTexture:getHeight()
menu.lightTowerGrid = anim8.newGrid(menu.lightTowerWid / 4, menu.lightTowerHei, menu.lightTowerWid, menu.lightTowerHei)
menu.lightTowerAnimation = anim8.newAnimation(menu.lightTowerGrid:getFrames("1-4", 1), {0.5, 0.2, 0.5, 0.2})

menu.water = require("src.ocean.effects.waterEffect")

function menu:load()
  self.currentScreen = 0
  setBloomConfig(1.5, 0.85, 0.9)


  self.water:setWaterColor({5/255, 4/255, 8/255})
  self.water:updateOverColor({9/255*1.4, 18/255*1.4, 59/255*1.2, 0.9})

  self.buttons = {}
  self.buttons[1] = Button.new(TranslateManager.newReference("menu", "play"), 40, 40, 200, 50, self.playPressed)
  self.buttons[2] = Button.new(TranslateManager.newReference("menu", "options"), 40, 90, 200, 50, self.optionsPressed)
  self.buttons[3] = Button.new(TranslateManager.newReference("menu", "exit"), 40, 140, 200, 50, self.exitPressed)

  self.buttons[1]:setNextUI(nil, self.buttons[2])
  self.buttons[2]:setNextUI(self.buttons[1], self.buttons[3])
  self.buttons[3]:setNextUI(self.buttons[3])
  
  self.options = require("src.menu.options")
  self.options:load(self)
  self.saves = require("src.menu.saves")
  self.saves:load(self)
end

function menu:update(delta)
  self.water:update()
  self.lightTowerAnimation:update(delta)

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
  self.water:alternativeDraw(0, windowSize.y-128, windowSize.x, windowSize.y, 2.6/2, 1.6/2)
  local offset = math.sin(love.timer.getTime()*0.8)*4
  menu.lightTowerAnimation:draw(self.lightTowerBackgroundTexture, windowSize.x - 200, offset-10, 0, 2.1, 2.1)

  love.graphics.setCanvas(canvasUI)
  for i, b in ipairs(self.buttons) do
    b:draw()
  end
  if self.currentScreen == 1 then
    self.options:draw()
  elseif self.currentScreen == 2 then
    self.saves:draw()
  end
  love.graphics.setCanvas(canvas)
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

function menu:mouseReleased(x, y, button, touch, presses)
  if self.currentScreen == 0 then
    for i, b in ipairs(self.buttons) do
      b:mouseReleased(x, y, button, touch)
    end
  elseif self.currentScreen == 1 then
    self.options:mouseReleased(x, y, button, touch)
  elseif self.currentScreen == 2 then
    self.saves:mouseReleased(x, y, button, touch)
  end
end

return menu
