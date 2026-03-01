local DaysManager = {}

DaysManager.currentWeek = 0
DaysManager.daysData = {}
DaysManager.day = {}
DaysManager.loaded = ""
local pathBase = "src.ocean.daysInfo.week%d.day%d"

function DaysManager:getCurrentDayData(day, week)
	--[[
	if self.currentWeek ~= week then
		self.daysData = require(string.format("src.ocean.daysInfo.week%d", week))
		self.currentWeek = week
	end
	return self.daysData[day]
	]]
	local path = string.format(pathBase, week, day)
	
	if path ~= self.loaded then
		self.day = require(path)
		self.loaded = path
	end

	return self.day
end

return DaysManager