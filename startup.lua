love.graphics.setDefaultFilter("nearest", "nearest")

fonts = {
	normal = love.graphics.newImageFont(
		"assets/fonts/SimpleFont.png", 
		" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-+/\\:,;=!.?", 1),
	small = love.graphics.newImageFont(
		"assets/fonts/smolFont.png",
		" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZáéíóúàèìòùâêîôû0123456789.,%+-" , 1)
}

world = nil

lovepatch = require("plugins.lovepatch")
Timer = require("plugins.hump.timer")
Vector = require("plugins.hump.vector-light")
anim8 = require("plugins.anim8")

require("classes.hud.stringHandler")
require("classes.hud.tooltip")
require("classes.hud.button")
require("classes.hud.listOrder")
require("classes.stateMachine")
require("classes.bufferRegion")
require("classes.waveSegment")

require("src.classes.lightBarr.lightBarr")
require("src.ocean.enemies.enemyClass")
require("src.ocean.drops.dropClass")

require("tools.configuration")
require("tools.input")
require("tools.tween")
require("tools.upgradeManager")
require("tools.translateManager")
require("tools.fileSystem")
require("tools.sceneManager")

--require("src.ocean.lightHouse.lightBarr.lightBarr")
require("src.hud")