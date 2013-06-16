
--local esc = {}

--local function run()

	--Dll de physics para las balas gravedad 0
	local physics    = require( "physics" )
	local widget     = require("widget")
	local storyboard = require( "storyboard" )
	--local cholango = require("cholango")
	local scene = storyboard.newScene()

	local touch = false
	local xTouch = 0
	local yTouch = 0
	local paused = false

	local function onTouch(e)
  if e.phase ~= "ended" then
    touch = true
    xTouch = e.x
    yTouch = e.y
  else
    touch = false
  end
end

local function onEnterFrame()
  if touch then
    ball:applyForce(xTouch - ball.x, yTouch - ball.y, ball.x, ball.y)
  end
end

local function pauseGame()
  if not paused then
    physics.pause()
    paused = true
    storyboard.showOverlay( "pause", {
        effect = "fade",
        time = 400
    })
  end
end


	local function pauseGame()
  		if not paused then
    		physics.pause()
    		paused = true
    		storyboard.showOverlay( "pause", {
        	effect = "fade",
        	time = 400
    	})
  		end
	end



function scene:createScene( event )
	physics.setGravity( 0, 0 )
	physics.start()

--variables de control gameloop/gameplay
local gameIsActive = true
local spawnInt = 0
local spawned = 2
local spawnedMax = 27


--posicion de polis,tiempos y transicion
local polisArray = {}
local polisTiemp = {}
local polisTrans = {}

--funciones math para los disparos
local mRound = math.round
local mRand = math.random
local mCeil = math.ceil
local mAtan2 = math.atan2
local mSqrt = math.sqrt
local mPi = math.pi

--Variables Manifestantes
local manifestanteSalud = 100
local manifestanteVelocidad = 10


--grupos odenados por capas
local grupoLocal = display.newGroup()
local grupoCuadros = display.newGroup()
local grupoManifestantes = display.newGroup()
local grupoBarras = display.newGroup()
local grupoArmas = display.newGroup()
grupoLocal:insert(display.newImage("images/fondo.jpg"))
grupoLocal:insert(grupoCuadros)
grupoLocal:insert(grupoArmas)
grupoLocal:insert(display.newImage("images/plantas.png"))
grupoLocal:insert(grupoBarras)


local cuadroImagen = {}

local mapa = {
	0,   0,   0,   0,   0,   0,   0,   0,   0, "fn",  0,   0,   0,   0,   0,   0,   0,   0,   0,
	0,   0,   0,   2,   0,   0,   2,   0,   2,   1,   2,   0,   2,   0,   0,   2,   0,   0,   0,
	0,   0, "dr",  1,   1,   1,   1,   1,   1, "ar",  1,   1,   1,   1,   1,   1, "iz",  0,   0,
	0,   0,   1,   1,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   1,   1,   0,   0,
	0,   0,   1,   0,   1,   2,   0,   0,   0,   0,   0,   0,   0,   2,   1,   0,   1,   0,   0,
	0,   0,   1,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0,   1,   0,   0,   1,   0,   0,
	0,   0,   1,   2,   0,   0,   1,   0,   0,   0,   0,   0,   1,   0,   0,   2,   1,   0,   0,
	0,   0,   1,   0,   0,   0,   0, "ai",  2,   0,   2, "ad",  0,   0,   0,   0,   1,   0,   0,
	0,   0,   1,   2,   0,   2,   1,   0,   0,   0,   0,   0,   1,   2,   0,   2,   1,   0,   0,
	0,   0,   1,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0,   1,   0,   0,   1,   0,   0,
	0,   0,   1,   0,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   0,   1,   0,   0,
	0,   0,   1,   1,   0,   0,   2,   0,   0,   2,   0,   0,   2,   0,   0,   1,   1,   0,   0,
  "in",  1, "add", 1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1, "adi", 1,   0,
	0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
}

--Puntos donde los manifestantes cambian de direccion

local elegirCamino = {}

