local newMinimap = {}

function CreateNewMinimap ()
	return newMinimap
end 

function newMinimap:Initialize(x, y, posX, posY, rot, mapData)
  self.X = x
  self.Y = y
  self.PosX = posX
  self.PosY = posY
  self.rot = rot
  self.map = mapData
  self.visibleMap = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
  self.mapCanvas = love.graphics.newCanvas(36, 36)  
end

function newMinimap:draw()
  love.graphics.setCanvas(self.mapCanvas)
  love.graphics.clear()

  love.graphics.draw(MinimapImage, 0, 0)
  
  local drawX = 2
  local drawY = 2
  
  for j = 1, 5 do
    for i = 1, 5 do
      if self.visibleMap[j][i] > 0 then
        love.graphics.rectangle('fill', drawX, drawY, 5, 5)
      end         
    
      drawX = drawX + 6
      if drawX > 26 then
        drawX = 2
      end
    end
    drawY = drawY + 6
    if drawY > 26 then
      drawY = 2
    end
    
    if self.rot == 0 then
      love.graphics.draw(MinimapFacingImage, MinimapFacingQuad[1], 14, 14)
    elseif self.rot == math.pi/2 then
      love.graphics.draw(MinimapFacingImage, MinimapFacingQuad[2], 14, 14)
    elseif self.rot == math.pi then
      love.graphics.draw(MinimapFacingImage, MinimapFacingQuad[3], 14, 14)
    else
      love.graphics.draw(MinimapFacingImage, MinimapFacingQuad[4], 14, 14)
    end
    
  end
  
  love.graphics.setCanvas(MainCanvas)
  love.graphics.draw(self.mapCanvas, self.X, self.Y, 0)
end

function newMinimap:update(dt, rot, posX, posY)
  self.rot = rot
  self.PosY = posY
  self.PosX = posX  
  
  for j = -2, 2 do
    for i = -2, 2  do
      if self.map[self.PosY + j] == nil or self.map[self.PosY + j][self.PosX + i] == nil then
        self.visibleMap[j+3][i+3] = 1
      else        
        self.visibleMap[j+3][i+3] = self.map[self.PosY + j][self.PosX + i]
      end
    end
  end  
  
  --printMap(self.visibleMap)
end

function printMap (tbl)
  for j = 1, 5 do
    for i = 1, 5  do
      io.write(tbl[i][j] .. ' ')
    end
    io.write('\n')
  end
  io.write('\n')
end