world = nil

require("tools.fileSystem")
require("src.ocean.enemies.enemyClass")
require("src.ocean.drops.dropClass")

-- local baton = require 'plugins.baton'
lovepatch = require("plugins.lovepatch")
Timer = require("plugins.hump.timer")
Vector = require("plugins.hump.vector-light")
-- Camera = require("plugins.hump.camera")
anim8 = require("plugins.anim8")
require("tools.input")

love.graphics.setDefaultFilter("nearest", "nearest")

require("tools.button")
require("src.ocean.lightHouse.lightBarr.lightBarr")

require("plugins.hump.camera")
require("tools.sceneManager")

require("src.hud")