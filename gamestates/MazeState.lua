require 'mazeWindow'
require 'monsterdata.monsterstats'
require 'common.minimap'

local NewButton = require("libraries.ButtonManager.Button")
local Container = require("libraries.ButtonManager.Container")
local buttonManager = Container()
local newMazeStateObject = {}
local minimap = CreateNewMinimap()

function CreateMazeState ()
	return newMazeStateObject
end

stepValue = 1000

function newMazeStateObject:Initialize(viewPortX, viewPortY, viewPortW, viewPortH, XOff, YOff)
  mazeWindow:Initialize(viewPortX, viewPortY, viewPortW, viewPortH, floorMap, posX, posY, playerRot, XOff, YOff)  
  minimap:Initialize(179, 105, posX, posY, playerRot, floorMap)
  
  tlPort1 = CreateNewCharacterPortrait()  
  tlPort2 = CreateNewCharacterPortrait()
  tlPort3 = CreateNewCharacterPortrait()
  tlPort4 = CreateNewCharacterPortrait()
  
  tlPort1:Initialize(0, 0, 40, 72,  playerParty[1])
  tlPort2:Initialize(0, 72, 40, 72, playerParty[2])  
  tlPort3:Initialize(40 + 176, 0, 40, 72, playerParty[3])
  tlPort4:Initialize(40 + 176, 72, 40, 72, playerParty[4])
  
  self.HUDCanvas = love.graphics.newCanvas(176, 42)
  
  local buttonX = 0
  for i = 1, 3 do
    buttonManager:add(NewButton(NavigationQuadImage, NavigationQuad[i], 21 + (176/2) + buttonX, 105, 12, 12, drawingScale, function(button) 
          button.mouseHover = false
          newMazeStateObject:updatePlayer(navKeyMapping[i]) 
    end))
    buttonX = buttonX + 13 
  end
  
  buttonX = 0
  for i = 4, 6 do
    buttonManager:add(NewButton(NavigationQuadImage, NavigationQuad[i], 21 + (176/2) + buttonX, 118, 12, 12, drawingScale, function(button) 
          button.mouseHover = false
          newMazeStateObject:updatePlayer(navKeyMapping[i]) 
    end))
    buttonX = buttonX + 13 
  end  
end

function newMazeStateObject:update(dt) 
  buttonManager:update(dt)
  minimap:update(dt, mazeWindow.PlayerRotation, mazeWindow.PlayerX, mazeWindow.PlayerY)
  mazeWindow:update(dt)
end

function newMazeStateObject:updatePlayer(key)	
  local deltaY = 0
  local deltaX = 0
  local rotation = 0
  local canEncounter = false
  
  if key == upKey then
    deltaY = 1
    playerEncounterValue = playerEncounterValue + stepValue
    canEncounter = true
  elseif key == downKey then
    deltaY = -1
    playerEncounterValue = playerEncounterValue + stepValue
    canEncounter = true
  elseif key == rotLeftKey then
    rotation = -(math.pi/2)
  elseif key == rotRightKey then
    rotation = (math.pi/2)
  elseif key == leftKey then
    deltaX = -1
    playerEncounterValue = playerEncounterValue + stepValue
    canEncounter = true
  elseif key == rightKey then
    deltaX = 1
    playerEncounterValue = playerEncounterValue + stepValue
    canEncounter = true
  end
  
  mazeWindow:UpdatePlayer(deltaY, deltaX, rotation) 
  
  for k, v in pairs(mapTeleport) do
    if mapTeleport[k].startX == mazeWindow.PlayerX and mapTeleport[k].startY == mazeWindow.PlayerY then
      mazeWindow.DoTeleport = true
      canEncounter = false
      TEsound.play('common/sound/172207__fins__teleport.wav')
    end
  end  
  
  if canEncounter then
    if math.random(0, 10) < playerEncounterValue/stepValue then
      playerEncounterValue = 0
      combatState:PrepareBattle()
      gamestate.push(combatState)
    end
  end
end

