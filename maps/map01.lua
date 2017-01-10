floorMap ={
{1,1,1,1,1,1,1,1,1},
{1,0,0,0,0,0,0,0,1},
{1,0,0,0,2,0,0,0,1},
{1,0,0,2,1,0,0,0,1},
{1,0,0,0,2,0,0,0,1},
{1,0,0,0,0,0,0,0,1},
{1,1,1,1,1,1,1,1,1}}

backgroundIndex = 4

mapNPC[1] = {
  Name = 'Teefa',  
	x = 3,
	y = 2,
  visibleRotation = 0,
  alpha = 0,
	Quad = 5  
}

mapNPC[2] = {
  Name = 'Rold',
	x = 3,
	y = 5,
  visibleRotation = 0,
  alpha = 0,
  Quad = 2  
}

mapTeleport[1] = {
	startX = 4,
	startY = 3,
  endX = 8,
  endY = 6
}

mapExits[1] = {
  x = 9,
  y = 5
}

mapExits[2] = {
  x = 4,
  y = 1
}

mapExits[3] = {
  x = 1,
  y = 2
}

mapExits[4] = {
  x = 8,
  y = 7
}

mapItems[1] = {
  ItemID = 42,
  visibleRotation = (math.pi/2) + math.pi,
  x = 6,
  y = 3,
  alpha = 0,
  Quad = 1
}