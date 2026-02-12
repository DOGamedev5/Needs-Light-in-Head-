local strategy = {
	new = function (max, name, price, pos, requirements, desc)
		local instance = setmetatable({}, {__index=strategy}) 
		instance.name = name

		instance.level = 0
		instance.maxLevel = max
		instance.priceRule = price
		instance.requirements = requirements
		instance.desc = desc
		instance.posX = windowSize.x/2 + pos[1]
		instance.posY = windowSize.y/2 + pos[2]
		instance.getNextValue = function(self)
			return ""
		end
		instance.getPrice = function (self)
			if self.level == self.maxLevel then
				return {}
			end

			local prices = {}

			for k, v in pairs(self.priceRule.price) do

				prices[k] = self.priceRule:getCurrentPrice(k, self.level)
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
		
		instance.getNextValue = function(self)
			return self.addValue
			--return self.addValue * math.min(self.level+1, self.maxLevel)
		end 
		instance.use = function (self, value)
			return value + self.addValue * self.level
		end

		return instance
	end
}, {__index=strategy})

local multiplyStrategy = setmetatable({
	new = function (multiValue, maxLevel, name, price, pos, requirements, desc)
		if desc == nil then
			if multiValue < 1 then
				desc = "decrease"
			else
				desc = "multiply"
			end
		end

		local instance = setmetatable(strategy.new(maxLevel, name, price, pos, requirements, desc), {__index=multiplyStrategy})
		instance.multiValue = multiValue

		instance.getNextValue = function(self)
			--local value = self.multiValue ^ math.min(self.level+1, self.maxLevel)
			local value = self.multiValue
			return (value - 1)*100
		end
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

	newPrice.getCurrentPrice = function(self, ID, level)
		if type(self.addRule) == "table" then
			return self.price[ID] + self.addRule[ID] * level 
		end
		
		return self.price[ID] + self.addRule * level 	
	end

	return newPrice
end

return {
	light = {
		damage = {
			add = {
				basic = addStrategy.new(2, 5, "basicDamage", createPrice(1, 1, 3), {70, 50}, {{"collect", "darkEssence", "betterCatch", 1}}),
				more = addStrategy.new(10, 4, "moreDamage", createPrice(1, 20, 10), {-100, -40}, {{"collect", "darkEssence", "betterCatch", 4}}),
			},
			mul = {
				sharp = multiplyStrategy.new(1.025, 5, "sharpLight", createPrice(1, 15, 20), {100, -70}, {{"collect", "darkEssence", "betterCatch", 2}})
			}
		},
		size = {
			add = {
				visor = addStrategy.new(1.50, 5, "visorLight", createPrice(1, 10, 10), {-150, -140}, {{"collect", "darkEssence", "betterCatch", 2}}),
				
			},
			mul = {
				bright = multiplyStrategy.new(1.10, 3, "brightLight", createPrice(1, 90, 50), {-300, -140}, {{"light", "size", "visor", 5}})
			}
		},
		speed = {
			add = {
				little = addStrategy.new(1.5, 5, "littleMovement", createPrice(1,  3, 5), {20, -180}, {{"collect", "darkEssence", "betterCatch", 1}}),
				fast = addStrategy.new(3, 6, "fastMovement", createPrice(1,  5, 15), {-250, -220}, {{"light", "size", "visor", 2}}),
			},
		},
		oil = {
			add = {
				lasting = addStrategy.new(9.00, 8, "longLasting", createPrice(1, 7, 15), {-20, 60}, {{"collect", "darkEssence", "betterCatch", 1}}),
				littleTank = addStrategy.new(12, 5, "littleTank", createPrice(2, 1, 3), {-190, 10}, {{"light", "damage", "more", 2}})
			},

		},
		fuelUse = {
			mul = {
				otimize = multiplyStrategy.new(0.95, 3, "burnOtimized", createPrice(1,  10, 30), {0, 170}, {{"light", "oil", "lasting", 1}}),
			}
		},
		attackCooldown = {
			add = {
				agilityAtk = addStrategy.new(-0.1, 5, "agilityAtk", createPrice(1,  15, 25), {210, -70}, {{"light", "damage", "sharp", 2}})
			}
		},
		damageResist = {
			mul = {
				lightShield = multiplyStrategy.new(0.90, 5, "lightShield", createPrice(1, 20, 40), {160, 90}, {{"light", "damage", "basic", 2}})
			}
		}
	},
	collect = {
		darkEssence = {
			add = {
				betterCatch = addStrategy.new(1, 5, "betterCatch", createPrice(1, 4, 8), {0, -40}, nil, "collectAmount"),
			}
		},
		corruptEssence = {
			add = {
				badLuck = addStrategy.new(1, 5, "badLuck", createPrice({[1] = 150, [2] = 4}, {[1] = 75, [2] = 6}), {-50, -280}, {{"light", "speed", "little", 1}}, "collectAmount"),
			}
		}
	},
	result = {
		darkEssence = {
			mul = {
				whatLuck = multiplyStrategy.new(1.15, 4, "whatLuck", createPrice(1, 10, 30), {120, -230}, {{"light", "speed", "little", 1}}, "resultAmount")
			}
		},
		corruptEssence = {
			mul = {
				whatBadLuck = multiplyStrategy.new(1.20, 5, "whatBadLuck", createPrice({[1] = 80, [2] = 20}, {[1] = 80, [2] = 10}), {260, 60}, {{"light", "damageResist", "lightShield", 1}}, "resultAmount")
			}
		}
	}
}