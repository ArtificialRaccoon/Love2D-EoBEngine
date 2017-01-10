local newCombatStateObject = {}
local completedTransition = false
local AnimationStep = 0
local time = 5000
local dist_size = 15
local dist_step = 50
local AnimationTimer = 0

function CreateCombatState ()  
	return newCombatStateObject
end

function newCombatStateObject:Initialize(viewPortX, viewPortY, viewPortW, viewPortH, XOff, YOff) 
  self.ViewPortX = viewPortX
  self.ViewPortY = viewPortY
  self.ViewPortXOff = XOff
  self.ViewPortYOff = YOff
  self.ViewPortW = viewPortW
  self.ViewPortH = viewPortH
  self.viewPortcanvas = love.graphics.newCanvas(viewPortW, viewPortH)
  self.Monsters = {}
  self.AnimationStep = 0  
  
  self.Shader = love.graphics.newShader([[
    extern number time;
    extern number size;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
    {    
      vec2 p = tc;        
      p.x = p.x + sin(p.y * size + time) * 0.03;

      float height = 100.0;
      float y = height * tc.y;
      
      if(mod(y,2.0) >= 1.0)
        return vec4(Texel(tex, p)) * vec4(0,0,0,0.5);
      else
        return vec4(Texel(tex, p)) * vec4(0.0,0.5,0.0,0.5);
    }
  ]])
  self.Shader:send("size", dist_size)
end

function newCombatStateObject:PrepareBattle()
  self.Monsters[1] = deepcopy(MonsterData[1])
end

function newCombatStateObject:update(dt)  
  AnimationTimer = AnimationTimer + dt
  mazeWindow:update(dt)
end

function newCombatStateObject:draw()   
  love.graphics.push()
  love.graphics.setCanvas(MainCanvas)
  love.graphics.clear()
  
  if mazeWindow ~= nil then
    mazeWindow:draw(true)
  end
  
  if AnimationTimer > 0.05 then
    time = time - 1000  
    self.Shader:send("time", time * 1000)
    
    AnimationStep = AnimationStep + 100
    if AnimationStep > 600 then
      time = 5000
      AnimationStep = 0
      completedTransition = true
    end
    
    AnimationTimer = 0
  end  
    
  tlPort1:draw()
  tlPort2:draw()
  tlPort3:draw()
  tlPort4:draw() 
  
  love.graphics.setCanvas(self.viewPortcanvas)
  love.graphics.clear()

  if completedTransition == false then
    love.graphics.setShader(self.Shader)
    r, g, b, a = love.graphics.getColor( )
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.draw(battlerImage, battlerQuad[1], ((self.ViewPortW)/2), ((self.ViewPortH)/2), 0, 1, 1, 50, 50)
    love.graphics.setColor(r, g, b, a)
    love.graphics.setShader()
  else        
    love.graphics.draw(battlerImage, battlerQuad[1], ((self.ViewPortW)/2), ((self.ViewPortH)/2), 0, 1, 1, 50, 50)        
  end  
  
  love.graphics.setCanvas(MainCanvas)
  love.graphics.draw(self.viewPortcanvas, self.ViewPortX, self.ViewPortY, 0, 1, 1, self.ViewPortXOff, self.ViewPortYOff)
  
  love.graphics.setCanvas()
  love.graphics.draw(MainCanvas, 0, 0, 0, drawingScale, drawingScale)
  love.graphics.pop()
end

function newCombatStateObject:keypressed( key )
  if key == "escape" then
    gamestate.push(pauseState)
  end  
  completedTransition = false
  time = 5000
  AnimationStep = 0
  AnimationTimer = 0
  gamestate.pop()
end