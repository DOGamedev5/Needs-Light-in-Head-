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
		size = {
			add = {
				visor = addStrategy.new(1.50, 5, "visorLight", createPrice(1, 10, 10), {-130, -110}, {{"collect", "darkEssence", "betterCatch", 2}}),
				
			},
			mul = {
				bright = multiplyStrategy.new(1.10, 3, "brightLight", createPrice(1, 90, 50), {-260, -70}, {{"light", "size", "visor", 3}})
			}
		},
		speed = {
			add = {
				little = addStrategy.new(1.5, 5, "littleMovement", createPrice(1,  3, 5), {-210, -180}, {{"light", "size", "visor", 2}}),
				fast = addStrategy.new(3, 6, "fastMovement", createPrice(1,  5, 15), {-320, -200}, {{"light", "speed", "little", 2}}),
			},
		},
		oil = {
			add = {
				littleTank = addStrategy.new(10, 5, "littleTank", createPrice(1, 20, 20), {80, 40}, {{"collect", "darkEssence", "betterCatch", 1}}),
				lasting = addStrategy.new(20, 5, "longLasting", createPrice(2, 1, 3), {270, 100}, {{"light", "fuelUse", "otimize", 2}}),
			},

		},
		fuelUse = {
			mul = {
				otimize = multiplyStrategy.new(0.975, 5, "burnOtimized", createPrice(1,  10, 30), {170, 80}, {{"light", "oil", "littleTank", 1}}),
			}
		},
		damage = {
			add = {
				basic = addStrategy.new(3, 5, "basicDamage", createPrice(1, 1, 3), {-40, 80}, {{"collect", "darkEssence", "betterCatch", 1}}),
				more = addStrategy.new(10, 4, "moreDamage", createPrice(1, 20, 10), {-80, 190}, {{"light", "damage", "basic", 3}}),
			},
			mul = {
				sharp = multiplyStrategy.new(1.025, 5, "sharpLight", createPrice(1, 15, 20), {-140, 290}, {{"light", "damage", "more", 3}})
			}
		},
		attackCooldown = {
			add = {
				agilityAtk = addStrategy.new(-0.1, 5, "agilityAtk", createPrice(1,  15, 25), {20, 210}, {{"light", "damage", "basic", 2}})
			}
		},
		damageResist = {
			mul = {
				lightShield = multiplyStrategy.new(0.95, 5, "lightShield", createPrice(1, 20, 40), {-160, 90}, {{"light", "damage", "basic", 2}})
			}
		}
	},
	collect = {
		darkEssence = {
			add = {
				betterCatch = addStrategy.new(1, 5, "betterCatch", createPrice(1, 4, 8), {0, -40}, nil, "collectAmount"),
				noWast = addStrategy.new(5, 5, "noWast", createPrice(1, 30, 20), {0, -160}, {{"collect", "darkEssence", "betterCatch", 2}}, "collectAmount")
			}
		},
		corruptEssence = {
			add = {
				badLuck = addStrategy.new(1, 5, "badLuck", createPrice({[1] = 150, [2] = 4}, {[1] = 75, [2] = 6}), {-50, -280}, {{"collect", "darkEssence", "noWast", 1}}, "collectAmount"),
			}
		}
	},
	result = {
		darkEssence = {
			mul = {
				whatLuck = multiplyStrategy.new(1.15, 4, "whatLuck", createPrice(1, 10, 30), {120, -230}, {{"collect", "darkEssence", "noWast", 1}}, "resultAmount")
			}
		},
		corruptEssence = {
			mul = {
				whatBadLuck = multiplyStrategy.new(1.20, 5, "whatBadLuck", createPrice({[1] = 80, [2] = 20}, {[1] = 80, [2] = 10}), {-150, -350},
					{{"collect", "corruptEssence", "badLuck", 1}}, "resultAmount")
			}
		}
	},
	oil = {
		spawn = {
			add = {recharge = addStrategy.new(1, 3, "recharge", createPrice(1, 15, 15), {140, -50}, {{"light", "oil", "littleTank", 1}})}
		},
		oilAmount = {
			add = {
				towerUp = addStrategy.new(2.5, 5, "towerUp", createPrice({[1] = 200, [2] = 10}, {[1] = 250, [2] = 30}), {240, -70}, {{"oil", "spawn", "recharge", 3}})
			},
			mul = {
				beauty = multiplyStrategy.new(1.08, 6, "beauty", createPrice({[1] = 400, [2] = 50}, {[1] = 300, [2] = 60}), {340, -90}, {{"oil", "oilAmount", "towerUp", 4}})
			}
		}
	}
}