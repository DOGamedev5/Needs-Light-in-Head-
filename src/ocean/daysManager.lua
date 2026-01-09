local DaysManager = {}

DaysManager.daysData = {
	{
		enemies = {"1"},
		rules = {["1"] = {5, 90}},
		sides = {"down", "up"},
		time = 20,
		frequency = 1.2,
	},
	{
		enemies = {"1"},
		rules = {["1"] = {5, 60}},
		sides = {"left", "right", "up"},
		time = 90,
		frequency = 1.75
	}
}

function DaysManager:getCurrentDayData(day)
	return self.daysData[day]
end

return DaysManager