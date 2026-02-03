local EnemySpawner = {}

function EnemySpawner:load()
	self.enemiesClass = {}
	self.instances = {}
	self.spawnSide = {
		left = false,
		right = false,
		up = false,
		down = false
	}
	--self.timerControl = Timer.new()
	self.timeAlive = 0.0
	self.timeMax = 90
	self.frequency = 1
	self.spawnTimer = 2
	self.rules = {}
	self.enemiesInst ={
		["1-1"] = require("src.ocean.enemies.tier1.enemy1.enemy1"),
		["1-2"] = require("src.ocean.enemies.tier1.enemy2.enemy2"),
		["1-3"] = require("src.ocean.enemies.tier1.enemy3.enemy3"),
	}
end

function EnemySpawner:init(dayInfo)
	self.spawnSide.left = false
	self.spawnSide.right = false
	self.spawnSide.up = false
	self.spawnSide.down = false

	for _, side in pairs(dayInfo.sides) do
		self.spawnSide[side] = true
	end
	for i=#self.instances, 1, -1 do
		self.instances[i]:remove()
		table.remove(self.instances, i)
	end

	self.enemiesClass = dayInfo.enemies
	self.rules = dayInfo.rules
	self.timeAlive = 0
	self.timeMax = dayInfo.time or 90
	self.frequency = dayInfo.frequency
	self.spawnTimer = 7
	self.amount = dayInfo.amount
	self.groupPerc = self.rules.groupPerc[1][2]
	self.spawnPerc = self.rules.percent[1][2]
end

function EnemySpawner:update(delta)
	--self.timerControl:update(delta)
	self.timeAlive = self.timeAlive + delta
	self.spawnTimer = self.spawnTimer - delta * self.frequency
	self:updateRules()
	if self.spawnTimer <= 0 then
		self:spawnEnemy()
		self:setTimer()
	end

	for i=#self.instances, 1, -1 do
	    if self.instances[i].toDie then
	    	self.instances[i]:die()
	        table.remove(self.instances, i)
	    else
	        self.instances[i]:update(delta)
		end
	end
end

function EnemySpawner:updateRules()
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

function EnemySpawner:spawnEnemy()
	local porc = love.math.random(1, 100)
	local amount = self.amount[1]-1
	if porc <= self.groupPerc then amount = love.math.random(self.amount[1], self.amount[2]-1) end

	local function spawn()
		local side = self:getSideSpawn()
		local enemy = self:getEnemySpawn()
		if enemy == null then
			return 
		end

		local posX = 0
		local posY = 0 
		if side == "up" or side == "down" then
			posX = love.math.random(windowSize.x)
			if side == "down" then
				posY = windowSize.y + (enemy.offsetSpawn or 0)
			else
				posY = 0 - (enemy.offsetSpawn or 0)
			end
		elseif side == "right" or side == "left" then
			posY = love.math.random(windowSize.y)
			if side == "right" then
				posX = windowSize.x + (enemy.offsetSpawn or 0)
			else
				posX = 0 - (enemy.offsetSpawn or 0)
			end
		end
		self.instances[#self.instances + 1] = enemy.new(posX, posY)
	end
	for i=0, amount do
		spawn()
	end
end

function EnemySpawner:getSideSpawn()
	local possible = {}
	local side = 1
	for k,v in pairs(self.spawnSide) do
		if v then
			possible[#possible+1] = k
		end
	end
	side = love.math.random(1, #possible)
	return possible[side]
end

function EnemySpawner:getEnemySpawn()
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
	return self.enemiesInst[choosen]
end

function EnemySpawner:setTimer()
	self.spawnTimer = love.math.random(12, 15) - self.frequency
end

return EnemySpawner