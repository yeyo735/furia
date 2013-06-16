--local storyboard = require( "storyboard" )
--local scene = storyboard.newScene()

local _W = display.contentWidth
local _H = display.contentHeight
local logo
local background

local cholango = {
	derecha = function ()
		-- body
	end

	izquierda = function()
	
	end

	principal = function()
	end
}

cholango.principal = cholango.derecha

function scene:createScene( event )
  local group = self.view

  background = display.newRect(group, 0,0, _W,_H)
  background:setFillColor(155,58,38)

  logo = display.newImage(group, 'images/cholango/cholango001.png')
  logo:setReferencePoint(display.CenterReferencePoint)
  logo.x = _W/2
  logo.y = _H/2
end