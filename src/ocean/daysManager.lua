local DaysManager = {}

DaysManager.daysData = {
	{
		enemies = {"1", "2"},
		rules = {["1"] = {5, 90}, ["2"] = {0, 60}},
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