local dropManager = {}

dropManager.dropsInst = {
	["darkEssence"] = require("src.ocean.drops.darkEssence.darkEssence")
}
dropManager.drops = {}
dropManager.rules = {}
local dropTimerMax = 5
local dropTimer = dropTimerMax

function dropManager:init(dayInfo)
	for i=#self.drops, 1, -1 do
		self.drops[i]:remove()
		table.remove(self.drops, i)
	end

	self.rules = dayInfo.dropRules
end

function dropManager:addDrop(drop, x, y, sizeExplo)
	self.drops[#self.drops + 1] = self.dropsInst[drop].new(x, y, sizeExplo)
end

function dropManager:update(delta)
	dropTimer = dropTimer - delta * self.rules.frequency

	for i=#self.drops, 1, -1 do
    	if self.drops[i].toCollect then
        	self.drops[i]:collect()
      		table.remove(self.drops, i)
    	else
      	self.drops[i]:update(delta)
    	end
  	end
end

function dropManager:draw()
	for i=1, #self.drops do
		self.drops[i]:draw()
	end
end

function dropManager:generateDrop()
	
end

return dropManager