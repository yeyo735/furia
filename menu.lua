-------------------------------------------------
-- Island of the Moon Game Studio
-- www.islandofthemoon.com
--
-- Template project for UCATEC Game Jam 2013
--
-- Copyright (C) 2013 @islandofthemoon
-- MIT License http://opensource.org/licenses/MIT
-------------------------------------------------

local widget     = require("widget")
local storyboard = require("storyboard")
--alocal escenario = require("escenario")

local scene = storyboard.newScene()

local _W = display.contentWidth
local _H = display.contentHeight

local background
local title
local playBtn

local trTitle
local trPlay

local function startGame()
  trTitle = transition.to(title, {
    time       = 200,
    transition = easing.inQuad,
    x          = 1300
  })
  trPlay = transition.to(playBtn, {
    delay      = 40,
    time       = 200,
    transition = easing.inQuad,
    x          = 1300,
    onComplete = function()
      storyboard.gotoScene( "escenario" )
    end
  })
end

function scene:createScene( event )
  local group = self.view

  background = display.newRect(group, 0,0, _W,_H)
  background:setFillColor(255,255,255)

  title = display.newText(group, "Furia Kochala Game", 20,20, native.systemFontBold, 40)

  playBtn = widget.newButton
  {
      width = 150,
      height = 50,
      id = "button_1",
      label = "Empezar",
      onEvent = startGame,
  }
  group:insert(playBtn)

end

function scene:enterScene( event )

	storyboard.purgeScene( "splash" )
	storyboard.purgeScene( "pause" )
  title:setReferencePoint(display.TopCenterReferencePoint)
  title:setTextColor(0,0,0)
  title.x = _W/2
  title.y = 40

  playBtn:setReferencePoint(display.TopCenterReferencePoint)
  playBtn.x = _W/2
  playBtn.y = 180

  transition.from(title, {
    delay      = 80,
    time       = 200,
    transition = easing.inQuad,
    x          = -400
  })
  transition.from(playBtn, {
    time       = 200,
    transition = easing.inQuad,
    x          = -400
  })
end

function scene:exitScene( event )
  transition.cancel(trTitle)
  transition.cancel(trPlay)
end

function scene:destroyScene( event )
	print( "((destroying menu view))" )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )


return scene
