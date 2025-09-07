Input = {}

Input.RIGHT_INPUT = 0
Input.LEFT_INPUT = 1
Input.UP_INPUT = 2
Input.DOWN_INPUT = 3
Input.ACTION_INPUT = 4

local actions = {
  left = {key = {'left', 'a'}, axis = {'leftx-'}, button = {'dpleft'}},
  right = {key = {'right', 'd'}, axis = {'leftx+'}, button = {'dpright'}},
  up = {key = {'up', 'w'}, axis = {'lefty-'}, button = {'dpup'}},
  down = {key = {'down', 's'}, axis = {'lefty+'}, button = {'dpdown'}},
  action = {key = {'x', 'k'}, button = {'a'}},
  confirm = {key = {'return'}, mouse = {'l'}, button = {'b'}}
}

local pairs = {
  move = {'left', 'right', 'up', 'down'}
}

function Input.keyboardPress(key, scancode, repeats)
  
end

function Input.keyboardRelease(key, scancode)
  
end

function Input.gamepadAxis(joystick, axis, value)
  
end

function Input.gamepadPress(joystick, button)
  if button == "dpup" then
    main.input(Input.UP_INPUT, 1)
  elseif button == "dpdown" then
    main.input(Input.DOWN_INPUT, 1)
  end

end

function Input.gamepadRelease(joystick, button)
  if button == "dpup" then
    main.input(Input.UP_INPUT, 0) 
  elseif button == "dpdown" then
    main.input(Input.DOWN_INPUT, 0)
  end
end
