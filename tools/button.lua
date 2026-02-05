ButtonBase = {}
Button = setmetatable({}, {__index = ButtonBase})
--Button.__index = Button
ButtonImage = setmetatable({}, {__index = ButtonBase})


Button.font = love.graphics.newFont("assets/fonts/BoldPixels.ttf", 32, "normal")
ButtonBase.textures = {
  menu = {
    lovepatch.load("assets/buttons/menu/menu1.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu2.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu3.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu4.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu5.png", 5, 5, 5, 5),
    lovepatch.load("assets/buttons/menu/menu6.png", 5, 5, 5, 5),
  }
}

function ButtonBase.construct(instance)
  instance.hover = false
  instance.pressed = false
  instance.lastsSelected = false
  instance.selected = false
  instance.timer = Timer.new()
  instance.args = {}
  instance.centered = false

  return instance
end

function ButtonBase:setupArgs(args)
  self.args = args
end

function ButtonBase:mouseMoved(x, y, dx, dy, touch)
  local posX, posY = toGame(x, y)
  local oX, oY = 0, 0
  if self.centered then
    oX, oY = self.width/2, self.height/2
  end

  self.hover = tools.AABB.detectPoint(posX, posY, self.posX - oX, self.posY - oY, self.width, self.height)
end

function ButtonBase:update(delta)
  self.timer:update(delta)
  if self.pressed and not love.mouse.isDown(1) then
    self.pressed = false
  end
end

function ButtonBase:press()
  if type(self.pressedFunction) == "function" then 
    self.timer:after(0.2, function()
    self.pressedFunction(unpack(self.args)) end
    )
  end
  self.timer:after(0.1, function () self.pressed = false end)

end

function ButtonBase:mousePressed(x, y, button, touch, presses)
  local tx,ty = toGame(x, y)
  local oX, oY = 0, 0
  
  if self.centered then
    oX, oY = self.width/2, self.height/2
  end

  if (button == 1 or touch) and tools.AABB.detectPoint(tx, ty, self.posX - oX, self.posY - oY, self.width, self.height) and not self.pressed then
    self.pressed = true
  end
end

function ButtonBase:mouseReleased(x, y, button, touch)
  local tx,ty = toGame(x, y)
  local oX, oY = 0, 0
  
  if self.centered then
    oX, oY = self.width/2, self.height/2
  end

  if (button == 1 or touch) and tools.AABB.detectPoint(tx, ty, self.posX - oX, self.posY - oY, self.width, self.height) and self.pressed then
    self:press()
  else
    self.pressed = false
  end
end

function ButtonBase:input(event, value)
  if event == Input.CONFIRM_INPUT and self.selected and not self.pressed then
    self:press()
  end
end

function ButtonBase:setNextUI(upUI, downUI, leftUI, rightUI)
  self.upUI = upUI
  self.downUI = downUI
  self.leftUI = leftUI
  self.rightUI = rightUI
end

function ButtonBase.draw(self)
  local imageId = 1
  
  if self.hover then
    imageId = 2
  end
  if self.pressed then
    imageId = 3
  end
  if self.selected then
    imageId = imageId + 3
  end

  love.graphics.setColor(1, 1, 1, 1)

  local tx, ty = self.posX, self.posY
  if self.centered then
    tx, ty = tx - self.width/2, ty - self.height/2
  end

  lovepatch.draw(self.textures.menu[imageId], tx, ty, self.width, self.height, 2, 2)
end

function ButtonImage.new(image, x, y, width, height, pressedFunction)
  local instance = setmetatable({}, {__index = ButtonImage})
  instance = ButtonBase.construct(instance)
  instance.image = image
  instance.posX = x
  instance.posY = y
  instance.pressedFunction = pressedFunction
  instance.width = width
  instance.height = height
  
  return instance
end

function Button.new(text, x, y, width, height, pressedFunction)
  local instance = setmetatable({}, {__index = Button}) 
  instance = ButtonBase.construct(instance)
  instance.text = text or ""
  instance.posX = x or 0
  instance.posY = y or 0
  instance.width = width or 1
  instance.height = height or 1

  instance:updateSize()

  instance.pressedFunction = pressedFunction
  
  return instance
end

function Button:draw()
  ButtonBase.draw(self)

  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(self.font)
  local wid = self.font:getWidth(self.text)
  local _, count = string.gsub(self.text, "\n", "")
  local hei = self.font:getHeight(self.text)*(count+1)

  local tx, ty = self.posX, self.posY
  if self.centered then
    tx, ty = tx - self.width/2, ty - self.height/2
  end


  love.graphics.print(self.text, self.font,
    tx + self.width/2 - wid/2,
    ty + self.height/2 - hei/2
  )
end

function Button:changeText(text)
  self.text = text
end

function Button:getDimentions()
  return self.width, self.height
end

function Button:updateSize()
  local wid = self.font:getWidth(self.text) + 25
  local _, count = string.gsub(self.text, "\n", "")
  local hei = self.font:getHeight(self.text)*(count+1) + 10

  if self.width < wid then self.width = wid end
  if self.height < hei then self.height = hei end
end