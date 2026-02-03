love.graphics.setDefaultFilter("nearest", "nearest")

fonts = {
	normal = love.graphics.newImageFont(
		"assets/fonts/SimpleFont.png", 
		" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-+/\\:,;=", 1),
	small = love.graphics.newImageFont(
		"assets/fonts/smolFont.png",
		" abcdefghijklmnopqrstuvwxyz0123456789" , 1)
}

world = nil

require("tools.fileSystem")
require("src.ocean.enemies.enemyClass")
require("src.ocean.drops.dropClass")
require("tools.stateMachine")
--require("tools.particleManager")
require("tools.listOrder")
require("tools.tween")
require("tools.bufferRegion")

-- local baton = require 'plugins.baton'
lovepatch = require("plugins.lovepatch")
Timer = require("plugins.hump.timer")
Vector = require("plugins.hump.vector-light")
-- Camera = require("plugins.hump.camera")
anim8 = require("plugins.anim8")
require("tools.input")


require("tools.button")
require("src.ocean.lightHouse.lightBarr.lightBarr")

require("plugins.hump.camera")
require("tools.sceneManager")

require("src.hud")