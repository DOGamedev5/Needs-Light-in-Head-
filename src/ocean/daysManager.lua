local DaysManager = {}

DaysManager.daysData = {
	{
		enemies = {"1"},
		rules = {["1"] = {5, 60}},
		sides = {"down", "up"},
		time = 60
	}
}

function DaysManager:getCurrentDayData(day)
	return self.daysData[day]
end

return DaysManager