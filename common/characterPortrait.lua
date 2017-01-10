local newCharacterPortrait = {}

function CreateNewCharacterPortrait ()
  local instance = {}
  instance = deepcopy(newCharacterPortrait)
	return instance 
end

function newCharacterPortrait:Initialize(x, y, w, h, characterData)
  self.X = x
  self.Y = y
  self.PortraitCanvas = love.graphics.newCanvas(w, h)
  self.Character = characterData
end

function newCharacterPortrait:draw()
  love.graphics.setCanvas(self.PortraitCanvas)
  love.graphics.clear()
  
  love.graphics.setFont(alagard10Font)  
  love.graphics.draw(characterPortraitBackgroundImage)
  love.graphics.printf(self.Character.Name, 4, 6, 33, "center")
  love.graphics.draw(characterSheetImage, characterSheetQuad[self.Character.PortraitImage], 4, 12)  
  
  r, g, b, a = love.graphics.getColor( )
  love.graphics.draw(PointBarImage, 4, 46)  
  local percent = ((self.Character.CurrentHP / self.Character.MaxHP) * 28) - 1
  for i = 0, percent do
    love.graphics.draw(PointBarHPTickImage, 6 + i, 47)
  end
  love.graphics.setColor(r, g, b, a)
  love.graphics.draw(PointBarImage, 4, 52)  
  percent = ((self.Character.CurrentMP / self.Character.MaxMP) * 28) - 1
  for i = 0, percent do
    love.graphics.draw(PointBarMPTickImage, 6 + i, 53)
  end
  love.graphics.setColor(r, g, b, a)
  
  love.graphics.draw(BuffQuadImage, BuffQuad[1], 5, 58) 
  love.graphics.draw(BuffModQuadImage, BuffModQuad[1], 5, 58)
  
  love.graphics.draw(BuffQuadImage, BuffQuad[3], 16, 58) 
  love.graphics.draw(BuffModQuadImage, BuffModQuad[2], 16, 58)
  
  love.graphics.draw(BuffQuadImage, BuffQuad[4], 27, 58) 
  love.graphics.draw(BuffModQuadImage, BuffModQuad[3], 27, 58)
  
  love.graphics.setCanvas(MainCanvas)
  love.graphics.draw(self.PortraitCanvas, self.X, self.Y, 0)
end