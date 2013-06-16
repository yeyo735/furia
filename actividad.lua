local act = {}

local function iniciar()

	local physics = require ("physics")
	physics.start()
	physics.setGravity( 0, 0 )

	--Grupos
	local grupoLocal = display.newGroup()
	local grupoManifestantes = display.newGroup()
	local grupoPolicias = display.newGroup()

	--Variables
	local _Ancho = display.contentWidth
	local _Alto = display.ContentHeight
	local dinero = 300

	--Variables Manifestantes
	local manifestanteSalud = 100
	local manifestanteVelocidad = 10

end

act.iniciar = iniciar

return act
