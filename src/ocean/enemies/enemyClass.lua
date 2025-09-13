EnemyClass = {}

EnemyClass.toDraw = {}

function EnemyClass:addToDraw()
  table.insert(EnemyClass.toDraw, 1, self)
end

function EnemyClass:removeToDraw()
  tools.erase(EnemyClass.toDraw, self)
end
