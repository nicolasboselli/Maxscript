/*
TODO:
-- setup vray
/- créer une light devant chaque gabarit de fenetre
	-- integrer une option pour créer les lumière pour chaque type de fenetre
	
/- créer un light ou deux au dessus de chasue pièce
	-- prob: le centre d'une pièce n'est pas forcement le meilleur endroit pour placer la light
	
-- conformer l'angle de la camera par rapport au sol et pour prendre le maximum du plan  de cellule dans le cadre
-- créer le rig de lighting et ajuster leur position 
*/

fn returnBBsize3 ref = 
(
	bb = nodeGetBoundingBox ref ref.transform

	xsize = distance ([bb[1].x,0,0]) ([bb[2].x,0,0])
	ysize = distance ([0, bb[1].y,0]) ([0,bb[2].y,0])
	zsize = distance ([0,0,bb[1].z]) ([0,0,bb[2].z])
	format "ref: % size: %\n" ref.name  [xsize, ysize, zsize]
	
	[xsize, ysize, zsize]
)

fn explodeByElts s =
(
	local detached = #()
	if classof s == editable_poly then
	(
		facesCount = polyop.getNumFaces s
		while facesCount > 0 do
		(
			newName = uniqueName s.name
			facesToDetachs = polyop.getElementsUsingFace s #{1}
			polyop.detachFaces s facesToDetachs delete:true asNode:true name: newName
			
			newObj = getnodebyname newName
			append detached newObj
			
			facesCount = polyop.getNumFaces s
		)
		delete s		
	)
	else
	(
		format "selectionnez un edtable_poly"
	)
	detached
)


-- ##################  créer une light devant chaque gabarit de fenetre ############################
fn createWindowsLight =
(
	local vlList = #()
	-- nettoyage du additive layer
	addLightLayerName = "add_lights_windows"

	addLightLayer = LayerManager.getLayerFromName addLightLayerName
	if addLightLayer == undefined then addLightLayer = LayerManager.newLayerFromName addLightLayerName
	else
	(
		addLightLayer.nodes &tmpAptNodes
		delete tmpAptNodes
	)

	-- collecte des gabarits
	gabLayerList = collectLayer pattern: (gabSuf + "*")
	gabList = rafle layerList: gabLayerList

	-- creation d'une light devant chaque fenetre
	for g in gabList do
	(
		-- recuperation de la taille du gabarit
		local gabSize = returnBBsize3 g
		
		vl = vrayLight transform: g.transform lightDistribution: 0.5 preview_distribution: 0 sizeLength: (gabSize.z*0.8) sizeWidth: (gabSize.y*0.8) invisible: on
		vl.position = g.center
		in coordsys local rotate vl (angleaxis -90 [0,1,0])
		in coordsys local move vl [0,0,-30]
			
		append vlList vl
	)
	for vl in vlList do addLightLayer.addnode vl
	vlList
)
-- createWindowsLight()

-- ################################ create sol lighting #############################


-- creation des light au plafond
fn createSolLights =
(
	local slList = #()
	-- nettoyage du additive layer
	local solLightLayerName = "add_lights_sol"

	solLightLayer = LayerManager.getLayerFromName solLightLayerName
	if solLightLayer == undefined then solLightLayer = LayerManager.newLayerFromName solLightLayerName
	else
	(
		solLightLayer.nodes &tmpAptNodes
		delete tmpAptNodes
	)

	copySols = #()
	sol = $sol
	-- classof sol
	copySol = copy sol
	converttopoly copySol
	copySols = explodeByElts copySol

	for c in copySols do
	(
		c.pivot = c.center
		local roomSize = returnBBsize3 c
		local areaTmp = roomSize.x * roomSize.y
		format "areaTmp: %\n" areaTmp
		if areaTmp < 15000 then 
		(
			delete c
			continue
		)
		
		sl = vrayLight transform: c.transform lightDistribution: 0.5 preview_distribution: 0 sizeLength: 150 sizeWidth: 150 invisible: on
		sl.position = c.center
	-- 	in coordsys local rotate sl (angleaxis 180 [0,1,0])
		in coordsys local move sl [0,0,300]
		
		solLightLayer.addnode sl
		
		append slList sl
		
		delete c
	)
)
-- createSolLights()
	

-- ############################## conform camera ############################
-- cadrer les objets dans la scene au plus pre
-- contraindre l'angle de la camera avec le sol