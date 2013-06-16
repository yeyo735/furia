--[[local physics = require("physics")
local widget     = require("widget")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()]]

--[[physics.start()
physics.setGravity(0,0)

-- create wall objects
local topWall = display.newRect( 0, 0, display.contentWidth, 2 )
local bottomWall = display.newRect( 0, display.contentHeight - 650, display.contentWidth, 2 )
local leftWall = display.newRect( 100, 0, 2, display.contentHeight )
local rightWall = display.newRect( display.contentWidth - 100, 0, 2, display.contentHeight )

-- make them physics bodies
physics.addBody(topWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
physics.addBody(bottomWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
physics.addBody(leftWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
physics.addBody(rightWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})]]

-- create a Cholango and set it in motion
local cholango = function()
	local cholangoFrames = {}
	local cholangoDispaly = display.newGroup()
	local cholangoNFrame = 1
	for i=1,7 do
		cholangoFrames[i] =  display.newImageRect(cholangoDispaly,"images/cholango/cholango000"..i..".png",54,54)
		cholangoFrames[i].isVisible = false
	end
	cholangoFrames[cholangoNFrame].isVisible = true

	local animateCholango = function()
		cholangoFrames[cholangoNFrame] = false	
		cholangoNFrame = cholangoNFrame + 1
		if cholangoNFrame > #cholangoFrames then
			cholangoNFrame = 1
		end
		cholangoFrames[cholangoNFrame] = true
	end
end

--[[cholango.x, cholango.y = display.contentWidth / 2, display.contentHeight - 680
physics.addBody(cholango, "dynamic", {density = 1, friction = 0, bounce = 1, isSensor = false, radius = 0})
ball.isBullet = true
cholango:applyForce(100, 0)

local function onCollision(event)
  print(event.phase, cholango:getLinearVelocity())
end

cholango:addEventListener("collision", onCollision)

return scene]]