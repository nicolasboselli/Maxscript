/*
maj:

x- enregistrer le chemin d'accés au plan dans les file property
	-- remplacer la variable root par la variable rootPlans

x- display only jpg name
x- check plan already in scene and display with "*" in the list
x- add button  to open plan folder
add button to view plan in xnview
add button to select plan in scene

x- function to extract part of a plan (transfer uv)

-- rendre l'application de plan "plane independant"
x- remplacer le dialog box de choix ce fichier par choix de folder
-- rendre la fenetre de path editable pour rentrer directement le chemin d'accés

x- classer les plans par ordre alphbetique
*/

-- InstanceMgr.GetInstances tp &instances
-- InstanceMgr.GetInstances (Bitmaptexture()) &toto
-- bmpAr = getClassInstances  Bitmaptexture target: scenematerials
-- bmpAr[1].fileName

/*
-- fonction pour mettre le plan à la taille réelle
test = $.material.diffusemap.bitmap.filename

img = (dotNetClass "System.Drawing.Image").FromFile test
imgSize = [img.Height / img.VerticalResolution, img.Width / img.HorizontalResolution]

$.baseobject.length = (img.Height / img.VerticalResolution)*2.54
$.baseobject.width = (img.Width / img.HorizontalResolution)*2.54
*/





-- $.material.diffuseMap.HDRIMapName

sb = python.import "sandbox"
-- python.reload t
sb.hello()
-- sb.returnBBsize3

fn createPlansLayer =
(
	LM = layermanager
	planLayer
	
	if (LM.getLayerFromName "plans") == undefined then planLayer = LM.newLayerFromName "plans"
	else planLayer = LM.getLayerFromName "plans"

	planLayer
)	

fn copyPlan sel =
(
	map1
	obj1 = sel[1]
	for modif in  obj1.modifiers where classof modif == UVWmap do map1 = modif
		
	format "obj1: %\n" obj1
	format "map1: %\n" map1

	for i = 2 to sel.count do
	(
		obj2 = sel[i]
		format "obj: %\n" obj2
		-- add on plans layer
		lay = createPlansLayer()
		lay.addnode obj2
		
		obj2.renderable = off
		obj2.backfacecull = on
		
		obj2.name = uniquename obj1.name
		
		obj2.material = obj1.material
		
		map2 = uvwmap()
		
		
		addmodifier   obj2 map2
		classof obj2 --hack to force stack update
		
		map2.maptype = map1.maptype 
		
		map2.uflip = map1.uflip
		map2.vflip = map1.vflip
		map2.wflip = map1.wflip
		
		map2.width = map1.width 
		map2.length = map1.length
		map2.height = map1.height 
		
		map2.gizmo.transform = (map1.gizmo.transform * obj1.objecttransform) * inverse obj2.objecttransform
	)
)


struct planClass
(
	path,

	fn checkinscene  =
	(
		local inscene = False
		local bmpAr = getClassInstances  Bitmaptexture target: scenematerials
		
		for oneBmp in  bmpAr do
		(
			if oneBmp.filename != undefined do
			(
				if oneBmp.filename == path do
				(
					inscene =  true
					break
				)
			)
		)
		inscene
	),
		
	inscene = checkinscene(),
	
	fn checkname =
	(
		local basename = getFilenameFile path
		if inscene == true then
		(
			return ("_______LOADED____" + basename )
		)
		else
		(
			return basename
		)
	),

	name = checkname()
	
)

