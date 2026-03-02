return {
	initial = {
		unlocks = {},
		dialogs = {}
	},
	dropInfo = {
		frequency = 1.2,
		amountInterval = {6, 8},
		dropPercent = {[1] = 1}
	},
	gameplay = {
		loadEnemies = {"1-1", "1-2"},
		waves = {
			{
				WaveSegment.new(1, "left", {["1-1"] = 5}),
				WaveSegment.new(1.5, "right", {["1-1"] = 6}),
			},
			{
				WaveSegment.new(1, "left", {["1-1"] = 4}),
				WaveSegment.new(1.2, "left", {["1-2"] = 3}),
				WaveSegment.new(1.8, "right", {["1-1"] = 4, ["1-2"] = 2}),
			},
			{
				WaveSegment.new(2, "left", {["1-1"] = 5, ["1-2"] = 2}),
				WaveSegment.new(1.2, "up", {["1-2"] = 4}),
				WaveSegment.new(1.6, "up", {["1-1"] = 5}),
				WaveSegment.new(4, "right", {["1-1"] = 5, ["1-2"] = 2}),
			},
			{
				WaveSegment.new(1, "left", {["1-1"] = 3, ["1-2"] = 2}),
				WaveSegment.new(1.6, "up", {["1-2"] = 5}),
				WaveSegment.new(1.6, "down", {["1-1"] = 8, ["1-2"] = 2}),
				WaveSegment.new(2.8, "down", {["1-2"] = 4}),
			}
		}
	}
}	