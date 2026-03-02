local EnemySpawner = {}

EnemySpawner.enemiesInst = {}
EnemySpawner.waveInfo = {}
EnemySpawner.beated = false
EnemySpawner.instances = {}

local randomOffset = 192
local waveDelayMax = 5
local waveDelayTimer = waveDelayMax
local waveTimer = 0
local currentWave = 1

function EnemySpawner:load()
	
end

local enemyPathBase = "src.ocean.enemies.tier%d.enemy%d.enemy%d"
local enemy_cache = {

}
local cacheSize = 0
local maxCache = 10

local function updateCache()
	cacheSize = cacheSize + 1

	if cacheSize > maxCache then
		enemy_cache = {}
		cacheSize = 0
	end

end

function EnemySpawner:init(dayInfo)
	self.rules = dayInfo.gameplay
	self.beated = false

	self.enemiesInst = {}
	for i, v in ipairs(self.rules.loadEnemies) do
		if enemy_cache[v] then
			self.enemiesInst[v] = enemy_cache[v]
		else
			local minus, _ = string.find(v, "-")
			local tier = string.sub(v, 1, minus-1)
			local id = string.sub(v, minus+1, #v)
			local path = string.format(enemyPathBase, tier, id, id)

			self.enemiesInst[v] = require(path)
			enemy_cache[v] = self.enemiesInst[v]
			updateCache()
		end
	end

	waveTimer = 0
	currentWave = 1
	self:waveSetup()
end

function EnemySpawner:waveSetup()
	waveTimer = 0
	waveDelayTimer = waveDelayMax

	if currentWave <= #self.rules.waves then
		self.waveInfo = {table.unpack(self.rules.waves[currentWave])}
	else
		waveDelayTimer = waveDelayTimer + 2
	--	self.beated = true
	end
end

function EnemySpawner:update(delta)
	if not self.beated then 
		if waveDelayTimer > 0 then
			waveDelayTimer = waveDelayTimer - delta
		elseif currentWave > #self.rules.waves and #self.instances == 0 then
			self.beated = true
		else
			self:waveUpdate(delta)
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
end

local function getRandomSidePosition(side, offsetSpawn)
	local posX, posY = 0, 0

	if side == "up" or side == "down" then
		posX = love.math.random(windowSize.x)
		if side == "down" then
			posY = windowSize.y + (offsetSpawn)
		else
			posY = 0 - (offsetSpawn)
		end
	elseif side == "right" or side == "left" then
		posY = love.math.random(windowSize.y)
		if side == "right" then
			posX = windowSize.x + (offsetSpawn or 0)
		else
			posX = 0 - (offsetSpawn)
		end
	end

	return posX, posY
end

function EnemySpawner:waveUpdate(delta)
	waveTimer = waveTimer + delta

	for i=#self.waveInfo, 1, -1 do
		if waveTimer > self.waveInfo[i].delay then
			self:spawnWave(self.waveInfo[i])
			table.remove(self.waveInfo, i)
		end
	end

	if #self.instances == 0 and #self.waveInfo == 0 then
		currentWave = currentWave + 1
		
		self:waveSetup()
	end

end

function EnemySpawner:spawnWave(wave)
	for enemy, amount in pairs(wave.enemies) do
		local instReference = self.enemiesInst[enemy]

		for i=1, amount do
			local offsetSpawn = (instReference.offsetSpawn or 0) + love.math.random(randomOffset)

			local posX, posY = getRandomSidePosition(wave.side, offsetSpawn)
			table.insert(self.instances, instReference.new(posX, posY))
		end
	end
end

function EnemySpawner:clear()
	for i=#self.instances, 1, -1 do
    	self.instances[i]:remove()
        table.remove(self.instances, i)
	end
end

return EnemySpawner