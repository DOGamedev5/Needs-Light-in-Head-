local IconButton = {}

IconButton.texture = love.graphics.newImage("src/initial/updateTree/Icons/upgradeButton.png")
IconButton.defaltIcon = love.graphics.newImage("src/initial/updateTree/Icons/light/damage/basic.png")
IconButton.width = 64
IconButton.height = 64
IconButton.quad = {
	love.graphics.newQuad(0, 0, 32, 32, IconButton.texture),
	love.graphics.newQuad(32, 0, 32, 32, IconButton.texture),
	love.graphics.newQuad(64, 0, 32, 32, IconButton.texture),
	love.graphics.newQuad(96, 0, 32, 32, IconButton.texture),
	love.graphics.newQuad(128, 0, 32, 32, IconButton.texture),
	love.graphics.newQuad(160, 0, 32, 32, IconButton.texture),
	love.graphics.newQuad(192, 0, 32, 32, IconButton.texture),
}
IconButton.shader = love.graphics.newShader([[
uniform float complete;

vec4 effect(vec4 Color, sampler2D text, vec2 textureCords, vec2 screenCords) {
	float s = step(1.0 - textureCords.y, complete);
	return Color * Texel(text, textureCords) * vec4(0.5 + 0.7 * s, 0.8 + 0.5*s, 0.8 + 0.4*s, 1);
}
]])
IconButton.shader:send("complete", 0)

function IconButton.new(tree, id, property, name)
	local instance = setmetatable({},  {__index=IconButton})
	instance.tree = tree

	instance.id = id
	instance.property = property
	instance.name = name
	
	instance.posX, instance.posY = UpgradeManager:getPosition(id, property, name)
	instance.requirements = UpgradeManager:getRequirements(id, property, name)
	instance.pname = UpgradeManager:getName(id, property, name)
	instance.description = UpgradeManager:getDescription(id, property, name)

	instance.fullTarget = 0
	instance.full = nil
	instance.visible = false
	instance.onScreen = false
	instance.unlocked = false
	instance.prices = {}
	instance.state = 0
	instance.hover = false
	instance.pressed = false
	--instance.toolTip = ToolTip.new(instance.pname)

	return instance
end

function IconButton:init()
	if self.image == nil then
		local path = string.format("src/initial/updateTree/Icons/%s/%s/%s.png",  self.id, self.property, self.name)
		if FileSystem.fileExist(path) then
			self.image = love.graphics.newImage(path)
		else
			self.image = self.defaltIcon
		end

	end
	self:updateInfo()
end

function IconButton:updateInfo()
	self.level, self.levelMax = UpgradeManager:getLevelInfo(self.id, self.property, self.name)
	self.prices = UpgradeManager:getPrice(self.id, self.property, self.name)
	
	self.visible = true
	self.unlocked = true

	self.fullTarget = self.level / (self.levelMax)
	if self.full == nil then self.full = self.fullTarget end

	if self.requirements ~= nil then
		--self.visible = false
		for k, v in ipairs(self.requirements) do
			local level, max = UpgradeManager:getLevelInfo(v[1], v[2], v[3])
			if level < v[4] then
				self.unlocked = false
			end
			if level > 0 or max == 0 then
				self.visible = true
			end
			if self.visible and not self.unlocked then break end
		end
	end

	if not self.visible or not self.unlocked then
		self.state = 0
		return
	end

	if self.level >= self.levelMax then
		self.state = 3
		return
	end

	self.state = 2
	for k, v in pairs(self.prices) do
		if (currentScene.save.collects[k] or 0) < v then
			self.state = 1
			break
		end
	end
end

function IconButton:update(delta)
	if self:detectAABB(0, 0, true) then
		if not self.onScreen then
			self.onScreen = true
			self:init()
		end

		if self.full ~= nil then
			self.full = tools.lerp(self.full, self.fullTarget, 6*delta)
		end

		if self.pressed and not love.mouse.isDown(1) then
    	self.pressed = false
  	end
	else
		self.onScreen = false
	end
end

