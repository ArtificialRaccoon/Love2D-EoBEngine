local newPauseMenuState = {}

function CreateNewPauseMenuState()
  return newPauseMenuState
end

function newPauseMenuState:Initialize() 

end

function newPauseMenuState:update(dt)  

end

function newPauseMenuState:draw()   
  love.graphics.push()
  love.graphics.setCanvas(MainCanvas)
  love.graphics.clear()
  
  love.graphics.setCanvas()  
  love.graphics.draw(MainCanvas, 0, 0, 0, drawingScale, drawingScale)
  love.graphics.pop()  
end

function newPauseMenuState:keypressed( key )
  if key == "escape" then
    gamestate.pop()
  end    
end