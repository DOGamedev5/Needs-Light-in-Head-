local DaysManager = {}

DaysManager.daysData = {
	{
		enemies = {"1-1", "1-2"},
		rules = {
			spawn = {["1-1"] = {2, 50}, ["1-2"] = {20, 50}},
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
		time = 90,
		frequency = 1.8,
		amount = {1, 3},
		groupsPerc = 40
	},
	{
		enemies = {"1"},
		rules = {["1"] = {5, 60}},
		sides = {"left", "right", "up"},
		time = 90,
		frequency = 1.75,
		amount = {1, 3}
	}
}

function DaysManager:getCurrentDayData(day)
	return self.daysData[day]
end

return DaysManager