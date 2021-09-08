sel = selection as array
leader
for s in sel where iskindof s dummy and isgrouphead s do leader = s
leader.children.count
for s in sel do 
(
	format "bb: %\n"(nodeGetBoundingBox s (matrix3 1))
)

-- récupérer les fenetres dans la scene
sceneWindows = #()
-- 		clearselection()
for h in helpers where iskindof h dummy and isgrouphead h do 
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
	wNodeAr = for c in w.children collect w
	for c in wNodeAr do 
	(
		for c in c.children do append wNodeAr c
	)
	wNodeAr
		
	-- collecter tous les bounding box des objets qui composent le groupe
	wbbAr = for o in wNodeAr collect (nodeGetBoundingBox s w.transform)
	
	-- definir le boundingbox de la fenetre
	xmin, xmax, ymin, ymax, zmin, zmax
	
	-- definir taille du bounding box
	-- créer une plane à la taille de la fenetre 
	
)