function IconButton:drawLine()
	if self.requirements == nil or not self.visible then return end

	for i, v in ipairs(self.requirements) do
			local level, max = UpgradeManager:getLevelInfo(v[1], v[2], v[3])
			local reqX, reqY = UpgradeManager:getPosition(v[1], v[2], v[3])
			
			local treqX, treqY, _ = self:translatePosition(reqX, reqY)
			local tx, ty, offset = self:translatePosition(self.posX, self.posY)

			local dirX, dirY = Vector.normalize(treqX - tx, treqY - ty)

			local offsetX = dirX * (40 * self.tree.scale)
			local offsetY = dirY * (40 * self.tree.scale)

			if math.abs(dirY) > math.abs(dirX) then
				offsetY = tools.sign(dirY)*offset
			elseif math.abs(dirX) > math.abs(dirY) then
				offsetX = tools.sign(dirX)*offset
			end

			local x1, y1 = tx + offsetX, ty + offsetY
			local x2, y2 = treqX - offsetX, treqY - offsetY
			--local x1, y1 = tx + offsetX - self.tree.posX, ty + offsetY - self.tree.posY
			--local x2, y2 = treqX - offsetX - self.tree.posX, treqY - offsetY - self.tree.posY

			love.graphics.setLineStyle("rough")
			love.graphics.setLineWidth(6)
			love.graphics.setColor(0.2, 0.3, 0.4)
			love.graphics.line(x1, y1, x2, y2)
			love.graphics.setLineWidth(2)
			love.graphics.setColor(1, 1, 1)
			if level < v[4] then
				love.graphics.setColor(0.4, 0.3, 0.6)
			end

			love.graphics.line(x1, y1, x2, y2)
	end
end

function IconButton:draw()
	self:drawLine()

	if not self.onScreen or not self.visible then
		return
	end

	local quadId = 1 + self.state
	if self.state ~= 0 and self.hover then

		quadId = quadId + 3
	end 

	local scale = 2
	if self.pressed then scale = 1.8 end

	scale = scale * self.tree.scale

	local tx, ty, _ = self:translatePosition(self.posX, self.posY)

	self.shader:send("complete", self.full)

	if self.state ~= 3 or self.hover then love.graphics.setShader(self.shader) end
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.texture, self.quad[quadId], tx, ty, 0, scale, scale, 16, 16)
	love.graphics.setShader()

	love.graphics.setColor(1, 1, 1)
	if self.state == 0 then love.graphics.setColor(0, 0, 0.05) end
	love.graphics.draw(self.image, tx, ty, 0, scale, scale, 16, 16)

end

function IconButton:mouseMoved(x, y, dx, dy, touch)
  local posX, posY = toGame(x, y)

  if posY > windowSize.y-self.tree.pad then
  	self.hover = false 
  	return
  end

  local hovered = self:detectAABB(posX, posY)

  if self.hover ~= hovered then 
  	self.hover = hovered
  	if hovered then
  		self.tree:setSelect(self)
  	elseif self.tree.select == self then
  		self.tree:setSelect(nil)
  	end
  end 
end

function IconButton:press()
	if self.state == 2 then
		self:buy()
	end
end

function IconButton:buy()
	for k, v in pairs(self.prices) do
		currentScene.save.collects[k] = currentScene.save.collects[k] - v 
		UpgradeManager:buy(self.id, self.property, self.name)
	end
	self.tree:updateInfo()
end

function IconButton:mousePressed(x, y, button, touch, presses)
  local tx,ty = toGame(x, y)

  if (button == 1 or touch) and self:detectAABB(tx, ty) and not self.pressed and self.state ~= 3 then
    self.pressed = true
  end
end

function IconButton:mouseReleased(x, y, button, touch)
  local tx,ty = toGame(x, y)
  local inside = self:detectAABB(tx, ty) and self.pressed

  if inside then
    if touch then
    	local oldHover = self.hover 
    	self.hover = true
    	if self.hover ~= oldHover then 
		  		self.tree:setSelect(self)
		  end 
    else
    	self:press()
  	end
  elseif touch then
  	if self.tree.select == self then
  		self.tree:setSelect(nil)
  	end
 	end
  self.pressed = false

end

function IconButton:getDescription()
	local result = TranslateManager:getReference("upgradesDesc", self.description)
	local name = TranslateManager:getReference("misc", self.id)
	local property = TranslateManager:getReference("properties", self.property)
	local value = UpgradeManager:getNextValue(self.id, self.property, self.name)

	result = string.gsub(string.gsub(string.gsub(result, "$name", name), "$property", property), "$value", value)

	return result
end

function IconButton:detectAABB(x, y, screen)
	local posX, posY, offset = self:translatePosition(self.posX, self.posY)
	posX = posX - offset
	posY = posY - offset
	screen = screen or false

	if screen then
		return tools.AABB.detect(0, 0, windowSize.x, windowSize.y, posX, posY, self.width * self.tree.scale, self.height * self.tree.scale)
	else
		return tools.AABB.detectPoint(x, y, posX, posY, self.width * self.tree.scale, self.height * self.tree.scale)
	end
end

function IconButton:translatePosition(x, y)
	local scale = self.tree.scale
	local offset = 32 * scale
	local posX = ((x - windowSize.x/2) * scale) + windowSize.x/2 - self.tree.posX - offset
	local posY = ((y - windowSize.y/2) * scale) + windowSize.y/2 - self.tree.posY - offset

	return posX, posY, offset
end

return IconButton