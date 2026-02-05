UpgradeManager = {}

local data = require("tools.upgradeData")

function UpgradeManager:apply(id, property, value)
	return self:process(data[id][property], value)
end


function UpgradeManager:process(p, value)
	local result = value
	if p.add then
		for k, v in pairs(p.add) do
			if v.level > 0 then result = v:use(result) end
		end
	end
	if p.mul then
		for k, v in pairs(p.mul) do
			if v.level > 0 then result = v:use(result) end
		end
	end

	return result
end

function UpgradeManager:getByName(id, property, name)
	for _, t in pairs(data[id][property]) do
		for k, v in pairs(t) do
			if k == name then
				return v
			end
		end
	end
end

function UpgradeManager:getLevelInfo(id, property, name)
	local info = self:getByName(id, property, name)
	
	return info.level, info.maxLevel
end

function UpgradeManager:getPrice(id, property, name)
	local info = self:getByName(id, property, name)

	return info.price
end

function UpgradeManager:buy(id, property, name)
	local info = self:getByName(id, property, name)

	info.level = info.level + 1
end


