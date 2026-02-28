return {
	{
		enemies = {"1-1", "1-2"},
		rules = {
			spawn = {["1-1"] = {2, 90}, ["1-2"] = {30, 90}},
			percent = {
				{30, {["1-1"] = 4, ["1-2"] = 0}},
				{50, {["1-1"] = 4, ["1-2"] = 2}},
				{90, {["1-1"] = 4, ["1-2"] = 3}}, -- timeTrigger, spawn percentage
			},
			groupPerc = {
				{10, 5},
				{15, 15}, -- timeTrigger, percentage
				{90, 30},
			},
		},
		sides = {"down", "up"},
		frequency = 1.8,
		amount = {1, 4},
		time = 120,
		dropRules = {
			drops = {1},
			spawn = {[1] = {0, 90}},
			percent = {
				{90, {[1] = 1}}, -- timeTrigger, spawn percentage
			},
			groupPerc = {
				{10, 5},
				{15, 20}, -- timeTrigger, percentage
				{90, 30},
			},
			frequency = 0.8,
			amount = {3, 8},
		}
	},
	{
		enemies = {"1-1", "1-2", "1-3"},
		rules = {
			spawn = {["1-1"] = {2, 40}, ["1-2"] = {20, 110}, ["1-3"] = {35, 90}},
			percent = {
				{20, {["1-1"] = 2, ["1-2"] = 3}}, -- timeTrigger, spawn percentage
				{30, {["1-1"] = 4, ["1-2"] = 3, ["1-3"] = 1}},
				{90, {["1-1"] = 0, ["1-2"] = 8, ["1-3"] = 2}},
				{120, {["1-1"] = 0, ["1-2"] = 12, ["1-3"] = 1}}
			},
			groupPerc = {
				{20, 30}, -- timeTrigger, percentage
				{40, 40},
			}
		},
		sides = {"right", "up"},
		frequency = 1.9,
		amount = {3, 6},
		time = 120,
		dropRules = {
			drops = {1},
			spawn = {[1] = {0, 90}, [2] = {40, 90}},
			percent = {
				{50, {[1] = 4, [2] = 1}}, -- timeTrigger, spawn percentage
				{90, {[1] = 3, [2] = 2}}, -- timeTrigger, spawn percentage
			},
			groupPerc = {
				{10, 15},
				{20, 30}, -- timeTrigger, percentage
				{90, 40},
			},
			frequency = 1.0,
			amount = {5, 12},
		}
	},
	{
		enemies = {"1-1", "1-2", "1-3", "1-4"},
		rules = {
			spawn = {["1-1"] = {0, 90}, ["1-2"] = {20, 90}, ["1-3"] = {40, 100}, ["1-4"] = {55, 120}},
			percent = {
				{20, {["1-1"] = 4, ["1-2"] = 2, ["1-3"] = 0, ["1-4"] = 0}}, -- timeTrigger, spawn percentage
				{50, {["1-1"] = 6, ["1-2"] = 8, ["1-3"] = 3, ["1-4"] = 1}},
				{90, {["1-1"] = 8, ["1-2"] = 8, ["1-3"] = 1, ["1-4"] = 2}}				
			},
			groupPerc = {
				{20, 28}, -- timeTrigger, percentage
				{50, 35},
				{90, 40},
			}
		},
		sides = {"right", "up", "left"},
		frequency = 1.1,
		amount = {4, 7},
		time = 120,
		dropRules = {
			drops = {1, 2},
			spawn = {[1] = {2, 90}, [2] = {50, 120}},
			percent = {
				{50, {[1] = 4, [2] = 2}}, 
				{90, {[1] = 5, [2] = 3}}, 
				{120, {[1] = 3, [2] = 3}}, 
			},
			groupPerc = {
				{10, 20},
				{20, 30}, -- timeTrigger, percentage
				{50, 35},
			},
			frequency = 1.6,
			amount = {10, 18}
		}
	},
	{
		enemies = {"1-1", "1-2", "1-3", "1-4"},
		rules = {
			spawn = {["1-1"] = {0, 60}, ["1-2"] = {20, 120}, ["1-3"] = {40, 90}, ["1-4"] = {40, 120}},
			percent = {
				{20, {["1-1"] = 4, ["1-2"] = 2, ["1-4"] = 2}}, -- timeTrigger, spawn percentage
				{50, {["1-1"] = 4, ["1-2"] = 6, ["1-3"] = 2, ["1-4"] = 1}}				,
				{120, {["1-1"] = 17, ["1-2"] = 6, ["1-3"] = 2, ["1-4"] = 3}}				
			},
			groupPerc = {
				{20, 30}, -- timeTrigger, percentage
				{60, 45},
				{120, 65},
			}
		},
		sides = {"right", "down", "left"},
		frequency = 2.3,
		amount = {6, 12},
		time = 120,
		dropRules = {
			drops = {1, 2},
			spawn = {[1] = {2, 100}, [2] = {50, 120}},
			percent = {
				{50, {[1] = 4, [2] = 2}}, 
				{90, {[1] = 5, [2] = 3}}, 
				{120, {[1] = 3, [2] = 3}}, 
			},
			groupPerc = {
				{10, 20},
				{20, 30}, -- timeTrigger, percentage
				{50, 35},
			},
			frequency = 1.7,
			amount = {12, 18}
		}
	},
	{
		enemies = {"1-1", "1-2", "1-3", "1-4"},
		rules = {
			spawn = {["1-1"] = {0, 60}, ["1-2"] = {20, 120}, ["1-3"] = {40, 90}, ["1-4"] = {40, 120}},
			percent = {
				{20, {["1-1"] = 8, ["1-2"] = 4, ["1-3"] = 1, ["1-4"] = 4}}, -- timeTrigger, spawn percentage
				{50, {["1-1"] = 4, ["1-2"] = 6, ["1-3"] = 2, ["1-4"] = 1}},
				{120, {["1-1"] = 17, ["1-2"] = 6, ["1-3"] = 2, ["1-4"] = 3}}				
			},
			groupPerc = {
				{20, 30}, -- timeTrigger, percentage
				{60, 45},
				{120, 65},
			}
		},
		sides = {"right", "down", "left", "up"},
		frequency = 1.8,
		amount = {4, 8},
		time = 120,
		dropRules = {
			drops = {1, 2},
			spawn = {[1] = {2, 100}, [2] = {30, 120}},
			percent = {
				{50, {[1] = 2, [2] = 2}}, 
				{90, {[1] = 2, [2] = 3}}, 
				{120, {[1] = 3, [2] = 6}}, 
			},
			groupPerc = {
				{10, 30},
				{20, 50}, -- timeTrigger, percentage
				{50, 65},
			},
			frequency = 1.9,
			amount = {12, 18}
		}
	},
}
