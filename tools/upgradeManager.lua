UpgradeManager = {}

local data = require("tools.upgradeData")
local IconButton = require("src.initial.updateTree.iconButton")

function UpgradeManager:apply(id, property, value)
	if data[id] == nil then
		print(string.format("UpgradeManager: There's no ID: '%s'", id))
		return value
	end
	if data[id][property] == nil then
		print(string.format("UpgradeManager: There's no property: '%s' on ID: '%s'", property, id))
		return value
	end

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

function UpgradeManager:getPosition(id, property, name)
	local info = self:getByName(id, property, name)

	return info.posX, info.posY
end

function UpgradeManager:getRequirements(id, property, name)
	local info = self:getByName(id, property, name)

	return info.requirements
end
function UpgradeManager:getLevelInfo(id, property, name)
	local info = self:getByName(id, property, name)
	
	return info.level, info.maxLevel
end

function UpgradeManager:getPrice(id, property, name)
	local info = self:getByName(id, property, name)

	return info:getPrice()
end

function UpgradeManager:buy(id, property, name)
	local info = self:getByName(id, property, name)

	info.level = info.level + 1
end

function UpgradeManager:getName(id, property, name)
	local info = self:getByName(id, property, name)

	return info.name
end

function UpgradeManager:getAllButtons(tree)
	local result = {}

	for id, p in pairs(data) do
		for property, v in pairs(p) do
			for t, n in pairs(v) do
				for name, d in pairs(n) do
					result[#result + 1] = IconButton.new(tree, id, property, name)
				end
			end
		end
	end

	return result
end

function UpgradeManager:getSave()
	local result = {}
	
	for id, p in pairs(data) do
		result[id] = {}
		for property, v in pairs(p) do
			result[id][property] = {}
			for t, n in pairs(v) do
				result[id][property][t] = {}
				for name, d in pairs(n) do
					result[id][property][t][name] = d.level
				end
			end
		end
	end

	return result
end

function UpgradeManager:setSave(saveData)
	for id, p in pairs(data) do
		if saveData[id] == nil then saveData[id] = {} end
		for property, v in pairs(p) do
			if saveData[id][property] == nil then saveData[id][property] = {} end
			for t, n in pairs(v) do
				if saveData[id][property][t] == nil then saveData[id][property][t] = {} end
				for name, d in pairs(n) do
					if saveData[id][property][t][name] ~= nil then
						data[id][property][t][name].level = math.min(saveData[id][property][t][name], data[id][property][t][name].maxLevel)
					end
				end
			end
		end
	end
end