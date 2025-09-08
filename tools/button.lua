Button = {}
--Button.__index = Button

Button.font = love.graphics.newFont("assets/fonts/BoldPixels.ttf", 32, "normal")
Button.textures = {
  menu = {
    lovepatch.load("assets/buttons/menu/menu1.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu2.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu3.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu4.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu5.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu6.png", 5, 5, 5, 5),
  }
}


function Button.new(text, x, y, width, height, pressedFunction)
  local instance = setmetatable({}, {__index = Button})
  instance.text = text or ""
  instance.x = x
  instance.y = y
  instance.hover = false
  instance.pressedFunction = pressedFunction
  instance.pressed = false
  instance.lastsSelected = false
  instance.selected = false
  instance.width = width
  instance.height = height
  instance.timer = Timer.new()
  return instance
end

function Button:setNextUI(upUI, downUI, leftUI, rightUI)
  self.upUI = upUI
  self.downUI = downUI
  self.leftUI = leftUI
  self.rightUI = rightUI
end

function Button:draw()
  local imageId = 1

  -- love.graphics.setColor(100/255, 130/255, 150/255)
  
  if self.hover then
    imageId = 2
    --love.graphics.setColor(120/255, 180/255, 190/255)
  end
  if self.pressed then
    imageId = 3
    --love.graphics.setColor(80/255, 100/255, 120/255)
  end
  if self.selected then
    imageId = imageId + 3
  end

  --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(1, 1, 1, 1)
  lovepatch.draw(self.textures.menu[imageId], self.x, self.y, self.width, self.height, 2, 2)

  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(self.font)
  local wid = self.font:getWidth(self.text)
  local hei = self.font:getHeight(self.text)

  love.graphics.print(self.text, self.font,
    self.x + self.width/2 - wid/2,
    self.y + self.height/2 - hei/2
  )
end

function Button:mouseMoved(x, y, dx, dy, touch)
  local posX, posY = Push:toGame(x, y)
  self.hover = tools.AABB.detectPoint(posX, posY, self.x, self.y, self.width, self.height)
end

function Button:update(delta)
  self.timer:update(delta)
end

function Button:press()
  self.timer:after(0.2, self.pressedFunction)
  self.timer:after(0.1, function () self.pressed = false end)
  self.pressed = true
end

function Button:mousePressed(x, y, button, touch, presses)
  local tx,ty = Push:toGame(x, y)
  if (button == 1 or touch) and tools.AABB.detectPoint(tx, ty, self.x, self.y, self.width, self.height) and not self.pressed then
    self:press()
  end
end

function Button:input(event, value)
  if event == Input.CONFIRM_INPUT and self.selected and not self.pressed then
    self:press()
  end
end
