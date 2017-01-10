local newMazeWindowObject = {}
local t, shakeDuration, shakeMagnitude = 0, 0.5, 5

function CreateMazeWindow ()
	return newMazeWindowObject
end

function newMazeWindowObject:Initialize(x, y, width, height, map, startX, startY, rotation, xOff, yOff)
  self.X = x
  self.Y = y
  self.XOff = xOff
  self.YOff = yOff
  self.PlayerX = startX
  self.PlayerY = startY
  self.PlayerRotation = rotation
  self.Width = width
  self.Height = height
  self.viewPortcanvas = love.graphics.newCanvas(width, height)
  self.Map = map
  self.drawMap ={
      {0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0},
           { 0, 0, 0},
           { 0, 0, 0},
  }
  self.DoTeleport = false
  self.PlayerStep = -1
  self.DrawStack = {}   
  
  self:UpdatePlayer(0, 0, 0)
end

function newMazeWindowObject:CalculateDepth(calculateForX, direction, deltaSign, delta)    
	if calculateForX == true then 
    if self.Map[self.PlayerY][self.PlayerX + (deltaSign * delta)] < 1 then
      self.PlayerStep = self.PlayerStep * -1;
      self.PlayerX = self.PlayerX + (deltaSign * delta)
    end
    a = self.PlayerX
    b = self.PlayerY    
    mapN1 = table.getn(self.Map[1])
    mapN2 = table.getn(self.Map)
  else	
    if self.Map[self.PlayerY + (deltaSign * delta)][self.PlayerX] < 1 then
      self.PlayerStep = self.PlayerStep * -1;
      self.PlayerY = self.PlayerY + (deltaSign * delta)
    end	
    a = self.PlayerY 
    b = self.PlayerX
    mapN1 = table.getn(self.Map)
    mapN2 = table.getn(self.Map[1])
	end
	
    for i = 1, 7 do
      if (a + (direction * 3)) > 0  and (a + (direction * 3)) <= mapN1 and (b + (-4 + i)) > 0 and (b + (-4 + i)) <= mapN2 then
        if calculateForX == true then
          self.drawMap[1][(deltaSign < 0) and math.abs(i-8) or i] 	= self.Map[(b + (-4 + i))][a + (direction * 3)]
        else
          self.drawMap[1][(deltaSign > 0) and math.abs(i-8) or i] 	= self.Map[(a + (direction * 3))][b + (-4 + i)]
        end
      end
    end
    
    for i = 1, 5 do
      if (a + (direction * 2)) > 0  and (a + (direction * 2)) <= mapN1 and (b + (-3 + i)) > 0 and (b + (-3 + i)) <= mapN2 then
        if calculateForX == true then
          self.drawMap[2][(deltaSign < 0) and math.abs(i-6) or i] = self.Map[(b + (-3 + i))][a + (direction * 2)]
        else
          self.drawMap[2][(deltaSign > 0) and math.abs(i-6) or i] = self.Map[(a + (direction * 2))][b + (-3 + i)]
        end
      end
    end
    
    for i = 1, 3 do      
      if (a + (direction * 1)) > 0 and (a + (direction * 1)) <= mapN1 and (b + (-2 + i)) > 0 and (b + (-2 + i)) <= mapN2 then
        if calculateForX == true then
          self.drawMap[3][(deltaSign < 0) and math.abs(i-4) or i] = self.Map[(b + (-2 + i))][a + (direction * 1)]
        else
          self.drawMap[3][(deltaSign > 0) and math.abs(i-4) or i] = self.Map[(a + (direction * 1))][b + (-2 + i)]
        end
      end
    
      if a > 0 and a <= mapN1 and (b + (-2 + i)) > 0 and (b + (-2 + i)) <= mapN2 then
        if calculateForX == true then
          self.drawMap[4][(deltaSign < 0) and math.abs(i-4) or i] = self.Map[b + (-2 + i)][a]
        else
          self.drawMap[4][(deltaSign > 0) and math.abs(i-4) or i] = self.Map[a][b + (-2 + i)]
        end
      end
    end    
