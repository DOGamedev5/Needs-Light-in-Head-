Input = {}

local actions = {
  left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
  right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
  up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
  down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
  action = {'key:x', 'key:k', 'button:a'},
  confirm = {'key:return', 'mouse:l', 'button:b'}
}

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

