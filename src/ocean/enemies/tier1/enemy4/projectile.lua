local projectile = {}

projectile.texture = love.graphics.newImage("src/ocean/enemies/tier1/enemy4/projectile.png")
projectile.particleTexture = love.graphics.newImage("src/ocean/enemies/tier1/enemy4/particle.png")
projectile.damage = 10

local grid = anim8.newGrid(9, 192, 36, 192)
local animation = anim8.newAnimation(grid:getFrames("2-4", 1), {0.06, 0.06, 0.06}, "pauseAtEnd")

local ps = love.graphics.newParticleSystem(projectile.particleTexture, 8)
ps:setDirection(math.rad(-90))
ps:setEmissionArea("ellipse", 8, 8)

ps:setEmitterLifetime(1.3)
ps:setLinearAcceleration(0.05, 0, 0.46, 0)
ps:setLinearDamping(0.81, 1.0)
ps:setOffset(4, 4)
ps:setParticleLifetime(0.3, 0.5)
ps:setRelativeRotation(true)
ps:setRotation(0, math.rad(360))
ps:setSpeed(50, 85)
ps:setSpin(1.2, 0.1)
ps:setSpinVariation(0)
ps:setSpread(2.6)
local particleQuads = {
	love.graphics.newQuad(0, 0, 8, 8, 24, 8),
	love.graphics.newQuad(8, 0, 8, 8, 24, 8),
	love.graphics.newQuad(16, 0, 8, 8, 24, 8)
}
ps:setQuads(
	particleQuads[1],
	particleQuads[1],
	particleQuads[1],
	particleQuads[2],
	particleQuads[3]
)


function projectile.new(x, y)
	local instance = setmetatable({}, {__index=projectile})

	instance.x = x
	instance.y = y+40
	instance.particleHandler = ps:clone()
	instance.particleImpactHandler = ps:clone()
	instance.particleHandler:emit(12)
	instance.time = 0
	instance.toDie = false
	instance.animation = animation:clone()
	instance.state = 0

	return instance
end

function projectile:update(delta)
	self.particleHandler:update(delta)
	self.particleImpactHandler:update(delta)
	--self.time = self.time + delta
	self.animation:update(delta)
	if self.animation.status == "paused" and self.state == 0 then
		self.state = 1
		self.animation.flippedV = true
		self.animation:pauseAtStart()
		self.animation:resume()
		self.x = windowSize.x/2
		self.y = windowSize.y/2+32
	elseif self.animation.status == "paused" and self.state == 1 then
		self.state = 2
		self.particleImpactHandler:emit(12)
		currentScene.ocean.lighthouse:damage(self.damage)
	elseif self.particleImpactHandler:isStopped() and self.state == 2 then
		self.toDie = true
	end
end

function projectile:draw()
	love.graphics.draw(self.particleHandler, self.x, self.y-48, 0, 2, 2)
	love.graphics.draw(self.particleImpactHandler, self.x, self.y-48, 0, 2, 2)
	--if self.animation.status ~= "paused" and self.state == 0 then
	if self.state < 2 then self.animation:draw(self.texture, self.x, self.y-48, 0, 2, 2, 4.5, 192) end
	--elseif self.state == 1 then
	--	self.animation:draw(self.texture, 0, -48, 0, 2, 2, 4.5, 192)
	--end
end

function projectile:die()

end

return projectile