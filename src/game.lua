local game = {}

game.ocean = require("src.ocean.ocean")
game.results = require("src.results")
game.initial = require("src.initial.initial")

game.saveDirPath = ""
game.save = {}
game.mode = ""

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
  --self:changeMode("ocean")
  self:changeMode("initial")
end

function game:exit()
  self.ocean:exit()
end

function game:update(delta)
  if self.mode == "ocean" then
    self.ocean:update(delta)
  elseif self.mode == "results" then
    self.results:update(delta)
  else
    self.initial:update(delta)
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
    self.initial:draw()
  end
  Hud:draw()
end

function game:input(event, value)
  if self.mode == "ocean" then
    self.ocean:input(event, value)
  elseif self.mode == "results" then
    self.results:input(event, value)
  else
    self.initial:input(event, value)
  end
end

function game:mousePressed(x, y, button, touch, presses)
  if self.mode == "ocean" then
  elseif self.mode == "results" then
    self.results:mousePressed(x, y, button, touch, presses)
  else
    self.initial:mousePressed(x, y, button, touch, presses)
  end
end

function game:mouseMoved(x, y, dx, dy, touch)
  if self.mode == "ocean" then
    self.ocean:mouseMoved(x, y, dx, dy, touch)
  elseif self.mode == "results" then
    self.results:mouseMoved(x, y, dx, dy, touch)
  else
    self.initial:mouseMoved(x, y, dx, dy, touch)
  end
end

function game:beginContact(a, b, col)
  if self.mode == "ocean" then
    self.ocean:beginContact(a, b, col)
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
    currentDay = 1,
    currentWeek = 1,
    totalDays = 1,
    totalWeeks = 1,
    collects = {

    },
    knowCollects = {"darkEssence"},
    upgrades = {}
  }
end

function game:finish(info)
  if info.beated == true and self.save.currentDay == self.save.totalDays then
    self.save.totalDays = self.save.totalDays + 1 
  end
  
  self.results:setupInfo(info)
  self:changeMode("results")
end


function game:changeMode(mode)
  self.mode = mode
  Hud:clear()
  if mode == "ocean" then
    isPaused = false
    self.ocean:init() 
  elseif mode == "results" then
    isPaused = true
    self.results:init(info)
  else
    self.initial:init()
  end
end


return game
