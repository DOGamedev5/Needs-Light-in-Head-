local strategy = {
	new = function (max, name, price, priceUpper, pos, requirements)
		local instance = setmetatable({}, {__index=strategy}) 
		instance.level = 0
		instance.maxLevel = max
		instance.price = price
		instance.priceUpper = priceUpper
		instance.requirements = requirements
		instance.posX = pos[1]
		instance.posY = pos[2]

		instance.getPrice = function (self)
			if self.level == self.maxLevel then
				return nil
			end

			local prices = {}

			for k, v in pairs(self.price) do
				prices[k] = v + self.priceUpper * self.level 
			end

			return prices
		end

		return instance
	end,
	
}

local addStrategy = setmetatable({
	new = function (addValue, maxLevel, name, price, priceUpper, pos, requirements)
		local instance = setmetatable(strategy.new(maxLevel, name, price, priceUpper, pos, requirements), {__index=addStrategy})
		instance.addValue = addValue
		instance.use = function (self, value)
			return value + self.addValue * self.level
		end
		return instance
	end
}, {__index=strategy})

local multiplyStrategy = setmetatable({
	new = function (multiValue, maxLevel, name, price, priceUpper, pos, requirements)
		local instance = setmetatable(strategy.new(maxLevel, name, price, priceUpper, pos, requirements), {__index=multiplyStrategy})
		instance.multiValue = multiValue
		instance.use = function (self, value)
			return value * self.multiValue ^ (self.level)
		end

		return instance
	end
}, {__index=strategy})

return {
	light = {
		damage = {
			add = {
				basic = addStrategy.new(2, 10, "basicDamage", {["darkEssence"] = 1}, 5, {windowSize.x/2, windowSize.y/2-40}),
				more = addStrategy.new(10, 4, "moreDamage", {["darkEssence"] = 20}, 10, {windowSize.x/2-100, windowSize.y/2-40}, {{"light", "damage", "basic", 4}}),
			},
			mul = {
				sharp = multiplyStrategy.new(1.05, 5, "sharpLight", {["darkEssence"] = 50}, 50, {windowSize.x/2+100, windowSize.y/2-70}, {{"light", "damage", "basic", 2}})
			}
		},
		size = {
			add = {
				visor = addStrategy.new(1.50, 10, "basicDamage", {["darkEssence"] = 75}, 40, {windowSize.x/2-150, windowSize.y/2-140}, {{"light", "damage", "more", 4}}),
				
			},
			mul = {
				bright = multiplyStrategy.new(1.20, 3, "brightLight", {["darkEssence"] = 100}, 250, {windowSize.x/2-250, windowSize.y/2-140}, {{"light", "size", "visor", 5}})
			}
		},
		speed = {
			add = {
				fast = addStrategy.new(2.75, 20, "fastMovement", {["darkEssence"] = 55}, 20, {windowSize.x/2-250, windowSize.y/2-220}, {{"light", "size", "visor", 2}}),
			},
		},
		oil = {
			add = {
				lasting = addStrategy.new(2.75, 20, "longLasting", {["darkEssence"] = 55}, 20, {windowSize.x/2, windowSize.y/2+80}, {{"light", "damage", "basic", 1}, {"light", "damage", "more", 1}}),
			},

		}
	}
}