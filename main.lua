require 'keybindings'
require 'characterdata.basestats'
require 'common.commonImages'
require 'libraries.TESound.TEsound'
require 'common.characterPortrait'
require 'gamestates.MazeState'
require 'gamestates.CombatState'
require 'gamestates.PauseMenuState'

--Gamestates
gamestate = require 'libraries.hump.gamestate'
mazeState = CreateMazeState()
combatState = CreateCombatState()
pauseState = CreateNewPauseMenuState()

--Main Canvas
MainCanvas = love.graphics.newCanvas(256, 144)
MainCanvas:setFilter("nearest", "nearest")

drawingScale = 1

posX = 3
posY = 3
playerRot = (math.pi/2)
playerEncounterValue = 0

playerParty = {MorganStats, XanderStats, JuliaStats, XuStats}

mapNPC = {}
mapTeleport = {}
mapExits = {}
mapItems = {}

characters = {}
mazeWindow = CreateMazeWindow()

--Fonts
alagard05Font = love.graphics.newFont("common/fonts/pjuksimple_pixel_font_by_pjuk-d48ilnb.ttf", 12)
alagard10Font = love.graphics.newFont("common/fonts/pjuksimple_pixel_font_by_pjuk-d48ilnb.ttf", 15)
alagard15Font = love.graphics.newFont("common/fonts/alagard.ttf", 15)
alagard25Font = love.graphics.newFont("common/fonts/alagard.ttf", 25)

function love.load()	
  --if arg[#arg] == "-debug" then require("mobdebug").start() end
  math.randomseed( os.time() )
  
  drawingScale = CalculateDrawingScale(256, 144)
  love.keyboard.setKeyRepeat( true )
  love.filesystem.load("maps/map01.lua")()
  love.filesystem.load("characterdata/basestats.lua")()  
  
  mazeState:Initialize(128, 0, 176, 99, 176/2, -1)
  combatState:Initialize(128, 0, 176, 99, 176/2, -1)
  pauseState:Initialize()
  
  gamestate.registerEvents()
	gamestate.switch(mazeState)
end


function love.draw() 
  --love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  --love.graphics.print("Rotation: "..tostring(mazeWindow.PlayerRotation), 10, 25)
  --love.graphics.print("X,Y: "..tostring(mazeWindow.PlayerX) .. " " .. tostring(mazeWindow.PlayerY), 10, 40)
end

function love.update()
  TEsound.cleanup()
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function CalculateDrawingScale(normalW, normalH)
  width = love.graphics.getWidth();
  height = love.graphics.getHeight();
  
  wScale = width / normalW
  hScale = height / normalH
  
  return wScale
end