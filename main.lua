main = {}

tools = {
	AABB = require("tools.aabbDetect"),
	WF = require("plugins.windfield"),
}

function love.load()
  require("startup")
  sceneManager.changeScene(1)
end

function love.update(delta)
  --input:update()
  sceneManager.update(delta)
end

function love.draw()
  love.graphics.clear()
  sceneManager.draw()
end

function love.mousepressed(x, y, button, touch, presses)
  sceneManager.mousePressed(x, y, button, touch, presses)
end

function love.keyboardpressed(key, scancode, presses)
  Input.keyboardPress(key, scancode, presses)
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
