local strategy = {
	new = function (max, name, price, pos, requirements, desc)
		local instance = setmetatable({}, {__index=strategy}) 
		instance.name = name

		instance.level = 0
		instance.maxLevel = max
		instance.priceRule = price
		instance.requirements = requirements
		instance.desc = desc
		instance.posX = pos[1]
		instance.posY = pos[2]

		instance.getPrice = function (self)
			if self.level == self.maxLevel then
				return nil
			end

			local prices = {}

			for k, v in pairs(self.priceRule.price) do
				prices[k] = v + self.priceRule.addRule * self.level 
			end

			return prices
		end

		return instance
	end,
	
}

local addStrategy = setmetatable({
	new = function (addValue, maxLevel, name, price, pos, requirements, desc)
		if desc == nil then
			if addValue < 0 then
				desc = "sub"
			else
				desc = "add"
			end
		end

		local instance = setmetatable(strategy.new(maxLevel, name, price, pos, requirements, desc), {__index=addStrategy})
		instance.addValue = addValue
		instance.use = function (self, value)
			return value + self.addValue * self.level
		end
		return instance
	end
}, {__index=strategy})

local multiplyStrategy = setmetatable({
	new = function (multiValue, maxLevel, name, price, pos, requirements, desc)
		if desc == nil then
			if multiValue < 0 then
				desc = "decrease"
			else
				desc = "multiply"
			end
		end

		local instance = setmetatable(strategy.new(maxLevel, name, price, pos, requirements, desc), {__index=multiplyStrategy})
		instance.multiValue = multiValue
		instance.use = function (self, value)
			return value * self.multiValue ^ (self.level)
		end

		return instance
	end
}, {__index=strategy})

local function createPrice(id, value, addRule)
	local newPrice = {}
	if type(id) == "table" then
		newPrice.price = id
		newPrice.addRule = value
	else
		newPrice.price = {[id] = value}
		newPrice.addRule = addRule
	end

	return newPrice
end

return {
	light = {
		damage = {
			add = {
				basic = addStrategy.new(2, 5, "basicDamage", createPrice(1, 1, 3), {windowSize.x/2, windowSize.y/2-40}),
				more = addStrategy.new(10, 4, "moreDamage", createPrice(1, 20, 10), {windowSize.x/2-100, windowSize.y/2-40}, {{"light", "damage", "basic", 4}}),
			},
			mul = {
				sharp = multiplyStrategy.new(1.05, 5, "sharpLight", createPrice(1, 50, 50), {windowSize.x/2+100, windowSize.y/2-70}, {{"light", "damage", "basic", 2}})
			}
		},
		size = {
			add = {
				visor = addStrategy.new(1.00, 5, "visorLight", createPrice(1, 75, 40), {windowSize.x/2-150, windowSize.y/2-140}, {{"light", "damage", "more", 4}}),
				
			},
			mul = {
				bright = multiplyStrategy.new(1.10, 3, "brightLight", createPrice(1, 100, 250), {windowSize.x/2-300, windowSize.y/2-140}, {{"light", "size", "visor", 5}})
			}
		},
		speed = {
			add = {
				fast = addStrategy.new(20, 10, "fastMovement", createPrice(1,  55, 20), {windowSize.x/2-250, windowSize.y/2-220}, {{"light", "size", "visor", 2}}),
			},
		},
		oil = {
			add = {
				lasting = addStrategy.new(1.50, 2, "longLasting", createPrice(1, 20, 40), {windowSize.x/2-20, windowSize.y/2+60}, {{"light", "damage", "basic", 1}, {"light", "damage", "more", 1}}),
			},

		},
		fuelUse = {
			mul = {
				otimize = multiplyStrategy.new(0.95, 2, "burnOtimized", createPrice(1,  10, 30), {windowSize.x/2, windowSize.y/2+170}, {{"light", "oil", "lasting", 1}}),
			}
		}
	},
	drop = {
		darkEssence = {
			add = {
				betterCath = addStrategy.new(1, 5, "betterCatch", createPrice(1, 20, 5), {windowSize.x/2+70, windowSize.y/2+50}, {{"light", "damage", "basic", 1}}),
			}
		}
	}
}