for i=1, #mapa do

	if mapa[i] == "in" then elegirCamino[1] = { "inicio", i}
	elseif mapa[i] == "add" then elegirCamino[2] = { "arribaDiagonalDerecha", i, "images/off.png"}
	elseif mapa[i] == "adi" then elegirCamino[3] = { "arribaDiagonalIzquierda", i , "images/off.png"}
	elseif mapa[i] == "ar" then elegirCamino[4] = { "arriba", i, "images/off.png"}
	elseif mapa[i] == "ai" then elegirCamino[5] = { "arribaIzquierda", i, "images/off.png"}
	elseif mapa[i] == "ad" then elegirCamino[6] = { "arribaDerecha", i, "images/off.png"}
	elseif mapa[i] == "iz" then elegirCamino[7] = { "izquierda", i, "images/off.png"}
	elseif mapa[i] == "dr" then elegirCamino[8] = { "derecha", i, "images/off.png"}
	elseif mapa[i] == "fn" then elegirCamino[9] = { "fin", i, "images/off.png"}
	end
end





--Hace disparar al Poli en su rango de vision y rotacion de las balas
local function dispararPoli( poli )
	local function autoNow()
		local i
		for i = 1, grupoManifestantes.numChildren do
			local manifestante = grupoManifestantes[i]
			if manifestante ~= nil and manifestante.x ~= nil and manifestante.y ~= nil then
				local xPos = polisArray[poli].x
				local yPos = polisArray[poli].y
				local x = manifestante.x; local y = manifestante.y;


				local angleBetween = mCeil(mAtan2( (y - yPos), (x - xPos) ) * 180 / mPi) + 90
				local sqDistance = ((x-xPos)*(x-xPos))+((y-yPos)*(y-yPos)) --a2+b2=c2
				local dist = mSqrt(sqDistance);

				local distTime = dist/0.4
				if distTime < 0 then distTime = distTime -distTime -distTime end


				--Si el manifestante sale del entra al rango.
				if dist <= 80 and dist >= 0 or dist >= -80 and dist <= 0 then
					--Rotatar al poli..
					polisArray[poli].rotation = angleBetween-180

					--Disparar Arma..
					local shot = display.newCircle(0,3,3)
					shot.x = xPos; shot.y = yPos;
					shot:setFillColor(240,0,0)
					shot.name = "arma"; shot.rotation = angleBetween+90;
					physics.addBody(shot, { isSensor = true } )
					weaponGroup:insert(shot)

					local function kill () timer.performWithDelay(2, function() if shot ~= nil then display.remove(shot); shot = nil; end; end,1);end
					polisTrans[poli] = transition.to(shot, {time = distTime, x = x, y = y, onComplete = kill})

					--Rompe el loop si tenemos un disparo.
					break;
				end
			end
		end
	end
	polisTiemp[poli] = timer.performWithDelay(1200,autoNow,0)
end



--Evento onToch para los puestos de los polis
local function onTouch( event )
	if event.phase == "ended" then
		local hitTile = event.target
		local poliID = hitTile.poliID



		--if hitTile.poliOn == false and dinero >= 100 then
		if hitTile.poliOn == false then
			polisArray[poliID] = display.newImageRect("images/poli.png",54,54)
			polisArray[poliID].x = hitTile.x; polisArray[poliID].y = hitTile.y
			grupoArmas:insert(polisArray[poliID])

			--Inicia este poli para disparar...
			dispararPoli( poliID )

		end
	end
	return true
end

--Generador de manifestantes
local function generaManifestante()
		local manifestante = display.newImageRect("images/manifestante.png",54,54)
		manifestante.x = cuadroImagen[elegirCamino[1][2]].x-54;
		manifestante.y = cuadroImagen[elegirCamino[1][2]].y;
		manifestante.name = "manifestante"; manifestante.salud = manifestanteSalud
		manifestante.movPoint = "p1" --se usa en el gameloop
		physics.addBody(manifestante, { isSensor = true } )

		manifestante.barraSalud = display.newRect(0,0,30,3)
		manifestante.barraSalud.x = manifestante.x; manifestante.barraSalud.y = manifestante.y -29;
		manifestante.barraSalud:setFillColor(0,255,0)

		grupoBarras:insert(manifestante.barraSalud)
		grupoManifestantes:insert(manifestante)
	end



