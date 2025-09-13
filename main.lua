main = {}

windowSize = {
  x = 800,
  y = 500
}

tools = {
	AABB = require("tools.aabbDetect"),
	WF = require("plugins.windfield"),
  sign = function (n)
    if n < 0 then
      return -1
    elseif n > 0 then
      return 1
    else
      return 0
    end
  end,
  lerp = function (n1, n2, l)
    return n1 + (n2-n1)*l
  end,
  ysort = function (a, b)
    local AsortOffset = a.sortOffset or 0
    local BsortOffset = b.sortOffset or 0
    local aY, bY = a.y, b.y
    if not aY and a.body then
      aY = a.body:getY()
    end
    if not bY and b.body then
      bY = b.body:getY()
    end
    if b.reference == "light" then
      --return true
    end
    if a.reference == "light" then
      --return false
    end

    return aY + AsortOffset < bY + BsortOffset
  end
}

lastMousePosition = {
  x = 0,
  y = 0
}

gameScale = 1
pading = {
  x = 0,
  y = 0
}

function love.load()
  World = love.physics.newWorld(0 , 0, true)
  require("startup")
  love.math.setRandomSeed(love.timer.getTime())

  local ww, wh = love.graphics.getDimensions()
  resizeWindow(ww, wh)
  sceneManager.changeScene(1)
end

function love.update(delta)
  resizeWindow(love.graphics.getDimensions())
  World:update(delta)
  sceneManager.update(delta)
end

function toGame(x, y)
  local ww, wh = love.window.getDesktopDimensions()

  x, y = (x - pading.x) / gameScale, (y - pading.y) / gameScale

  return x, y
end

function love.draw()
  love.graphics.clear()
  love.graphics.setBackgroundColor(0, 0, 0, 1)
  love.graphics.setScissor(pading.x, pading.y, windowSize.x*gameScale, windowSize.y*gameScale)
  love.graphics.push()
  
  love.graphics.translate(pading.x, pading.y)
  love.graphics.scale(gameScale, gameScale)
  
  love.graphics.setColor(1, 1, 1)
  sceneManager.draw()

  love.graphics.pop()
end

function love.mousepressed(x, y, button, touch, presses)
  sceneManager.mousePressed(x, y, button, touch, presses)
end

function love.keyboardpressed(key, scancode, presses)
  Input.keyboardPress(key, scancode, presses)
end

function love.mousemoved(x, y, dx, dy, touch)
  sceneManager.mouseMoved(x, y, dx, dy, touch)
  lastMousePosition.x = x
  lastMousePosition.y = y
end

function love.keyboardreleased(key, scancode)
  Input.keyboardRelease(key, scancode)
end

function love.gamepadaxis(joystick, axis, value)
  Input.gamepadAxis(joystick, axis, value)
end

function love.gamepadpressed(joystick, button)
  Input.gamepadPress(joystick, button)
end

function love.gamepadreleased(joystick, button)
  Input.gamepadRelease(joystick, button)
end

function main.input(event, value)
  sceneManager.input(event, value)
end

function love.resize(w, h)
  resizeWindow(w, h)
  --Push:resize(w, h)
end

function resizeWindow(w, h)
  gameScale = h / windowSize.y   
  pading.x = (w - (gameScale * windowSize.x))/2
end
