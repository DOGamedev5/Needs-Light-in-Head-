local DaysManager = {}

DaysManager.currentWeek = 0
DaysManager.daysData = {}
DaysManager.day = {}
DaysManager.loaded = ""
local pathBase = "src.daysInfo.week%d.day%d"

local maxDays = 2
local maxWeeks = 1

function DaysManager:getCurrentDayData(day, week)
	
	if week > maxWeeks then
		week = maxWeeks
		day = 6
	elseif day > maxDays and week == maxWeeks then
		day = maxDays
	end

	local path = string.format(pathBase, week, day)
	
	if path ~= self.loaded then
		self.day = require(path)
		self.loaded = path
	end
	return self.day
end

return DaysManager