end

function newMazeWindowObject:update(dt) 
  if self.DoTeleport then
    if t < shakeDuration then
      t = t + dt
    else
      self.DoTeleport = false
      t = 0
      
      for k, v in pairs(mapTeleport) do
        if mapTeleport[k].startX == self.PlayerX and mapTeleport[k].startY == self.PlayerY then
          self.PlayerX = mapTeleport[k].endX
          self.PlayerY = mapTeleport[k].endY
          self:UpdatePlayer(0, 0, 0)
        end
      end      
    end
  end  
end

function newMazeWindowObject:UpdatePlayer(deltaY, deltaX, rotationDelta)
  self.PlayerRotation = self.PlayerRotation + rotationDelta
  
  if math.abs(self.PlayerRotation) == math.pi * 2 then
    self.PlayerRotation = 0
  end
  
  if self.PlayerRotation < 0 then
    self.PlayerRotation = ((math.pi/2) + math.pi)
  end
  
  if self.PlayerRotation == 0 then  
    self:CalculateDepth(false, -1, -1, deltaY)
  elseif self.PlayerRotation == math.pi / 2 then
    self:CalculateDepth(true, 1, 1, deltaY)
  elseif self.PlayerRotation == math.pi then
    self:CalculateDepth(false, 1, 1, deltaY)
  elseif self.PlayerRotation == ((math.pi/2) + math.pi) then
    self:CalculateDepth(true, -1, -1, deltaY)
  end
end

function newMazeWindowObject:DrawForwardWallQuad(flatImage, inputQuad, textureNum, i, maxStep, yOffset)
  x, y, w, h = inputQuad[textureNum]:getViewport( )
  love.graphics.draw(flatImage, inputQuad[textureNum], 
    (self.Width/2) + (-w + ((i-maxStep) * w)), 
    (self.Height/2) + yOffset, 
    0, 1, 1, 
    w/2, h/2)  
end

function newMazeWindowObject:DrawAngledWallQuad(angledImage, inputQuad, textureNum, previousFlatImageWidth, farWall, leftOrRight, yOffset)
  x, y, w, h = inputQuad[textureNum]:getViewport( )
  love.graphics.draw(angledImage, inputQuad[textureNum],  
    (self.Width/2) + (previousFlatImageWidth * farWall  * leftOrRight) + (leftOrRight * previousFlatImageWidth/2) + (leftOrRight * w/2), 
    (self.Height/2) + yOffset, 
    0, leftOrRight * -1, 1, 
    w/2, h/2)
end

