local strategy = {
	new = function (max, name, price, priceUpper)
		local instance = setmetatable({}, {__index=strategy}) 
		instance.level = 0
		instance.maxLevel = max
		instance.price = price
		instance.priceUpper = priceUpper
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
	new = function (addValue, maxLevel, name, price, priceUpper)
		local instance = setmetatable(strategy.new(maxLevel, name, price, priceUpper), {__index=addStrategy})
		instance.addValue = addValue
		instance.use = function (self, value)
			return value + self.addValue * self.level
		end
		return instance
	end
}, {__index=strategy})

local multiplyStrategy = setmetatable({
	new = function (multiValue, maxLevel, name, price, priceUpper)
		local instance = setmetatable(strategy.new(maxLevel, name, price, priceUpper), {__index=multiplyStrategy})
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
				basic = addStrategy.new(2, 10, "basicDamage", {["darkEssence"] = 1}, 5),
				more = addStrategy.new(10, 4, "moreDamage", {["darkEssence"] = 20}, 10),
			},
			mul = {
				sharp = multiplyStrategy.new(1.05, 5, "sharpLight", {["darkEssence"] = 50}, 50)
			}
		},
		size = {
			add = {
				visor = addStrategy.new(1.50, 10, "basicDamage", {["darkEssence"] = 75}, 40),
				
			},
			mul = {
				bright = multiplyStrategy.new(1.20, 3, "brightLight", {["darkEssence"] = 100}, 250)
			}
		},
		speed = {
			add = {
				fast = addStrategy.new(2.75, 20, "fastMovement", {["darkEssence"] = 55}, 20),
			},
		}
	}
}