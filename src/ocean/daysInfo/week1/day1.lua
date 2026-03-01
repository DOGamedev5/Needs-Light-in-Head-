return {
	initial = {
		unlocks = {},
		dialogs = {}
	},
	dropInfo = {
		frequency = 1.1,
		amountInterval = {4, 8},
		dropPercent = {[1] = 1}
	},
	gameplay = {
		loadEnemies = {"1-1", "1-2"},
		waves = {
			{
				WaveSegment.new(1, "left", {["1-1"] = 2}),
				WaveSegment.new(1.5, "right", {["1-1"] = 2}),
			},
			{
				WaveSegment.new(1, "left", {["1-1"] = 2}),
				WaveSegment.new(2.5, "left", {["1-1"] = 2}),
				WaveSegment.new(3, "right", {["1-2"] = 2}),
			},
			{
				WaveSegment.new(2, "left", {["1-2"] = 2}),
				WaveSegment.new(1.2, "up", {["1-1"] = 3}),
				WaveSegment.new(4, "right", {["1-2"] = 1}),
			}
		}
	}
}	