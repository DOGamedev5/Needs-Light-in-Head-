local DaysManager = {}

DaysManager.currentWeek = 0
DaysManager.daysData = {
	{
		enemies = {"1-1", "1-2"},
		rules = {
			spawn = {["1-1"] = {2, 50}, ["1-2"] = {30, 50}},
			percent = {
				{30, {["1-1"] = 4, ["1-2"] = 1}}, -- timeTrigger, spawn percentage
				{50, {["1-1"] = 3, ["1-2"] = 2}}				
			},
			groupPerc = {
				{20, 10}, -- timeTrigger, percentage
				{50, 40},
			}
		},
		sides = {"down", "up"},
		time = 50,
		frequency = 1.8,
		amount = {1, 3},
		groupsPerc = 40
	},
	{
		enemies = {"1-1", "1-2"},
		rules = {
			spawn = {["1-1"] = {2, 50}, ["1-2"] = {14, 50}},
			percent = {
				{20, {["1-1"] = 4, ["1-2"] = 2}}, -- timeTrigger, spawn percentage
				{50, {["1-1"] = 4, ["1-2"] = 3}}				
			},
			groupPerc = {
				{20, 30}, -- timeTrigger, percentage
				{50, 50},
			}
		},
		sides = {"right", "up"},
		time = 50,
		frequency = 1.9,
		amount = {1, 3},
		groupsPerc = 40
	}
}


function DaysManager:getCurrentDayData(day, week)
	if self.currentWeek ~= week then
		self.daysData = require(string.format("src.ocean.daysInfo.week%d", week))
		self.currentWeek = week
	end
	return self.daysData[day]
end

return DaysManager