-- createPlaneRLT.rootPlans
-- getProperty createPlaneRLT "root"
-- getProperty  createPlaneRLT "rootPlans"
try(destroyDialog createPlaneRLT)catch()
-- global createPlaneRLT
rollout createPlaneRLT "create plane"
(
	local params = #("pos", "root", "rootPlans")
	
-- 	vars
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	local openFileName
	local root = "C:\\"
	local jpgList = #()
	local jpgSel
	
	local rootPlans = "toto"
	
	local lastLine = 220
	
	local planObjList = #()
	
	edittext pathToSearchET "path: "readOnly: false width: 400 pos: [10,10]
	button searchBT "..."  pos: [420,10]
	button openFoldBT "open" pos: [450,10]
	button refreshFoldBT "refresh" pos: [490,10]
	button initFromPlaneBT "init from plans"
		
	listbox jpgListBox "jpg list:"
	
	button bmpFitBT "Bitmap Fit" pos:[ 20  , lastLine] across: 3
	button createPlaneBT "create"  pos:[ 100 , lastLine]
	button injectMapBT "inject" pos:[170,lastLine]
	
-- 	button createA4BT "createA4" pos:[ 20 , lastLine]

-- 	button changeMapBT "change map" pos:[270,lastLine]
-- 	button transferMapBT "transfer map" pos:[370,lastLine]
	
-- 	functions
	-- functions
	fn sortbyname v1 v2 =
	(
		-- 	vars
		local d
		
		if ( v1.name < v2.name) then
			d=-1
		else
			d=1
		
		--compare les numeros entre eux et les classe	
		case of
		(
			(d < 0.): 1
			(d > 0.): -1
			default: 0
		)
	)

	fn collectPlansList =
	(
		if root != undefined and root != "C:\\" then 
		(
-- 			root = rootIni
			
			jpgList = getFiles (root + "*.jpg")
			jpgList2 = getFiles (root + "*.jpeg")
			
			jpgList = jpgList + jpgList2
			
-- 			planObjList = initPlanClass jpgList
			planObjList = for oneJpg in jpgList collect (planClass oneJpg)
			
			qsort planObjList sortbyname
		)
		else(format "pas de root\n")
	)
	
	
-- 	create plane and add plan material
	fn createMappedPlane oneJpg = 
	(

	-- 	createMap
		jpgMap = Bitmaptexture fileName: oneJpg name: ("zz_map_" + (getFilenameFile oneJpg))
			
		-- 	create material
		tmpMaterial = Standardmaterial name: ("zz_plan_" + (getFilenameFile oneJpg))
		tmpMaterial.diffuseMap = jpgMap
		tmpMaterial.showInViewport =on
		
		-- 	create plane
		tmpPlane = Plane length:tmpMaterial.diffuseMap.bitmap.height width: tmpMaterial.diffuseMap.bitmap.width\
		pos:[0,0,0]  lengthsegs: 1 widthsegs: 1 \
		name: ("plane_" + (getFilenameFile oneJpg)) \
		backfacecull: on renderable: off
		

		-- 	assign material on plane
		tmpPlane.material = tmpMaterial
		tmpPlane
	)
		
-- 	delete uvwmap
	fn deleteUVWmap onePlane =
	(
		for i = onePlane.modifiers.count to 1 by -1 do
		(
			if ((classOf onePlane.modifiers[i]) == Uvwmap) do
			(
				deleteModifier onePlane i
			)
		)
	)
	

-- 	rename plane and add plane material
	fn reMapPlane onePlane oneJpg= 
	( 
		onePlane.name = ("plane_" + (getFilenameFile oneJpg)) 
		
		jpgMap = Bitmaptexture fileName: oneJpg name: ("zz_map_" + (getFilenameFile oneJpg))
	-- 	create material
		tmpMaterial = Standardmaterial name: ("zz_plan_" +(getFilenameFile oneJpg))
		tmpMaterial.diffuseMap = jpgMap
		tmpMaterial.showInViewport =on
		-- 	assign material on plane
		onePlane.material = tmpMaterial
		onePlane
	)

	
	fn ajustUVWmap onePlane= 
	(
		local bbsize = sb.returnBBsize3  onePlane
-- 		format "bbsize: %\n" bbsize
		local myUV
		
		try
		(
			myUV = onePlane.uvwmap
			myUV.length = bbsize.y
			myUv.width = bbsize.x
		)
		catch
		(
			myUV = Uvwmap length: bbsize.y width: bbsize.x
			addmodifier onePlane myUV
		)
		
		-- recupération des dimension du bmp en pixels
		myBitmap = onePlane.material.diffusemap.bitmap
		
		bitHeight = myBitmap.height
		bitWidth = myBitmap.width

		UVlength = myUV.length

		myUV.width = (UVlength*bitWidth)/bitHeight
	)
		
	fn refreshUI =
	(
		pathToSearchET.text = root
		jpgListBox.items = for jpg in planObjList collect jpg.name
	)

-- 	$.uvwmap
-- 	collect jpg
	on pathToSearchET entered onePathName do
	(
		if onePathName != undefined then
		(	
			root = onePathName + "\\"
			rootPlans = onePathName + "\\"
			
			collectPlansList() 
			refreshUI()			
		)
	)
	
	
	on searchBt pressed do
	(
		plansFolder = getSavePath caption: "Select plans folder" initialDir: pathToSearchET.text

		if plansFolder != undefined then
		(	
			root = plansFolder + "\\"
			rootPlans = plansFolder + "\\"
			
			collectPlansList() 
			refreshUI()			
		)
	)
	
	on openFoldBT pressed do
	(
-- 		foldToOPen = pathToSearchET.text
		format "root: %\n" root
		doscommand ("explorer " + root)
	)
	
	on jpgSizeUpBT pressed do
	(
		jpgListBox.height += 50
		createPlaneRLT.height += 50
	)
	
	on jpgSizeDwBT pressed do
	(
		jpgListBox.height -= 50
		createPlaneRLT.height -= 50
	)
	
	on createPlaneBT pressed do
	(
		intSel = jpgListBox.selection 
		jpgSel = planObjList[intSel]
		
		
		mapPlane = createMappedPlane jpgSel.path
		ajustUVWmap mapPlane
		
		-- placement du plan sur le layer plan
		lay = createPlansLayer()
		lay.addnode mapPlane
		
		-- update listbox
		collectPlansList() 
		refreshUI()	

		select mapPlane
	)
	
	on createA4BT pressed do
	(
		intSel = jpgListBox.selection 
		jpgSel = planObjList[intSel]
				
		mapPlane = createA4  jpgSel.path
		ajustUVWmap mapPlane
		
		lay = createPlansLayer()
		lay.addnode mapPlane
		
		-- update listbox
		collectPlansList() 
		refreshUI()
		
		select mapPlane
	)
	
	on changeMapBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			intSel = jpgListBox.selection 
			jpgSel = planObjList[intSel]
			
			mapPlane = reMapPlane sel[1] jpgSel.path
-- 			ajustUVWmap mapPlane
		)
	)
	
	on initFromPlaneBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			format "%\n" (getFilenamePath (sel[1].material.diffuseMap.filename))
			rootPlans = (getFilenamePath (sel[1].material.diffuseMap.filename))
			root = rootPlans
			collectPlansList()
			refreshUI()
		)
		else()
	)
	
	on bmpFitBT pressed do
	(
		sel = selection as array
		if sel.count == 1 do
		(
			ajustUVWmap sel[1]
			
			sel[1].name = ("plane_" + (getFilenameFile (sel[1].material.diffuseMap.filename))) 
			
			lay = createPlansLayer()
			lay.addnode sel[1]
			
			sel[1].renderable = off
			sel[1].backfacecull = on
		)
	)
	
	on injectMapBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			deleteUVWmap sel[1]
			
			intSel = jpgListBox.selection 
			jpgSel = planObjList[intSel]

			mapPlane = reMapPlane sel[1] jpgSel.path
			ajustUVWmap mapPlane
			
			-- update listbox
			collectPlansList() 
			refreshUI()	

		)
	)
	
	on refreshFoldBT pressed do
	(
		collectPlansList()
		refreshUI()
	)
	
	on createPlaneRLT open do
	(
		loadRolloutParams createPlaneRLT params
-- 		rootPlans = root
		root = rootPlans
		collectPlansList()
		refreshUI()
	)
	
	on createPlaneRLT close do
	(
		writeRolloutParams createPlaneRLT params 
	)
	
	on createPlaneRLT resized size do
	(
		local sub = 30
		jpgListBox.height = createPlaneRLT.height - 120
		bmpFitBT.pos = [20, createPlaneRLT.height - sub]
		createPlaneBT.pos = [ 100 , createPlaneRLT.height - sub]
		injectMapBT.pos = [170, createPlaneRLT.height - sub]
		
-- 		changeMapBT.pos = [250, createPlaneRLT.height - sub]
-- 		transferMapBT.pos = [350, createPlaneRLT.height - sub]
		
-- 		createA4BT.pos =  [ 20 , createPlaneRLT.height - sub]
	)
	
	on transferMapBT pressed do
	(
		sel = selection as array
		copyPlan sel
	)
)


createDialog createPlaneRLT width: 550 style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

