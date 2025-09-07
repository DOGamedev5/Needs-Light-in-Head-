Button = {}
--Button.__index = Button

Button.font = love.graphics.newFont("assets/fonts/BoldPixels.ttf", 32, "normal")


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
  love.graphics.setColor(100/255, 130/255, 150/255)
  
  if self.hover or self.selected then
    love.graphics.setColor(120/255, 180/255, 190/255)
  end
  if self.pressed then
    love.graphics.setColor(80/255, 100/255, 120/255)
  end


  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(self.font)
  local wid = self.font:getWidth(self.text)
  local hei = self.font:getHeight(self.text)

  love.graphics.print(self.text, self.font,
    self.x + self.width/2 - wid/2,
    self.y + self.height/2 - hei/2
  )
end

function Button:update(delta)
  local posX, posY = love.mouse.getPosition()
  self.hover = tools.AABB.detectPoint(posX, posY, self.x, self.y, self.width, self.height)
  self.timer:update(delta)
end

function Button:mousePressed(x, y, button, touch, presses)
  if (button == 1 or touch) and tools.AABB.detectPoint(x, y, self.x, self.y, self.width, self.height) and not pressed then
    self.timer:after(0.2, self.pressedFunction)
    self.timer:after(0.1, function () self.pressed = false end)

    -- self.pressedFunction()
    self.pressed = true
  end
end

function Button:input(event, value)
  print(event == Input.UP_INPUT)

  if event == Input.UP_INPUT and self.selected and value == 1 then
    if self.upUI ~= nil then
      if self.upUI.selected ~= nil then
        if not self.lastSelected then
          self.upUI.selected = true
          self.upUI.lastSelected = true
          self.selected = false
        else
          self.lastSelected = false
        end
      end
    end
  elseif event == Input.DOWN_INPUT and self.selected and value == 1 then
    if self.downUI ~= nil then
      if self.downUI.selected ~= nil then
        if not self.lastSelected then
          self.downUI.selected = true
          self.downUI.lastSelected = true
          self.selected = false
        else
          self.lastSelected = false
        end      end 
    end
  end
end
