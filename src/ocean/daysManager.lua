local DaysManager = {}

DaysManager.daysData = {
	{
		enemies = {"1"},
		rules = {["1"] = {5, 40}},
		sides = {"down", "up"},
		time = 40
	}
}

function DaysManager:getCurrentDayData(day)
	return self.daysData[day]
end

return DaysManager