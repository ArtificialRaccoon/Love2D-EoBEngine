
local Object = require("libraries.ButtonManager.classic")
local Container = Object:extend()

function Container:new()
  self.objects = {}
end


function Container:add(object)
  self.objects[#self.objects+1] = object
  return object
end


function Container:update(dt)
  for i=#self.objects, 1, -1 do
    local object = self.objects[i]
    if object.removed then
      table.remove(self.objects, i)
      return
    end
    if object.update then object:update(dt) end
  end
end


function Container:draw()
  for i=#self.objects, 1, -1 do
    local object = self.objects[i]
    if object.draw then object:draw() end
  end
end


function Container:mousepressed(...)
  for i=#self.objects, 1, -1 do
    local object = self.objects[i]
    if object.mousepressed then object:mousepressed(...) end
  end
end

return Container