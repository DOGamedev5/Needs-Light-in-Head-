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

		instance.priority = 0

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
		instance.priority = 1

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
		instance.priority = 2

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

local function createPrice(id, value, power)
	local newPrice = {}
	if type(id) == "table" then
		newPrice.price = id
		newPrice.power = power or 2
	else

		newPrice.price = {[id] = value}
		newPrice.power = power or 2
	end

	newPrice.getCurrentPrice = function(self, ID, level)
		--if type(self.addRule) == "table" then
		--	return self.price[ID] + self.addRule[ID] * level 
		--end
		
		return self.price[ID] * self.power ^ level 	
	end



	return newPrice
end

--[[
local dataKeys = {
	[1] = "light",
	[2] = "collect",
	[3] = "result",
	[4] = "oil",
}
local data = {}
data[1] = {
	size = {},
	speed = {},
	oil = {},
	fuelUse = {},
	damage = {},
	attackCooldown= {},
	damageResist = {}
}
data[1].size.visor = addStrategy.new(1.75, 5, "visorLight", createPrice(1, 30), {-130, -110},                   {2, "darkEssence", "betterCatch", 2})
data[1].size.bright = multiplyStrategy.new(1.05, 3, "brightLight", createPrice(1, 90), {-260, -70},             {1, "size", "visor", 2})
data[1].speed.little = addStrategy.new(1.5, 5, "littleMovement", createPrice(1,  3), {-210, -180},              {1, "size", "visor", 2})
data[1].speed.fast = addStrategy.new(3, 6, "fastMovement", createPrice(1,  5), {-320, -200},                    {1, "speed", "little", 2})
data[1].oil.littleTank = addStrategy.new(10, 5, "littleTank", createPrice(1, 20), {80, 40},                     {2, "darkEssence", "betterCatch", 1})
data[1].oil.lasting = addStrategy.new(15, 5, "longLasting", createPrice(2, 10), {270, 100},                     {1, "fuelUse", "otimize", 2})
data[1].fuelUse.otimize = multiplyStrategy.new(0.975, 5, "burnOtimized", createPrice(1,  40), {170, 80},        {1, "oil", "littleTank", 1})
data[1].damage.basic = addStrategy.new(3, 5, "basicDamage", createPrice(1, 1), {-40, 80},                       {2, "darkEssence", "betterCatch", 2})
data[1].damage.more = addStrategy.new(10, 4, "moreDamage", createPrice(1, 30), {-80, 190},                      {1, "damage", "basic", 3})
data[1].damage.sharp = multiplyStrategy.new(1.025, 5, "sharpLight", createPrice(1, 50), {-140, 290},            {1, "damage", "more", 3})
data[1].attackCooldown.agilityAtk = addStrategy.new(-0.1, 5, "agilityAtk", createPrice(1,  15), {20, 210},      {1, "damage", "basic", 2})
data[1].damageResist.lightShield = multiplyStrategy.new(0.95, 5, "lightShield", createPrice(1, 20), {-160, 90}, {1, "damage", "basic", 2})

data[2] = {
	darkEssence = {},
	corruptEssence  = {}
}
data[2].darkEssence.betterCatch = addStrategy.new(1, 5, "betterCatch", createPrice(1, 4), {0, -40}, nil, "collectAmount")
data[2].darkEssence.noWast = addStrategy.new(5, 5, "noWast", createPrice(1, 30), {0, -160},                                        {2, "darkEssence", "betterCatch", 1}, "collectAmount")
data[2].corruptEssence.badLuck = addStrategy.new(1, 5, "badLuck", createPrice({[1] = 150, [2] = 4}), {-50, -280}, {2, "darkEssence", "noWast", 2}, "collectAmount")

data[3] = {
	darkEssence = {},
	corruptEssence  = {}
}
data[3].darkEssence.whatLuck = multiplyStrategy.new(1.15, 4, "whatLuck", createPrice(1, 80), {120, -230},                                   {2, "darkEssence", "noWast", 1}, "resultAmount")
data[3].corruptEssence.whatBadLuck = multiplyStrategy.new(1.20, 5, "whatBadLuck", createPrice({[1]=80, [2]=20}), {-150, -350}, {2, "corruptEssence", "badLuck", 1}, "resultAmount")

data[4] = {
	spawn = {},
	oilAmount = {}
}
data[4].spawn.recharge = addStrategy.new(1, 3, "recharge", createPrice(1, 15), {140, -50}, {1, "oil", "littleTank", 1})
data[4].oilAmount.towerUp = addStrategy.new(2.5, 5, "towerUp", createPrice({[1] = 200, [2] = 10}), {240, -70}, {4, "spawn", "recharge", 3})
data[4].oilAmount.beauty = multiplyStrategy.new(1.08, 6, "beauty", createPrice({[1] = 1000, [2] = 120}), {340, -90}, {4, "oilAmount", "towerUp", 4})
]]
return {
	light = {
		size = {
			add = {
				visor = addStrategy.new(1.75, 5, "visorLight", createPrice(1, 30), {-130, -110}, {{"collect", "darkEssence", "betterCatch", 2}}),
				
			},
			mul = {
				bright = multiplyStrategy.new(1.05, 3, "brightLight", createPrice(1, 90), {-260, -70}, {{"light", "size", "visor", 2}})
			}
		},
		speed = {
			add = {
				little = addStrategy.new(1.5, 5, "littleMovement", createPrice(1, 3), {-210, -180}, {{"light", "size", "visor", 2}}),
				fast = addStrategy.new(3, 6, "fastMovement", createPrice(1, 5), {-320, -200}, {{"light", "speed", "little", 2}}),
			},
		},
		oil = {
			add = {
				littleTank = addStrategy.new(10, 5, "littleTank", createPrice(1, 20), {80, 40}, {{"collect", "darkEssence", "betterCatch", 1}}),
				lasting = addStrategy.new(15, 5, "longLasting", createPrice(2, 10), {270, 100}, {{"light", "fuelUse", "otimize", 2}}),
			},

		},
		fuelUse = {
			mul = {
				otimize = multiplyStrategy.new(0.975, 5, "burnOtimized", createPrice(1,  40), {170, 80}, {{"light", "oil", "littleTank", 1}}),
			}
		},
		damage = {
			add = {
				basic = addStrategy.new(3, 5, "basicDamage", createPrice(1, 1), {-40, 80}, {{"collect", "darkEssence", "betterCatch", 2}}),
				more = addStrategy.new(10, 4, "moreDamage", createPrice(1, 30), {-80, 190}, {{"light", "damage", "basic", 3}}),
			},
			mul = {
				sharp = multiplyStrategy.new(1.025, 5, "sharpLight", createPrice(1, 50), {-140, 290}, {{"light", "damage", "more", 3}})
			}
		},
		attackCooldown = {
			add = {
				agilityAtk = addStrategy.new(-0.1, 5, "agilityAtk", createPrice(1,  15), {20, 210}, {{"light", "damage", "basic", 2}})
			}
		},
		damageResist = {
			mul = {
				lightShield = multiplyStrategy.new(0.95, 5, "lightShield", createPrice(1, 20), {-160, 90}, {{"light", "damage", "basic", 2}})
			}
		}
	},
	collect = {
		darkEssence = {
			add = {
				betterCatch = addStrategy.new(1, 5, "betterCatch", createPrice(1, 4), {0, -40}, nil, "collectAmount"),
				noWast = addStrategy.new(5, 5, "noWast", createPrice(1, 30), {0, -160}, {{"collect", "darkEssence", "betterCatch", 1}}, "collectAmount")
			}
		},
		corruptEssence = {
			add = {
				badLuck = addStrategy.new(1, 5, "badLuck", createPrice({[1] = 150, [2] = 4}), {-50, -280}, {{"collect", "darkEssence", "noWast", 2}}, "collectAmount"),
			}
		}
	},
	result = {
		darkEssence = {
			mul = {
				whatLuck = multiplyStrategy.new(1.15, 4, "whatLuck", createPrice(1, 80), {120, -230}, {{"collect", "darkEssence", "noWast", 1}}, "resultAmount")
			}
		},
		corruptEssence = {
			mul = {
				whatBadLuck = multiplyStrategy.new(1.20, 5, "whatBadLuck", createPrice({[1] = 80, [2] = 20}), {-150, -350},
					{{"collect", "corruptEssence", "badLuck", 1}}, "resultAmount")
			}
		}
	},
	oil = {
		spawn = {
			add = {recharge = addStrategy.new(1, 3, "recharge", createPrice(1, 15), {140, -50}, {{"light", "oil", "littleTank", 1}})}
		},
		oilAmount = {
			add = {
				towerUp = addStrategy.new(2.5, 5, "towerUp", createPrice({[1] = 200, [2] = 10}), {240, -70}, {{"oil", "spawn", "recharge", 3}})
			},
			mul = {
				beauty = multiplyStrategy.new(1.08, 6, "beauty", createPrice({[1] = 1000, [2] = 120}), {340, -90}, {{"oil", "oilAmount", "towerUp", 4}})
			}
		}
	}
}