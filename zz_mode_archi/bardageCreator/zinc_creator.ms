-- ameliorations: 
-- memoriser l'objet sur lequel on travaille
-- prévoir de faire fonctionner la decoupe en arrière de maniere optionnelle
-- memoriser le bounding box sur lequel on travaille
-- bloquer la selection de l'axe une fois qu'on a créer le bounding box
-- parenter le repere de fin d'ecart avec le repere de debut
-- faire apparaitre la box sur le helper de depart
-- memoriser les reperes avec lesquels on travaille pour pouvoir les gérer plus facilement

-- prevoir bouton pour delete bounding box et reperes
-- calculer le nombre de découpe en fonction de la taille du bounding box
-- faire que createshape fasse des corners
-- afficher la bounding box en box
-- faire un nettoyage propre de la face decoupée




rollout zincCreatorRLT "Zinc creator"
(
-- 	UI
group "Réglages"
(
	radiobuttons dirRB "direction:" labels: #("x", "y", "z") across: 2
-- 	checkbutton placePivotCB "Placer le Pivot"
	spinner ecartSP "ecart :" range: [0,1000,50] type: #integer scale: 1
	button createBBoxBT "Create Bounding Box" across: 2
	button createRepBT "Create Reperes"
)



group "Decoupe et Consequence"
(
button decoupBT "Go! Go! Decoupe" across: 4
button recupSelBT "Recup Selection"
button createShapeBT "Creation des Shapes"
button cleanFaceBT "Remove Edges"
)
	

-- 	vars

-- améliorations:
-- placer le pivot ou on veut pour qu'il tombe sur un tracé du zinc

-- faire en sorte que la découpe suive l'orientation du pivot selon x, y ou z au choix. (par défaut le plan de découpe est par rapport au monde)
local dir = undefined

-- définir l'intervalle entre deux découpes: 
-- putiliser deux helper pour définir le repère de débutr et de fin de la découpe et de distance entre deux découpe
local repereBox = undefined
local depart = undefined
local fin = undefined

-- calculer le départ la fin de la découpe en fonction de la taille de la selection(-- s'applique sur le bounding box)
local start = -1000
local start3 = undefined
local pas = undefined

local edgesToShape = undefined

	on zincCreatorRLT open do
	(
		
	)
-- découpe

	on createBBoxBT pressed do
	(
		repereBox = createBBoxFN ()
	)
	
	on createRepBT pressed do
	(
		depart = point name: ( uniquename "dep_decoupe_") rotation: repereBox.rotation position: repereBox.center box: on
		fin  = point name: ( uniquename "fin_decoupe_") rotation: repereBox.rotation position: repereBox.center parent: depart

		moveVal = case dirRB.state of (
		1: [50,0,0]
		2: [0,50,0]
		3: [0,0,50]
		)
		
		in coordsys local move fin moveVal
		
	)
	
	on decoupBT pressed do
	(

		-- définition des paramètres 
		
		dir = case dirRB.state of (
		1: [1,0,0]
		2: [0,1,0]
		3: [0,0,1]
		)
		print dir as string
		/*
		start3 = case dirRB.state of (
		1: [start,0,0]
		2: [0,start,0]
		3: [0,0,start]
		)
		print start3 as string
		*/
		start3 = in coordsys $ depart.pos
		/*
		pas = case dirRB.state of (
		1:	[ecartSP.value,0,0]
		2:	[0,ecartSP.value,0]
		3:	[0,0,ecartSP.value]
		)
		*/
		
		localDep = in coordsys $ depart.pos
		localFin = in coordsys $ fin.pos
		/*
		pas = case dirRB.state of (
		1: distance [localDep.x,0,0] [localFin.x, 0, 0]
		2: distance [localDep.y,0,0] [localFin.y, 0, 0]
		3: distance [localDep.z,0,0] [localFin.z, 0, 0]
		)
		*/
		
		pas = case dirRB.state of (
		1: (localFin.x - localDep.x)
		2: (localFin.y - localDep.y)
		3: (localFin.z - localDep.z)
		)
		
		print pas as string

	-- 	backup de la selection d'edge
		$.EditablePoly.GetSelection #edge
		
	-- nettoyage de la selection
		$.EditablePoly.SetSelection #edge #{}
		
	-- lance la découpe
		for i = 1 to 200 do
		(
			$.EditablePoly.slice dir start3 flaggedFacesOnly:on
			start3 = start3 + pas
			print start3 as string
		)
		
		edgesToShape = polyop.getEdgeSelection $
		print edgesToShape
	)
	
	on recupSelBT pressed do
	(
		$.EditablePoly.SetSelection #edge edgesToShape
	)

	on createShapeBT pressed do
	(
		$.EditablePoly.SetSelection #edge edgesToShape
		-- creation du shape
		$.EditablePoly.createShape (uniquename "zinc")  on  $  edgeFlags: 1
	)

	on cleanFaceBT pressed do
	(
		-- suppression des edges
	-- reupérer la selection de edges:
		edgeToDel = edgesToShape
		$.EditablePoly.SetSelection #edge edgesToShape
		
	-- recuperation de la selection de vertex
		-- convertion de la selection d'edge en vertex
		$.EditablePoly.ConvertSelection #edge #vertex
	-- 	recuperation de la selection de vertex
		vertToDelArray = ($.EditablePoly.GetSelection #vertex as array)

	-- 	si un vertex a moins de deux edges dans la selection d'edges alors ne pas le garder dans la selection de vertex
		vertToDel = #()
		for o in vertToDelArray do 
		(
			if (((polyop.getEdgesUsingVert $ o)*edgeToDel) as array).count > 1 then append vertToDel o
		)
	-- si le vertex en bout de course n'est lié quà deux vertex le supprimer
		
	-- selection des vertex à supprimer
		vertToDelBitArray = vertToDel as bitArray
		$.EditablePoly.SetSelection #vertex vertToDelBitArray
		
	-- 	suppression des edges et des vertex
		$.EditablePoly.remove  selLevel: #edge 
		$.EditablePoly.remove  selLevel: #vertex
	)
	


)	




createdialog zincCreatorRLT width: 600
