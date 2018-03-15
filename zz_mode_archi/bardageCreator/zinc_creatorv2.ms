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

-- zincCreatorFN = openfile "D:\github_repo\DEV_maxscript\00_wip\zz_mode_archi\bardageCreator\zinc_creator_bounding_box_fn.ms"

-- 	vars
fn returnScriptRoot =
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local scriptRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	return scriptRoot
)

scriptRoot = returnScriptRoot()
filein (scriptRoot + "\zz_mode_archi\\bardageCreator\\zinc_creator_bounding_box_fn.ms")

-- zincCreatorFN = openfile (modeArchiScriptRoot + "\bardageCreator\zinc_creator_bounding_box_fn.ms")
-- execute zincCreatorFN

rollout zincCreatorRLT "Zinc creator"
(
-- 	UI
group "Réglages"
(
	radiobuttons dirRB "direction:" labels: #("x", "y", "z") across: 3
-- 	checkbutton placePivotCB "Placer le Pivot"
	spinner ecartSP "ecart :" range: [0,1000,50] type: #integer scale: 1
	button createBBoxBT "Create Reperes" 
-- 	button createRepBT "Create Reperes"
)



group "Decoupe et Consequence"
(
button decoupBT "Go! Go! Decoupe" across: 2
button decoupBT2 "Go! Go! Decoupe v2" 
button recupSelBT "Recup Selection" across: 2
button createShapeBT "Creation des Shapes"
-- button cleanFaceBT "Remove Edges"
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
		
		depart = point name: ( uniquename "dep_decoupe_") rotation: repereBox.rotation position: repereBox.center box: on wirecolor: green
		fin  = point name: ( uniquename "fin_decoupe_") rotation: repereBox.rotation position: repereBox.center parent: depart  box: off wirecolor: green

		moveVal = case dirRB.state of (
		1: [50,0,0]
		2: [0,50,0]
		3: [0,0,50]
		)
		
		in coordsys local move fin moveVal
			
		delete repereBox
	)
	
	on decoupBT pressed do
	(
		if (classOf $ == Editable_Poly) then
		(
			-- définition des paramètres 
			-- direction
			v1 = depart
			v2 = fin

			dir = normalize (v2.position - v1.position)
			print dir as string

			start3 = in coordsys $ depart.pos
			
			-- ecartement
			localDep = in coordsys $ depart.pos
			localFin = in coordsys $ fin.pos
			
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
			for i = 1 to 600 do
			(
				$.EditablePoly.slice dir start3 flaggedFacesOnly:on
				start3 = start3 + pas
				print start3 as string
			)
			
			edgesToShape = polyop.getEdgeSelection $
			print edgesToShape
		)
		else( print "revoyez la selection")
	)
	
	on decoupBT2 pressed do
	(
		try  
		(
			-- définition des paramètres 
			-- direction
			v1 = in coordsys $ depart.pos
			print ("dep:" + ( v1 as string))
			v2 = in coordsys $ fin.pos
			print ("fin:" + (v2 as string))
			
			
			dir = normalize (v2 - v1)
			print ("dir:" + (dir as string))
			
			format "depart: % ; fin: % dir: %" 10 10 10 
				
			start3 = in coordsys $ depart.pos
			print start3
			
			ecart = distance depart.pos  fin.pos
			print ecart

			s = splineShape name: "test"

			addNewSpline s

			addKnot s 1 #corner #line [0,0,0]
			addKnot s 1 #corner #line  (dir*ecart)

			updateshape s
			
			s.parent = $
			
			in coordsys parent s.position = start3
			in coordsys parent s.rotation = (quat 0 0 0 0)
			
			pas2 = dir*ecart
			
			print pas2
			
-- 			updateshape $ 

			-- 	backup de la selection d'edge
			$.EditablePoly.GetSelection #edge
			
		-- nettoyage de la selection
			$.EditablePoly.SetSelection #edge #{}
			
			$.setSlicePlane &dir &start3 20.0
-- 			
		-- lance la découpe
			
			for i = 1 to 600 do
			(
				$.EditablePoly.slice dir start3 flaggedFacesOnly:on
				start3 = start3 + pas2
				print start3 as string
			)
			
			
			
			
			edgesToShape = polyop.getEdgeSelection $
			print edgesToShape
		)
		catch( print "error")
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
