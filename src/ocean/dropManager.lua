local dropManager = {}

dropManager.dropsInst = {
	["darkEssence"] = require("src.ocean.drops.darkEssence.darkEssence")
}
dropManager.drops = {}

function dropManager:addDrop(drop, x, y, sizeExplo)
	self.drops[#self.drops + 1] = self.dropsInst[drop].new(x, y, sizeExplo)
end

function dropManager:update(delta)
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

return dropManager