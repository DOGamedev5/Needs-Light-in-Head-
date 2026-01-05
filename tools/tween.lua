Tween = {}

local easingsFunc = {
	linear = function (time, start, duration)
		return (math.min(math.max(start, time), start+duration)-start)/duration	
	end,
	quad = function(p) return p * p end,
	cubic = function(p) return p * p * p end,
	quart = function(p) return p * p * p * p end,
	quint = function(p) return p * p * p * p * p end,
	expo = function(p) return 2 ^ (10 * (p - 1)) end,
	sine = function(p) return -math.cos(p * (math.pi * .5)) + 1 end,
	circ = function(p) return -(math.sqrt(1 - (p * p)) - 1) end,
  	back = function(p) return p * p * (2.7 * p - 1.7) end,
  	elastic = function(p) return -(2^(10 * (p - 1)) * math.sin((p - 1.075) * (math.pi * 2) / .3)) end
}

local function modeTreatment(p, mode, easing)
	if mode == "linear" then return p end

	easingV = easing or "in"
	
	if easingV == "in" then
		return easingsFunc[mode](p)

	elseif easingV == "out" then
		p = 1 - p
		return easingsFunc[mode](p)
	elseif easingV == "inout" then
		p = p * 2
		
		if p < 1 then
		  return .5 * (easingsFunc[mode](p))
		else
		  p = 2 - p
		  return .5 * (1 - (easingsFunc[mode](p))) + .5
		end
	elseif  easingV == "outin" then
		p = p * 2
		
		if p < 1 then
		  p = 2 - p
		  return .5 * (1 - (easingsFunc[mode](p))) + .5
		else
		  return .5 * (easingsFunc[mode](p))
		end
	end

end

function Tween.interpolate(mode, time, start, duration, easing)
	return modeTreatment(easingsFunc.linear(time, start, duration), mode, easing)
end