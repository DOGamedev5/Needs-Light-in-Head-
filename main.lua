main = {}

bloom = nil

windowSize = {
  x = 800,
  y = 500
}

confFile = "configuration.lua"

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
    local diff = (n2-n1) 
    if math.abs(diff) < 0.001 then
      return n2
    end

    return n1 + diff*l
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
        if not all then break end
      end
    end
  end,
  size = function (t)
    local n = 0
    for k, v in pairs(t) do
      n = n + 1
    end
    return n
  end,
  find = function(t, value)
    for i=#t, 1, -1 do
      if t[i] == value then
        return i   
      end
    end
  end,
  quantify = function(value)
    if value > 1000000 then
      return string.format("%.1fm", value/1000000)
    end

    if value > 1000 then
      return string.format("%.1fk", value/1000)
    end

    return tostring(value)
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
device = ""
control = ""

collectsID = {
  "darkEssence",
  "corruptEssence"
}

screenShake = {x = 0, y = 0}

function love.load()
  bloom = love.graphics.newShader("src/shaders/bloom.glsl")
  bloom:send("gamma", 1.0)
  setBloomConfig(1.0, 0.9, 1.2)
  canvas = love.graphics.newCanvas()
  canvasUI = love.graphics.newCanvas()
  --[[love.graphics.setCanvas(canvasUI)
  love.graphics.setBlendMode("alpha")
    love.graphics.translate(pading.x, pading.y)
    love.graphics.scale(gameScale, gameScale)
  love.graphics.setCanvas()
  ]]

  World = love.physics.newWorld(0 , 0, true)
  World:setCallbacks(worldBegincontact, worldAftercontact)
  require("startup")

  local ww, wh = love.graphics.getDimensions()
  resizeWindow(ww, wh)

  conf = {}
  conf.languege = "en"
  conf.version = "v0.1"
  
  if not FileSystem.fileExist(confFile) then
    FileSystem.writeFile(confFile, conf)
  else
    conf = FileSystem.loadFile(confFile)
  end

  local OS = love.system.getOS() 
  if OS == "Android" or OS == "iOS" then
    device = "mobile"
  else
    device = "desktop"
  end

  TranslateManager:loadLanguege(conf.languege)

  sceneManager.changeScene(1)
end

function love.update(delta)
  screenShake.x = tools.lerp(screenShake.x, 0, delta*7)
  screenShake.y = tools.lerp(screenShake.y, 0, delta*7)

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
  love.graphics.setCanvas(canvasUI)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    --love.graphics.translate(pading.x, pading.y)
    --love.graphics.scale(gameScale, gameScale)
  love.graphics.setCanvas()

  love.graphics.setCanvas({canvas, stencil=true})
  love.graphics.clear()
  love.graphics.setBackgroundColor(0, 0, 0, 1)   
  
  love.graphics.setBackgroundColor(0, 0, 0, 1)
  
  love.graphics.push()
  love.graphics.setBlendMode("alpha")
  
  love.graphics.translate(pading.x, pading.y)
  love.graphics.scale(gameScale, gameScale)
  
  love.graphics.setColor(1, 1, 1)

  sceneManager.draw()

  love.graphics.pop()
  love.graphics.setCanvas()
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")

  love.graphics.setShader(bloom)
  love.graphics.draw(canvas, screenShake.x, screenShake.y)
  love.graphics.setShader()
  love.graphics.draw(canvasUI, 0, 0)

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0, 0, pading.x, love.graphics.getHeight())
  love.graphics.rectangle("fill", love.graphics.getWidth() - pading.x, 0, pading.x, love.graphics.getHeight() + pading.y)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), pading.y)
  love.graphics.rectangle("fill", 0, love.graphics.getHeight() - pading.y, love.graphics.getWidth(), pading.y)
end

function love.mousepressed(x, y, button, touch, presses)
  sceneManager.mousePressed(x, y, button, touch, presses)
end

function love.mousereleased(x, y, button, touch, presses)
  sceneManager.mouseReleased(x, y, button, touch, presses)
end

function love.mousemoved(x, y, dx, dy, touch)
  sceneManager.mouseMoved(x, y, dx, dy, touch)
  lastMousePosition.x = x
  lastMousePosition.y = y
end

function love.keypressed(key, scancode, presses)
  Input.keyboardPress(key, scancode, presses)
  if key == "f11" then
    local full, _ = love.window.getFullscreen()
    love.window.setFullscreen(not full, "desktop")
  end
end

function love.keyreleased(key, scancode)
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
  sceneManager.quit()

  return false
end

function main.input(event, value)
  if screenBlacked > 0 then
    return
  end
  sceneManager.input(event, value)
end

function love.resize(w, h)
  resizeWindow(w, h)
  canvas = love.graphics.newCanvas()
  canvasUI = love.graphics.newCanvas()
end

function resizeWindow(w, h)
  gameScale = h / windowSize.y   
  pading.x = (w - (gameScale * windowSize.x))/2
end

function setBloomConfig(size, exposition, intensity)
    bloom:send("bloomSize", size)
    bloom:send("exposition", exposition)
    bloom:send("intensity", intensity)
end