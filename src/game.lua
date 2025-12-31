local game = {}

game.ocean = require("src.ocean.ocean")

game.saveDirPath = ""
game.save = {}

function game:load()
self.saveDirPath = "file".. tostring(currentGameFile) .. "/"
  if FileSystem.fileExist(self.saveDirPath .."save.lua") then
    self.save = FileSystem.loadFile(self.saveDirPath .."save.lua")
  else
    self.save = self:newSave()
    if not FileSystem.fileExist(self.saveDirPath, "directory") then
      love.filesystem.createDirectory(self.saveDirPath)
      FileSystem.writeFile(self.saveDirPath .."save.lua", self.save)
    end
  end
  self.ocean:init() 
end

function game:exit()
  self.ocean:exit()
end

function game:update(delta)
  game.ocean:update(delta)
  Hud:update(delta)
end

function game:draw()
  game.ocean:draw()
  Hud:draw()
end

function game:input(event, value)
  game.ocean:input(event, value)
end

function game:mouseMoved(x, y, dx, dy, touch)
  game.ocean:mouseMoved(x, y, dx, dy, touch)
end

function game:beginContact(a, b, col)
  game.ocean:beginContact(a, b, col)
end

function game:afterContact(a, b, col)
  game.ocean:afterContact(a, b, col)
  
end

function game:newSave()
  return {
    currentDay = 1
  }
end

return game
