local effect = {}

function effect.new()
  local instance = setmetatable({}, {__index=effect})
  instance.position = instance:getPosition()

  return instance
end

function effect:getPosition()
  
  return 100, 100
end
