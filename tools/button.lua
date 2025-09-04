Button = {}
--Button.__index = Button

Button.font = love.graphics.newFont("assets/fonts/BoldPixels.ttf", 32, "normal")

function Button.new(text, x, y, width, height)
  local instance = setmetatable({}, {__index = Button})
  instance.text = text or ""
  instance.x = x
  instance.y = y
  instance.hover = false
  instance.pressed = false
  instance.selected = false
  instance.width = width
  instance.height = height
  return instance
end

function Button:draw()
  love.graphics.setColor(100/255, 130/255, 150/255)
  
  if self.hover or self.selected then
    love.graphics.setColor(120/255, 180/255, 190/255)
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

function Button:update()
  local posX, posY = love.mouse.getPosition()
  self.hover = tools.AABB.detectPoint(posX, posY, self.x, self.y, self.width, self.height)
end
