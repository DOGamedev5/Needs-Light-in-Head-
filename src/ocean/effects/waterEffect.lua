local waterEffect = {}

waterEffect.waterShader = love.graphics.newShader("src/ocean/water.glsl")
waterEffect.waterTexture = love.graphics.newImage("assets/wave.png")
waterEffect.waterNormal = love.graphics.newImage("assets/normalTest.png")
waterEffect.waterGlow = love.graphics.newImage("assets/glowEffect.png")
waterEffect.waterTexture:setWrap("repeat", "repeat")
waterEffect.waterNormal:setWrap("repeat", "repeat")
waterEffect.waterGlow:setWrap("repeat", "repeat")
waterEffect.waterShader:send("normalMap", waterEffect.waterNormal)
waterEffect.waterShader:send("glowMap", waterEffect.waterGlow)

waterEffect.backGroundColor = {}

function waterEffect:updateOverColor(colors )
	self.waterShader:send("overColor", colors)
end

function waterEffect:setWaterColor(color)
	waterEffect.backGroundColor = color
end

function waterEffect:update()
	self.waterShader:send("time", love.timer.getTime())
end

function waterEffect:draw()
	love.graphics.setShader(self.waterShader)
    	love.graphics.setColor(self.backGroundColor[1], self.backGroundColor[2], self.backGroundColor[3])
   		--love.graphics.setColor(26/255, 39/255, 61/255)
    
 		love.graphics.draw(self.waterTexture, 0, 0, 0, windowSize.x/64, windowSize.y/64)

	love.graphics.setShader()

 	love.graphics.setColor(1, 1, 1)
end

return waterEffect