--Evento gameLoop constante "onEnterFrame"
	local endCheckAmount = 0
	local function onEnterFrame(event)
		if gameIsActive == true then
			--Generar los manifestantes..
			spawnInt = spawnInt + 1
			if spawnInt == 54 and spawned ~= spawnedMax then
				generaManifestante()
				spawnInt = 0
				spawned = spawned + 1

				if spawned == spawnedMax then
					print("El juego esta apunto de terminar")
				end
			end

			--Mueve a los manifestantes a lo largo del camino..
			local i
			local manifestanteActivo = false
			for i = grupoManifestantes.numChildren, 1, -1 do
				local manifestante = grupoManifestantes[i]
				if manifestante ~= nil and manifestante.x ~= nil then

					--[[

					AQUI EL MOVIMIENTO DE ROTACION DE LOS MANIFESTANTES

					]]

					manifestanteActivo = true
					endCheckAmount = 0
				end
			end

			--usando endCheckAmount and enemyActive
			--para finalizar el juego...
			if manifestanteActivo == false then
				endCheckAmount = endCheckAmount + 1
				if endCheckAmount == 100 then
					print("cantidad maxima de manifestantes, Terminar el juego")
					local timer = timer.performWithDelay(250, levelComplete, 1)
				end
			end
		end
	end

--llama desde el gameLoop a la direccion siguiente..
	local function gameLoopManifestanteCheck( movPoint )
		local transDirecX, transDirecY, rect, nextPoint, rotate

		local function getDirect( elegirCamino )
			local direc = elegirCamino
			if direc == "right" then transDirecX = 1; transDirecY = 0; rotate = 0
			elseif direc == "left" then transDirecX = -1; transDirecY = 0; rotate = -180
			elseif direc == "up" then transDirecX = 0; transDirecY = -1; rotate = -90
			elseif direc == "down" then transDirecX = 0; transDirecY = 1; rotate = 90; end
		end

		local i
		for i=1, #elegirCamino-1 do
			if movPoint == "p"..i then
				rect = cuadroImagen[elegirCamino[i+1][2]]
				getDirect(elegirCamino[i][1])
				nextPoint = "p"..i+1
			elseif movPoint == "ep" then
				rect = cuadroImagen[elegirCamino[i+1][2]]
				getDirect(elegirCamino[i][1])
				nextPoint = "ep"
			end
		end

		return transDirecX, transDirecY, rect, nextPoint, rotate
	end


--Dibuja el mapa de recorrido de los manifestantes y puestos de los polis
local function dibujar()
	for i=1, #mapa do

		local imagenCuadrada
		local numElegirCamino = #elegirCamino
		local xPos
		local yPos
		local placementAllowed = false

		if mapa[i] == 2 then
			imagenCuadrada = "images/puesto.png"
			placementAllowed = true
		elseif mapa[i] == 1 then
			imagenCuadrada = "images/camino.png"
		else
			imagenCuadrada = "images/off.png"

		end

		--Crea las posiciones y los puestos

			cuadroImagen[i] = display.newImageRect(imagenCuadrada,54,54)
			if i <= 19 then xPos = 27+(54*(i-1)); yPos = 27
			elseif i <= 38 then xPos = 27+(54*(i-20)); yPos = 81
			elseif i <= 57 then xPos = 27+(54*(i-39)); yPos = 135
			elseif i <= 76 then xPos = 27+(54*(i-58)); yPos = 189
			elseif i <= 95 then xPos = 27+(54*(i-77)); yPos = 243
			elseif i <= 114 then xPos = 27+(54*(i-96)); yPos = 297
			elseif i <= 133 then xPos = 27+(54*(i-115)); yPos = 351
			elseif i <= 152 then xPos = 27+(54*(i-134)); yPos = 405
			elseif i <= 171 then xPos = 27+(54*(i-153)); yPos = 459
			elseif i <= 190 then xPos = 27+(54*(i-172)); yPos = 513
			elseif i <= 209 then xPos = 27+(54*(i-191)); yPos = 567
			elseif i <= 228 then xPos = 27+(54*(i-210)); yPos = 621
			elseif i <= 247 then xPos = 27+(54*(i-229)); yPos = 675
			else xPos = 27+(54*(i-248)); yPos = 729
			end
			cuadroImagen[i].x = xPos
			cuadroImagen[i].y = yPos
			grupoCuadros:insert(cuadroImagen[i])


		--crea un Listener onTouch para los puestos de los polis.
		if placementAllowed == true then
			cuadroImagen[i].poliOn = false
			cuadroImagen[i].poliID = i
			cuadroImagen[i]:addEventListener("touch", onTouch)
		end

	end
end


dibujar()
end

function scene:enterScene( event )
 storyboard.purgeScene( "menu" )
  
end



function scene:overlayEnded( event )
    physics.start()
    paused = false
end

function scene:destroyScene( event )
	print( "((destroying game view))" )
  physics.stop()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "enterScene", scene )
Runtime:addEventListener( "enterFrame", onEnterFrame )
scene:addEventListener( "overlayEnded" )	
return scene
