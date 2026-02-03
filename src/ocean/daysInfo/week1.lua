return {
	{
		enemies = {"1-1", "1-2"},
		rules = {
			spawn = {["1-1"] = {2, 90}, ["1-2"] = {20, 90}},
			percent = {
				{30, {["1-1"] = 4, ["1-2"] = 1}}, -- timeTrigger, spawn percentage
				{50, {["1-1"] = 3, ["1-2"] = 2}}				
			},
			groupPerc = {
				{10, 5},
				{20, 10}, -- timeTrigger, percentage
				{50, 40},
			}
		},
		sides = {"down", "up"},
		time = 90,
		frequency = 1.8,
		amount = {1, 3},
	},
	{
		enemies = {"1-1", "1-2"},
		rules = {
			spawn = {["1-1"] = {2, 90}, ["1-2"] = {14, 90}},
			percent = {
				{20, {["1-1"] = 4, ["1-2"] = 2}}, -- timeTrigger, spawn percentage
				{30, {["1-1"] = 4, ["1-2"] = 3}},
				{60, {["1-1"] = 3, ["1-2"] = 5}}				
			},
			groupPerc = {
				{20, 30}, -- timeTrigger, percentage
				{50, 50},
			}
		},
		sides = {"right", "up"},
		time = 90,
		frequency = 1.9,
		amount = {1, 3},
		groupsPerc = 40
	},
	{
		enemies = {"1-1", "1-2"},
		rules = {
			spawn = {["1-1"] = {0, 50}, ["1-2"] = {2, 50}},
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
		time = 90,
		frequency = 1.9,
		amount = {1, 3},
		groupsPerc = 40
	}
}
