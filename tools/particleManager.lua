ParticleManager = {}

ParticleManager.particles = {}

function ParticleManager:addParticle(particle, posX, posY, amount)
	self.particles[#self.particles+1] = {
		part = particle,
		x = posX,
		x = posY,
		id = love.math.random()
	}
	self.particles[#self.particles].part:emit(amount)
end

function ParticleManager:update(delta)
  for i=#self.particles, 1, -1 do
    if self.particles[i].part:getCount() == 0 then
      table.remove(self.particles, i)
    else
    	print(self.particles[i].part:getCount())
      --self.particles[i].part:update(delta)
    end
  end
end

function ParticleManager:draw()
	local particles = {unpack(self.particles)}
	--table.sort(particles, tools.ysort)
	for i, o in ipairs(particles) do
    	love.graphics.setColor(1, 1, 1, 1)
    	love.graphics.draw(o.part, o.x, o.y, 0, 2, 2)
  	end
end


