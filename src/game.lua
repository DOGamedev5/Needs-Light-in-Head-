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
    if self.save.version ~= 2 then
      self.save = self:newSave()
      self:writeSave()
    end
    
    UpgradeManager:setSave(self.save.upgrades)
  else
    self.save = self:newSave()
    self:writeSave()
  end
  

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

function game:mouseReleased(x, y, button, touch, presses)
  if self.mode == "ocean" then
  elseif self.mode == "results" then
    self.results:mouseReleased(x, y, button, touch, presses)
  else
    self.initial:mouseReleased(x, y, button, touch, presses)
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
    version = 2,
    currentDay = 1,
    currentWeek = 1,
    collects = {
      ["darkEssence"] = 0
    },
    knowCollects = {"darkEssence"},
    upgrades = UpgradeManager:getSave()
  }
end

function game:writeSave()
  if not FileSystem.fileExist(self.saveDirPath, "directory") then
    love.filesystem.createDirectory(self.saveDirPath)
  end
  self.save.upgrades = UpgradeManager:getSave()
  FileSystem.writeFile(self.saveDirPath .."save.lua", self.save)
end

function game:finish(info)
  if info.beated == true then
    self.save.currentDay = self.save.currentDay + 1 
  end
  
  for k, v in pairs(info.collects) do
    local total = self.save.collects[k] or 0
    self.save.collects[k] = total + v

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

function game:quit()
  self:writeSave()
end


return game
