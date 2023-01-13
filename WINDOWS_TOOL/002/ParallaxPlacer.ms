fn createParallax w =
(
	local onePlane

	-- recupérer les objets qui le compase
	wNodeAr = #(w)
	for o in wNodeAr do 
	(
		for c in o.children do appendifunique wNodeAr c
	)
	wNodeAr.count	

	-- definir taille du bounding box
	wbbAr = for o in wNodeAr collect (nodeGetBoundingBox o w.transform)

	xmin =  ymin = zmin = 10000
	xmax = ymax = zmax = -10000

	for bb in wbbAr do
	(
		if bb[1].x < xmin then xmin = bb[1].x
		if bb[2].x > xmax then xmax = bb[2].x
		
		if bb[1].y < ymin then ymin = bb[1].y
		if bb[2].y > ymax then ymax = bb[2].y
			
		if bb[1].z < zmin then zmin = bb[1].z
		if bb[2].z > zmax then zmax = bb[2].z
	)

	-- définir la taille de la fenetre 
	xSize = distance (point3 xmin 0 0) (point3  xmax 0 0)
	ySize = distance (point3 0 ymin 0) (point3  0 ymax 0)
	zSize = distance (point3 0 0 zmin) (point3  0 0 zmax)

	shift = 50
	shift2 = 75
	oneplane = plane width: (ySize + shift2) length: (zSize + shift) widthsegs: 1 lengthsegs:1 transform: w.transform name: (uniqueName "ParallaxPlane_")
	oneplane.position = w.center
	oneplane.scale = [1,1,1]
	
	-- ajouter un random material
	randID = random 1 35
-- 	if randID == 7 or randID == 9 then randID = random 1 15
-- 	matId = random 1 15
	
	addmodifier oneplane (Materialmodifier materialID: randID)
		
	addmodifier oneplane (uvwmap length: 300 width: 600)
	
	-- décalage de la plane
	/*
	in coordsys local oneplane.position += [50,0,0]
	in coordsys local oneplane.rotation += ((eulerangles 0 90 90 ) as quat )
	*/
	
-- 	oneplane.transform = rotateYMatrix -90 * oneplane.transform 
	oneplane.transform = rotateyMatrix -90 * oneplane.transform 
	oneplane.transform = rotatezMatrix -90 * oneplane.transform 
	oneplane.transform =  transMatrix (point3 0 0 -50) * oneplane.transform
	
	
	onePlane
)

try(destroydialog parallaxplacerRLT)catch()
rollout parallaxplacerRLT "parallax Placer"
(
	local pLname = "WPARALLAX_planes"
	local pL
-- 	local wpMatPath = @"M:\Biblio\VISIOLAB\2-Assets3D\Elements_batiments\Parralax\HAB_INT_WPARRALAX.max"
	local wpMatPath = @"M:\Biblio\VISIOLAB\3-Materials\VISIOLAB_MATLIB.mat"
	
	global wpLib
	global wPRoomsMat
	global wPRoomsMatNuit
	
	local windowsSet
	
	group "JOUR"
	(
		button placeBT "parallax sur selection" across:2
		button placeAllBT "parallax partout"
	)
	
	group "NUIT"
	(
		button placeNuitBT "parallax sur selection" across:2
		button placeAllNuitBT "parallax partout"
	)

	
	fn createLayer =
	(
		-- creation du layer
		
		if not iskindof (layermanager.getlayerfromname pLname) MixinInterface then layermanager.newlayerfromname pLname
		pL = layermanager.getlayerfromname  pLname
	)
	
	fn loadMaterial =
	(
		if not iskindof wpLib MaterialLibrary then wpLib = loadTempMaterialLibrary wpMatPath
		wPRoomsMat = wpLib["PARALLAX__TOUT_JOUR"]
		wPRoomsMatNuit = wpLib["PARALLAX__TOUT_NUIT"]
	)
	
	fn findWindows oneArray = 
	(
		windowsSet = #()
		for h in oneArray where iskindof h dummy and isgrouphead h do 
		(
			local res
			try(res = (getUserProp h "windowsTemplate")as booleanClass)catch(res = false)
			if res then append windowsSet h
		)
		windowsSet
	)
	
	on placeBT pressed do
	(
		-- creation du layer
		createLayer()

		-- récupérer les materiaux
		loadMaterial()

		-- récupérer les fenetres dans la scene
		sceneWindows = #()

		-- 		clearselection()
		findWindows (selection as array)

		-- pour chaque fenetre 
		for w in windowsSet do
		(
			onePlane = createParallax w
			-- mettre tous les parallaxe dans un calque
			pL.addnode oneplane
			-- appliquer le material parallax
			oneplane.material = wPRoomsMat
		)

	)
	
	on placeAllBT pressed do
	(	
		createLayer()
		loadMaterial()
		sceneWindows = #()
		findWindows helpers
		for w in windowsSet do
		(
			onePlane = createParallax w
			
			pL.addnode oneplane
			oneplane.material = wPRoomsMat
		)

	)
	
	on placeNuitBT pressed do
	(
		-- creation du layer
		createLayer()

		-- récupérer les materiaux
		loadMaterial()

		-- récupérer les fenetres dans la scene
		sceneWindows = #()

		-- 		clearselection()
		findWindows (selection as array)

		-- pour chaque fenetre 
		for w in windowsSet do
		(
			onePlane = createParallax w
			-- mettre tous les parallaxe dans un calque
			pL.addnode oneplane
			-- appliquer le material parallax
			oneplane.material = wPRoomsMatNuit
		)
		
	)
	
	on placeAllNuitBT pressed do
	(
		createLayer()
		loadMaterial()
		sceneWindows = #()
		findWindows helpers
		for w in windowsSet do
		(
			onePlane = createParallax w
			
			pL.addnode oneplane
			oneplane.material = wPRoomsMatNuit
		)
	)
)
CreateDialog parallaxplacerRLT