function newMazeWindowObject:draw(isMinimal)
  love.graphics.push()
  
  love.graphics.setCanvas(self.viewPortcanvas)
  love.graphics.clear()
   
  love.graphics.draw(backgroundSheetImage, BackgroundQuad[backgroundIndex], self.Width/2, self.Height/2, 0, self.PlayerStep, 1, self.Width/2, self.Height/2)
  
  if self.drawMap[1][2] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(dSideFarQuadImage, dSideFarQuad, self.drawMap[1][2], 32, 1, -1, -10)
  end
  
  if self.drawMap[1][3] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(dSideQuadImage, dSideQuad, self.drawMap[1][3], 32, 0, -1, -10)
  end
  
  if self.drawMap[1][5] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(dSideQuadImage, dSideQuad, self.drawMap[1][5], 32, 0, 1, -10)
  end
  
  if self.drawMap[1][6] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(dSideFarQuadImage, dSideFarQuad, self.drawMap[1][6], 32, 1, 1, -10)
  end
  
  for i = 1, 7 do
    if self.drawMap[1][i] >= 1 then      
      newMazeWindowObject:DrawForwardWallQuad(cQuadImage, cQuad, self.drawMap[1][i], i, 3, -10) 
    end     
  end
  
  if self.drawMap[2][1] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(cFarSideQuadImage, cFarSideQuad, self.drawMap[2][1], 48, 1, -1, -8)
  end
  
  if self.drawMap[2][2] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(cSideQuadImage, cSideQuad, self.drawMap[2][2], 48, 0, -1, -8)
  end
  
  if self.drawMap[2][4] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(cSideQuadImage, cSideQuad, self.drawMap[2][4], 48, 0, 1, -8)
  end
  
  if self.drawMap[2][5] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(cFarSideQuadImage, cFarSideQuad, self.drawMap[2][5], 48, 1, 1, -8)
  end   
  
  for i = 1, 5 do
    if self.drawMap[2][i] >= 1 then
      newMazeWindowObject:DrawForwardWallQuad(bQuadImage, bQuad, self.drawMap[2][i], i, 2, -8)
    end       
  end
  
  if self.drawMap[3][1] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(bSideQuadImage, bSideQuad, self.drawMap[3][1], 80, 0, -1, -4)
  end
  
  if self.drawMap[3][3] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(bSideQuadImage, bSideQuad, self.drawMap[3][3], 80, 0, 1, -4)
  end
  
  for i = 1, 3 do
    if self.drawMap[3][i] >= 1 then
        newMazeWindowObject:DrawForwardWallQuad(aQuadImage, aQuad, self.drawMap[3][i], i, 1, -4) 
    end             
  end
  
  if self.drawMap[4][1] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(aSideQuadImage, aSideQuad, self.drawMap[4][1], 128, 0, -1, 0)
  end
  
  if self.drawMap[4][3] >= 1 then
    newMazeWindowObject:DrawAngledWallQuad(aSideQuadImage, aSideQuad, self.drawMap[4][3], 128, 0, 1, 0)
  end
  
  r, g, b, a = love.graphics.getColor( )
  if isMinimal == false then
    for k, v in pairs(mapNPC) do
      if mapNPC[k].x == self.PlayerX and mapNPC[k].y == self.PlayerY and mapNPC[k].visibleRotation == self.PlayerRotation then
        x, y, w, h = NPCImageQuad[mapNPC[k].Quad]:getViewport()

        if(mapNPC[k].alpha < 255) then
          mapNPC[k].alpha = mapNPC[k].alpha + 1
        end
        
        love.graphics.setColor(255, 255, 255, mapNPC[k].alpha)
        love.graphics.draw(NPCImage, NPCImageQuad[mapNPC[k].Quad], 
          self.Width/2, self.Height * 5/8, 
          0, 
          1, 1, 
          w/2, h/2)  
        love.graphics.setColor(r, g, b, a)
      else        
        mapNPC[k].alpha = 0
      end
    end
    
    for k, v in pairs(mapItems) do
      if mapItems[k].x == self.PlayerX and mapItems[k].y == self.PlayerY and mapItems[k].visibleRotation == self.PlayerRotation then
        x, y, w, h = MapItemsQuad[mapItems[k].Quad]:getViewport()

        if(mapItems[k].alpha < 255) then
          mapItems[k].alpha = mapItems[k].alpha + 1
        end
        
        love.graphics.setColor(255, 255, 255, mapItems[k].alpha)
        love.graphics.draw(mapItemsSheetImage, MapItemsQuad[mapItems[k].Quad], 
          self.Width/2, self.Height * 6/8, 
          0, 
          1, 1, 
          w/2, h/2)  
        love.graphics.setColor(r, g, b, a)
      else        
        mapItems[k].alpha = 0
      end
    end    
  end
  
  if self.DoTeleport then        
        love.graphics.setColor(r, g, b + 100, a)
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(dx, dy)         
  end
  
  love.graphics.setCanvas(MainCanvas)  
  love.graphics.draw(self.viewPortcanvas, self.X, self.Y, 0, 1, 1, self.XOff, self.YOff)
  love.graphics.setColor(r, g, b, a)
  love.graphics.pop()
end