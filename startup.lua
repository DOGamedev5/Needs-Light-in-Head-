world = nil

local baton = require 'plugins.baton'

--[[input = baton.new {
  controls = {
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
    action = {'key:x', 'key:k', 'button:a'},
    confirm = {'key:return', 'mouse:l', 'button:b'}
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}]]--

love.graphics.setDefaultFilter("nearest", "nearest")

require("tools.button")

require("plugins.hump.camera")
require("tools.sceneManager")

