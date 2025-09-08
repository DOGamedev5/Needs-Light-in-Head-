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

    return a.y + AsortOffset < b.y + BsortOffset
  end
}

lastMousePosition = {
  x = 0,
  y = 0
}

function love.load()
  require("startup")
  local ww, wh = love.window.getDesktopDimensions()
  Push:setupScreen(windowSize.x, windowSize.y, ww, wh, {fullscreen = true, vsync = true, resizable = false})
  --camera = Camera(windowSize.x/2, windowSize.y/2)
  --camera:lockWindow(windowSize.x/2, windowSize.y/2) --, 0, 0, windowSize.x, windowSize.y)
  sceneManager.changeScene(1)
end

function love.update(delta)
  --input:update()
  sceneManager.update(delta)
end

function love.draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  Push:start()
  love.graphics.clear()
  love.graphics.setColor(1, 1, 1)
  sceneManager.draw()
  Push:finish()
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
  Push:resize(w, h)
end
