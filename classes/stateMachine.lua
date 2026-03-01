StateMachine = {}

function StateMachine.new(states, currentState)
	local instance = setmetatable({}, {__index=StateMachine})
	instance.states = states	
	instance.currentState = currentState
	
	if instance.states[currentState].enter then
		instance.states[currentState]:enter()
	end

	return instance
end

function StateMachine:stateUpdate()
	local newState = self.states[self.currentState]:stateUpdate()

	if newState then
		self:changeState(newState)
	end
end

function StateMachine:update(delta)
	if self.states[self.currentState].update then self.states[self.currentState]:update(delta) end
	self:stateUpdate()
end

function StateMachine:changeState(newState)
	if self.states[self.currentState].exit then self.states[self.currentState]:exit() end
	self.currentState = newState
	if self.states[self.currentState].enter then self.states[self.currentState]:enter() end
end