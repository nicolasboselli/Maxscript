-- creation du layer
pLname = "PARALLAX_planes"
if not iskindof (layermanager.getlayerfromname pLname) MixinInterface then layermanager.newlayerfromname pLname
pL = layermanager.getlayerfromname  pLname


-- récupérer les materiaux
tmp = loadTempMaterialLibrary @"M:\WParralax\HAB_INT_WPARRALAX.max"
oneMat = tmp["wP_Rooms"]

-- récupérer les fenetres dans la scene
sceneWindows = #()

-- 		clearselection()
sel = selection as array
for h in sel where iskindof h dummy and isgrouphead h do 
(
	local res
	try(res = (getUserProp h "windowsTemplate")as booleanClass)catch(res = false)
	if res then append sceneWindows h
)
sceneWindows

-- pour chaque fenetre 
for w in sceneWindows do
(
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

	-- créer une plane à la taille de la fenetre 
	xSize = distance (point3 xmin 0 0) (point3  xmax 0 0)
	ySize = distance (point3 0 ymin 0) (point3  0 ymax 0)
	zSize = distance (point3 0 0 zmin) (point3  0 0 zmax)

	shift = 50
	oneplane = plane width: (ySize + shift) length: (zSize + shift) widthsegs: 1 lengthsegs:1 transform: w.transform name: (uniqueName "ParallaxPlane_")
	oneplane.scale = [1,1,1]
		-- ajouter un random material
	addmodifier oneplane (Materialmodifier materialID:(random 1 15))
	addmodifier oneplane (uvwmap length: 300 width: 600)
	in coordsys local oneplane.position += [25,0,0]
	in coordsys local oneplane.rotation += ((eulerangles 0 90 90 ) as quat )
	

	-- mettre tous les parallaxe dans un calque
	pL.addnode oneplane
	-- appliquer le material parallax
	oneplane.material = oneMat
)

