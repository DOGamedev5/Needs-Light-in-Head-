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
    if aY == nil and a.body then
      aY = a.body:getY()
    end
    if bY == nil and b.body then
      bY = b.body:getY()
    end
    local AhudTag = a.hud or false
    local BhudTag = b.hud or false
    
    return aY + AsortOffset < bY + BsortOffset
  end,
  erase = function (t, value, all)
    all = all or false
    for i=#t, 1, -1 do
      if t[i] == value then
        table.remove(t, i)
        if all then break end
      end
    end
  end,
  size = function (t)
    local n = 0
    for k, v in ipairs(t) do
      n = n + 1
    end
    return n
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
currentGameFile = 1
isPaused = false

local screenBlacked = 0.1

function love.load()

  World = love.physics.newWorld(0 , 0, true)
  World:setCallbacks(worldBegincontact, worldAftercontact)
  require("startup")
  love.math.setRandomSeed(love.timer.getTime())

  local ww, wh = love.graphics.getDimensions()
  resizeWindow(ww, wh)
  sceneManager.changeScene(1)
end

function love.update(delta)
  if screenBlacked > 0 then screenBlacked = screenBlacked - delta end
  if screenBlacked > 0 then
    return
  end
  love.graphics.setDefaultFilter("nearest", "nearest")

  resizeWindow(love.graphics.getDimensions())
  
  if not isPaused then
    World:update(delta)
  end


  sceneManager.update(delta)
end

function toGame(x, y)
  local ww, wh = love.window.getDesktopDimensions()

  x, y = (x - pading.x) / gameScale, (y - pading.y) / gameScale

  return x, y
end

function love.draw()
  love.graphics.setBackgroundColor(0, 0, 0, 1)   
  love.graphics.reset()
  if screenBlacked > 0 then 
    return
  end
  
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

function worldBegincontact(a, b, col)
  sceneManager.beginContact(a, b, col)
end

function worldAftercontact(a, b, col)
  sceneManager.afterContact(a, b, col)  
end

function love.quit()
  
  return false
end

function main.input(event, value)
  if screenBlacked > 0 then
    return
  end
  sceneManager.input(event, value)
end

function love.resize(w, h)
  screenBlacked = 0.1
  resizeWindow(w, h)
end

function resizeWindow(w, h)
  gameScale = h / windowSize.y   
  pading.x = (w - (gameScale * windowSize.x))/2
end