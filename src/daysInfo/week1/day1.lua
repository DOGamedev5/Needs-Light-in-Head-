return {
	initial = {
		unlocks = {},
		dialogs = {}
	},
	dropInfo = {
		frequency = 1.1,
		amountInterval = {4, 6},
		dropPercent = {[1] = 1}
	},
	gameplay = {
		loadEnemies = {"1-1"},
		waves = {
			{
				WaveSegment.new(1, "left", {["1-1"] = 3}),
				WaveSegment.new(2.5, "right", {["1-1"] = 2}),
			},
			{
				WaveSegment.new(1, "left", {["1-1"] = 4}),
				WaveSegment.new(1.4, "right", {["1-1"] = 2}),
				WaveSegment.new(4.5, "left", {["1-1"] = 2}),
				WaveSegment.new(5, "right", {["1-1"] = 4}),
			},
			{
				WaveSegment.new(2, "left", {["1-1"] = 5}),
				WaveSegment.new(1.2, "up", {["1-1"] = 3}),
				WaveSegment.new(1.6, "up", {["1-1"] = 5}),
				WaveSegment.new(4, "right", {["1-1"] = 5}),
			}
		}
	}
}	