local game = {}

game.ocean = require("src.ocean.ocean")
game.results = require("src.results")

game.saveDirPath = ""
game.save = {}
game.mode = "ocean"

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
  if self.mode == "ocean" then
    self.ocean:update(delta)
  else
    self.results:update(delta)
  end
  Hud:update(delta)
end

function game:draw()
  if self.mode == "ocean" or self.mode == "results" then
    self.ocean:draw()
    if self.mode == "results" then
      self.results:draw()
    end
  else 

  end
  Hud:draw()
end

function game:input(event, value)
  if self.mode == "ocean" then
    self.ocean:input(event, value)
  else
    --self.results:input(event, value)
  end
end

function game:mouseMoved(x, y, dx, dy, touch)
  if self.mode == "ocean" then
    self.ocean:mouseMoved(x, y, dx, dy, touch)
  else
    --self.results:mouseMoved(x, y, dx, dy, touch)
  end
end

function game:beginContact(a, b, col)
  if self.mode == "ocean" then
    game.ocean:beginContact(a, b, col)
  else
  end
end

function game:afterContact(a, b, col)
  if self.mode == "ocean" then
    game.ocean:afterContact(a, b, col)
  else
  end
  
end

function game:newSave()
  return {
    currentDay = 1
  }
end

function game:finish(info)
  self.mode = "results"
  if info.beated == true then
    self.save.currentDay = self.save.currentDay + 1 
  end
  Hud:clear()
  self.results:init(info)
end

return game
