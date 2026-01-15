StateMachine = {}

function StateMachine.new(owner, states, currentState)
	local instance = setmetatable({}, {__index=StateMachine})
	instance.states = states
	for k, v in ipairs(instance.states) do
		v.owner = owner
	end
	
	instance.currentState = currentState
	if instance.states[currentState].enter then
		instance.states[currentState].enter()
	end

	return instance
end

function StateMachine:stateUpdate()
	local newState = self.states[self.currentState]:stateUpdate()

	if newState then
		self.states[self.currentState]:exit()
		self.currentState = newState
	end
end

function StateMachine:update(delta)
	self:stateUpdate()
end