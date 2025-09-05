local menu = {}

function menu:load()
  button = Button.new("test", 100, 100, 200, 50, self.butonPressed)
  --button.selected = true
  button1 = Button.new("test2", 100, 160, 200, 50, function ()
    print("test2 pressed")
  end)
end

function menu:update(delta)
  button:update()
  button1:update()
end

function menu:draw()
  button:draw()
  button1:draw()
end

function menu.butonPressed()
  print("presse")
end

return menu