function newMazeStateObject:draw()  
  love.graphics.push()
  love.graphics.setCanvas(MainCanvas)
  love.graphics.clear()
  mazeWindow:draw(false)
    
  tlPort1:draw()
  tlPort2:draw()
  tlPort3:draw()
  tlPort4:draw()  
     
  love.graphics.setCanvas(self.HUDCanvas)
  love.graphics.clear()
  love.graphics.draw(HUDPanelImage)
  love.graphics.draw(CompassImage, 176/2, 30, 0, 1, 1, 76/4)
  
  if mazeWindow.PlayerRotation == 0 then
    love.graphics.draw(NESWImage, NESWQuad[1], 176/2, 33, 0, 1, 1, 3)
  elseif mazeWindow.PlayerRotation == math.pi / 2 then
    love.graphics.draw(NESWImage, NESWQuad[2], 176/2, 33, 0, 1, 1, 3)
  elseif mazeWindow.PlayerRotation == math.pi then
    love.graphics.draw(NESWImage, NESWQuad[3], 176/2, 33, 0, 1, 1, 3)    
  else
    love.graphics.draw(NESWImage, NESWQuad[4], 176/2, 33, 0, 1, 1, 3)
  end  
  
  love.graphics.setCanvas(MainCanvas)
  love.graphics.draw(self.HUDCanvas, 40, 101, 0)
  minimap:draw()
  
  love.graphics.setCanvas()  
  love.graphics.draw(MainCanvas, 0, 0, 0, drawingScale, drawingScale)
  
  --Buttons get drawn overtop to avoid scaling issues
  buttonManager:draw()
  
  love.graphics.pop()
end

function newMazeStateObject:keypressed( key )
  if key == "escape" then
    gamestate.push(pauseState)
  end
  
  if love.keyboard.isDown(upKey) then
    newMazeStateObject:updatePlayer(upKey)
  elseif love.keyboard.isDown(downKey) then
    newMazeStateObject:updatePlayer(downKey)
  elseif love.keyboard.isDown(leftKey) then
    newMazeStateObject:updatePlayer(leftKey)
  elseif love.keyboard.isDown(rightKey) then
    newMazeStateObject:updatePlayer(rightKey)
  elseif love.keyboard.isDown(rotLeftKey) then
    newMazeStateObject:updatePlayer(rotLeftKey)
  elseif love.keyboard.isDown(rotRightKey) then
    newMazeStateObject:updatePlayer(rotRightKey)
  elseif love.keyboard.isDown(actionKey) then
    newMazeStateObject:Interact()
  end 
end

function newMazeStateObject:Interact( )
  local actX, actY = mazeWindow.PlayerX, mazeWindow.PlayerY
  
  if mazeWindow.PlayerRotation == 0 then
    actY = actY - 1
  elseif mazeWindow.PlayerRotation == math.pi / 2 then
    actX = actX + 1
  elseif mazeWindow.PlayerRotation == math.pi then
    actY = actY + 1
  else
    actX = actX - 1
  end  
  
  --Check if facing an exit
  for k, v in pairs(mapExits) do
    if mapExits[k].x == actX and mapExits[k].y == actY then
      print('You left the dungeon'.. actX .. ' ' .. actY)
    end    
  end
  
  --Check if facing an NPC
  for k, v in pairs(mapNPC) do
    if mapNPC[k].x == mazeWindow.PlayerX and mapNPC[k].y == mazeWindow.PlayerY and mapNPC[k].visibleRotation == mazeWindow.PlayerRotation then
      print('You meet '.. mapNPC[k].Name)
    end    
  end  
  
  --Check if facing a chest
  for k, v in pairs(mapItems) do
    if mapItems[k].x == mazeWindow.PlayerX and mapItems[k].y == mazeWindow.PlayerY and mapItems[k].visibleRotation == mazeWindow.PlayerRotation then
      print('You find '.. mapItems[k].ItemID)
    end    
  end  
  
  --Check if facing a secret
end

function love.mousepressed(...)
  buttonManager:mousepressed(...)
end