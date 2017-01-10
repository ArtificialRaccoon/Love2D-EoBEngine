function loadQuad(inQuad, numQuads, w, h)
  local xPosition = 0
  for x = 1, numQuads do		
    inQuad[x] = love.graphics.newQuad(xPosition, 0, w, h, w*numQuads, h)
    xPosition = xPosition + w
  end
end

aQuadImage = love.graphics.newImage( "common/images/SheetA.png" )
aQuad = {}
loadQuad(aQuad, 2, 128, 96)

aSideQuadImage = love.graphics.newImage( "common/images/SheetASide.png" )
aSideQuad = {}
loadQuad(aSideQuad, 2, 24, 120)

bQuadImage = love.graphics.newImage( "common/images/SheetB.png" )
bQuad = {}
loadQuad(bQuad, 2, 80, 59)

bSideQuadImage = love.graphics.newImage( "common/images/SheetBSide.png" )
bSideQuad = {}
loadQuad(bSideQuad, 2, 24, 95)

cQuadImage = love.graphics.newImage( "common/images/SheetC.png" )
cQuad = {}
loadQuad(cQuad, 2, 48, 37)

cSideQuadImage = love.graphics.newImage( "common/images/SheetCSide.png" )
cSideQuad = {}
loadQuad(cSideQuad, 2, 16, 59)

cFarSideQuadImage = love.graphics.newImage( "common/images/SheetCSideFar.png" )
cFarSideQuad = {}
loadQuad(cFarSideQuad, 2, 16, 44)

dSideQuadImage = love.graphics.newImage( "common/images/SheetDSide.png" )
dSideQuad = {}
loadQuad(dSideQuad, 2, 8, 35)

dSideFarQuadImage = love.graphics.newImage( "common/images/SheetDSideFar.png" )
dSideFarQuad = {}
loadQuad(dSideFarQuad, 2, 24, 35)

characterSheetImage = love.graphics.newImage( "common/images/CharacterSheet.png" )
characterSheetQuad = {}
loadQuad(characterSheetQuad, 9, 32, 32)

battlerImage = love.graphics.newImage( "common/images/BattlerSheet.png" )
battlerQuad = {}
loadQuad(battlerQuad, 1, 100, 100)

characterPortraitBackgroundImage = love.graphics.newImage("common/images/CharacterPortraitBG.png")
HUDPanelImage = love.graphics.newImage("common/images/HUDPanel.png")

PointBarImage = love.graphics.newImage("common/images/PointBar.png")
PointBarHPTickImage = love.graphics.newImage("common/images/PointBarHPTick.png")
PointBarMPTickImage = love.graphics.newImage("common/images/PointBarMPTick.png")
StatusImage = love.graphics.newImage("common/images/Status.png")

BuffQuadImage = love.graphics.newImage( "common/images/BuffSheet.png" )
BuffQuad = {}
loadQuad(BuffQuad, 8, 8, 8)

BuffModQuadImage = love.graphics.newImage( "common/images/BuffMod.png" )
BuffModQuad = {}
loadQuad(BuffModQuad, 3, 8, 8)

NavigationQuadImage = love.graphics.newImage( "common/images/NavigationSheet.png" )
NavigationQuad = {}
loadQuad(NavigationQuad, 6, 12, 12)

CompassImage = love.graphics.newImage( "common/images/CompassBase.png" )

NESWImage = love.graphics.newImage( "common/images/NESW.png" )
NESWQuad = {}
loadQuad(NESWQuad, 4, 6, 6)

MinimapImage = love.graphics.newImage( "common/images/MinimapBackground.png" )

MinimapFacingImage = love.graphics.newImage( "common/images/MinimapFacing.png" )
MinimapFacingQuad = {}
loadQuad(MinimapFacingQuad, 4, 5, 5)

NPCImage = love.graphics.newImage( "common/images/NPCImage.png" )
NPCImageQuad = {}
loadQuad(NPCImageQuad, 5, 46, 64)

backgroundSheetImage = love.graphics.newImage( "common/images/BackgroundSheet.png" )
BackgroundQuad = {}
loadQuad(BackgroundQuad, 4, 176, 112)

mapItemsSheetImage = love.graphics.newImage( "common/images/MapItems.png" )
MapItemsQuad = {}
loadQuad(MapItemsQuad, 1, 50, 50)