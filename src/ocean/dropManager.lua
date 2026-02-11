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

	self.dropsID = self.rules.drops
	self.timeAlive = 0
	self.timeMax = dayInfo.time or 90
	self.frequency = self.rules.frequency
	dropTimer = dropTimerMax
	self.amount = self.rules.amount
	self.groupPerc = self.rules.groupPerc[1][2]
	self.spawnPerc = self.rules.percent[1][2]

end

function dropManager:addDrop(drop, x, y, sizeExplo)
	self.drops[#self.drops + 1] = self.dropsInst[drop].new(x, y, sizeExplo)
	--print(drop)
end

function dropManager:update(delta)
	dropTimer = dropTimer - delta * self.frequency
	self.timeAlive = self.timeAlive + delta
	self:updateRules()

	if dropTimer <= 0 then
		dropTimer = dropTimerMax
		self:generateDrop()
	end

	for i=#self.drops, 1, -1 do
    	if self.drops[i].toCollect then
        	self.drops[i]:collect()
      		table.remove(self.drops, i)
    	elseif self.drops[i].toRemove then
        	self.drops[i]:remove()
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

function dropManager:updateRules()
	local ruleId = 1
	for i, v in ipairs(self.rules.groupPerc) do
		ruleId = i
		if self.timeAlive < v[1] then
			break
		end
	end
	self.groupPerc = self.rules.groupPerc[ruleId][2]

	for i, v in ipairs(self.rules.percent) do
		ruleId = i
		if self.timeAlive < v[1] then
			break
		end
	end
	self.spawnPerc = self.rules.percent[ruleId][2]
end

function dropManager:generateDrop()
	local porc = love.math.random(1, 100)
	local amount = self.amount[1]-1
	if porc <= self.groupPerc then amount = love.math.random(self.amount[1], self.amount[2]-1) end

	local function spawn()
		local drop = self:getDrop()
		if drop == null then
			return 
		end

		local posX = love.math.random(5, windowSize.x-5)
		local posY = love.math.random(5, windowSize.y-5)
		
		self:addDrop(drop, posX, posY, 2)
		--self.instances[#self.instances + 1] = drop.new(posX, posY)
	end
	for i=0, amount do
		spawn()
	end
end

function dropManager:getDrop()
	local possible = {}
	local amount = 0
	for k, v in pairs(self.rules.spawn) do

		if self.timeAlive >= v[1] and self.timeAlive <= v[2] then
			for i=1, self.spawnPerc[k] do
				possible[#possible+1] = k
				amount = amount + 1
			end
		end
	end

	if amount == 0 then return end
	local choosen = possible[love.math.random(1, amount)]
	return collectsID[choosen]
end

return dropManager