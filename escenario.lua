
--local esc = {}

--local function run()

	--Dll de physics para las balas gravedad 0
	local physics = require ("physics")
	physics.start()
	physics.setGravity( 0, 0 )

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

	local grupoLocal = display.newGroup()
	local grupoCuadros = display.newGroup()
	local grupoManifestantes = display.newGroup()
	local grupoArmas = display.newGroup()
	
	grupoLocal:insert(display.newImage("images/background.jpg"))
	grupoLocal:insert(grupoCuadros)
	grupoLocal:insert(grupoArmas)


	local cuadroImagen = {}

	local mapa = {
		0,   0,   0,   0,   0,   0,   0,   0,   0, "fn",  0,   0,   0,   0,   0,   0,   0,   0,   0,
		0,   0,   0,   2,   0,   0,   2,   0,   2,   1,   2,   0,   2,   0,   0,   2,   0,   0,   0,
		0,   0, "dr",  1,   1,   1,   1,   1,   1, "ar",  1,   1,   1,   1,   1,   1, "iz",  0,   0,
		0,   0,   1,   1,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   1,   1,   0,   0,
		0,   0,   1,   0,   1,   2,   0,   0,   0,   0,   0,   0,   0,   2,   1,   0,   1,   0,   0,
		0,   0,   1,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0,   1,   0,   0,   1,   0,   0,
		0,   0,   1,   2,   0,   0, "ai",  0,   0,   0,   0,   0, "ad",  0,   0,   2,   1,   0,   0,
		0,   0,   1,   0,   0,   0,   1,   2,   0,   0,   0,   2,   1,   0,   0,   0,   1,   0,   0,
		0,   0,   1,   2,   0,   2, "ar",  0,   0,   0,   0,   0, "ar",  2,   0,   2,   1,   0,   0,
		0,   0,   1,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0,   1,   0,   0,   1,   0,   0,
		0,   0,   1,   2,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   2,   1,   0,   0,
		0,   0,   1,   1,   0,   0,   2,   0,   0,   2,   0,   0,   2,   0,   0,   1,   1,   0,   0,
	  "in",  1, "add", 1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1, "adi", 1, "in",
		0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
	}

	--Puntos donde los manifestantes cambian de direccion

	local elegirCamino = {}

	for i=1, #mapa do

		if mapa[i] == "in" then elegirCamino[1] = { "inicio", i}
		elseif mapa[i] == "add" then elegirCamino[2] = { "arribaDiagonalDerecha", i}
		elseif mapa[i] == "adi" then elegirCamino[3] = { "arribaDiagonalIzquierda", i}
		elseif mapa[i] == "ar" then elegirCamino[4] = { "arriba", i}
		elseif mapa[i] == "ai" then elegirCamino[5] = { "arribaIzquierda", i}
		elseif mapa[i] == "ad" then elegirCamino[6] = { "arribaDerecha", i}
		elseif mapa[i] == "iz" then elegirCamino[7] = { "izquierda", i}
		elseif mapa[i] == "dr" then elegirCamino[8] = { "derecha", i}
		elseif mapa[i] == "fn" then elegirCamino[9] = { "fin", i}
		end
	end





	--Hace disparar al Poli en su rango de vision
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
					local dist = mSqrt(sqDistance); --Sqaure root it.

					local distTime = dist/0.4
					if distTime < 0 then distTime = distTime -distTime -distTime end


					--If the enemy is close we shoot.
					if dist <= 80 and dist >= 0 or dist >= -80 and dist <= 0 then
						--Rotate the tower..
						polisArray[poli].rotation = angleBetween-180

						--Fire the weapon..
						local shot = display.newCircle(0,3,3)
						shot.x = xPos; shot.y = yPos;
						shot:setFillColor(240,0,0)
						shot.name = "weapon"; shot.rotation = angleBetween+90;
						physics.addBody(shot, { isSensor = true } )
						weaponGroup:insert(shot)

						local function kill () timer.performWithDelay(2, function() if shot ~= nil then display.remove(shot); shot = nil; end; end,1);end
						polisTrans[poli] = transition.to(shot, {time = distTime, x = x, y = y, onComplete = kill})

						--Break out the loop if we have fired.
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



			--if hitTile.poliOn == false and money >= 50 then
			if hitTile.poliOn == false then
				polisArray[poliID] = display.newImageRect("images/poli.png",54,54)
				polisArray[poliID].x = hitTile.x; polisArray[poliID].y = hitTile.y
				grupoArmas:insert(polisArray[poliID])

				--Inicia esta torre para...
				--dispararPoli( poliID )

				--Descuenta Dinero para comprar Policia
				--changeText("Dinero", 100)
				hitTile.poliOn = true

			elseif hitTile.poliOn == true then
				--Remove tower and add 40 money..
				hitTile.poliOn = false
				--changeText("Dinero", -40)
				--display.remove(polisArray[poliID]); polisArray[poliID] = nil
			end
		end
		return true
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
					imagenCuadrada = "images/puesto.jpg"
					placementAllowed = true
			end

			--Crea las posiciones de los puestos
			if imagenCuadrada == "images/puesto.jpg" then
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

			end

			--si se encuantra en el cuadro final (fn) agregar un objeto a physics.
			--if mapa[i] == "fn" then
				--cuadroImagen[i].name = "fn";
				--physics.addBody(cuadroImagen[i], { isSensor = true } )
			--end

			--crea un Listener onTouch para los puestos de los polis.
			if placementAllowed == true then
				cuadroImagen[i].poliOn = false
				cuadroImagen[i].poliID = i
				cuadroImagen[i]:addEventListener("touch", onTouch)
			end

		end
	end


	dibujar()



--end




--esc.run = run

--return esc
