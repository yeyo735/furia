
--local esc = {}

--local function run()

	--Dll de physics para las balas gravedad 0
	local physics = require ("physics")
	physics.start()
	physics.setGravity( 0, 0 )

	local grupoLocal = display.newGroup()
	local grupoCuadros = display.newGroup()
	grupoLocal:insert(display.newImage("images/background.jpg"))
	grupoLocal:insert(grupoCuadros)


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
			if mapa[i] == "fn" then
				cuadroImagen[i].name = "fn";
				physics.addBody(cuadroImagen[i], { isSensor = true } )
			end

			--crea un Listener onTouch para los puestos de los polis.
			if placementAllowed == true then
				cuadroImagen[i].towerOn = false
				cuadroImagen[i].towerID = i
				cuadroImagen[i]:addEventListener("touch", levelTouched)
			end

		end
	end


	dibujar()
--end




--esc.run = run

--return esc
