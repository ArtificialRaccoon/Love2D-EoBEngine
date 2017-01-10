
local Object = require("libraries.ButtonManager.classic")
local Button = Object:extend()

local function boxCollision(a, b)
return a.x < (b.x + b.width) * b.scale and 
  a.x + a.width > (b.x * b.scale) and
  a.y < (b.y + b.height) * b.scale and 
  a.y + a.height > (b.y * b.scale)
end


function Button:new(image, quad, x, y, width, height, scale, onClick)
  self.canvas = love.graphics.newCanvas(w, h)
  self.image = image
  self.quad = quad
  self.width = width
  self.height = height
  self.x = x
  self.y = y
  self.scale = scale
  self.onClick = onClick or function() print("Button '"..self.name.."' is missing an 'onClick' event!") end
  self.mouseHover = false
  self.removed = false
end


function Button:destroy()
  self.removed = true
end


function Button:update(dt)
  self.mouseHover = false
  if boxCollision({x=love.mouse.getX(), y=love.mouse.getY(), width=1, height=1}, self) then
    self.mouseHover = true
  end
end


function Button:draw()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  love.graphics.setBlendMode('alpha')
  self.canvas:setFilter("nearest", "nearest")   
  
  if self.mouseHover then 
    love.graphics.setColor(255, 0, 0)
  else 
    love.graphics.setColor(255, 255, 255) 
  end
  
  love.graphics.draw(self.image, self.quad, 0, 0, 0, 1, 1)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.setCanvas()
  love.graphics.draw(self.canvas, self.x * self.scale, self.y * self.scale, 0, self.scale, self.scale)
end


function Button:mousepressed(x, y, button)
  if self.mouseHover and button == 1 then self:onClick() end
end

return Button
