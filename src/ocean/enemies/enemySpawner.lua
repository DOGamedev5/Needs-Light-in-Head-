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
	self.spawnTimer = 7
	self.rules = {}
	self.enemiesInst ={
		require("src.ocean.enemies.tier1.enemy1.enemy1"),
	}
end

function EnemySpawner:init(enemies, spawnRules, sides, maxtime)
	self.spawnSide.left = false
	self.spawnSide.right = false
	self.spawnSide.up = false
	self.spawnSide.down = false

	for _, side in pairs(sides) do
		self.spawnSide[side] = true
	end

	self.enemiesClass = enemies
	self.rules = spawnRules
	self.timeMax = maxtime or 90
	self.spawnTimer = 7
end

function EnemySpawner:update(delta)
	--self.timerControl:update(delta)
	self.timeAlive = self.timeAlive + delta
	self.spawnTimer = self.spawnTimer - delta
	if self.spawnTimer <= 0 then
		self:spawnEnemy()
		self.spawnTimer = love.math.random(9, 12)
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

function EnemySpawner:spawnEnemy()
	local porc = love.math.random(1, 100)
	local amount = 0
	if porc <= 30 then amount = 1 end

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
	for k, v in pairs(self.rules) do
		if self.timeAlive >= v[1] and self.timeAlive <= v[2] then
			possible[#possible+1] = k
		end
	end
	if #possible == 0 then return end
	local choosen = love.math.random(1, #possible)
	return self.enemiesInst[choosen]
end

return EnemySpawner