world = nil

-- local baton = require 'plugins.baton'
lovepatch = require("plugins.lovepatch")
Timer = require("plugins.hump.timer")
Vector = require("plugins.hump.vector-light")
-- Camera = require("plugins.hump.camera")
anim8 = require("plugins.anim8")
require("tools.input")

--[[input = baton.new {
  controls = {
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
    action = {'key:x', 'keyk', 'button:a'},
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

