/*
maj:
	- corriger l'orientation des gabarit et recalculant sur le gabarit la plus grande suraface pour réorienté en x
*/

-- s = $

-- créer un sous calque dans le calque de l'objet selectionné avec le nom de l'objet
-- mettre les fenetres detachees dedans
fn collectWindowsGroup s =
(
	-- init de l'array des groupes de ffaces
	global grpAr = #()

	-- init des bitarrays de faces et de selection de faces pour traiter une selection
	faceBitAr = getFaceSelection s
	facesSel =  #{(faceBitAr as array)[1]}

	-- collecte de tous les vertex de l'objet et de leurs positions
	allVerts = (for i = 1 to (getNumVerts s) collect i) as bitarray
	vxPos = meshop.getVerts s allVerts

	-- collect des vertex à tester, vertex des faces selectionnées	
	vxBitAr = (meshop.getVertsUsingFace s faceBitAr)

	-- init du bitarray d'un groupe de vertex pour une fenetre
	vxSel = #{}
	otherVx = vxBitAr
	-- vxSel.isempty
	distTresh = 10.0

	turn = 0
	-- timing
	bef = timestamp()
	global startingTime = timestamp()
	startingFacesCount = faceBitAr.numberSet

	-- ####### TOUR 
	-- collecter les vertex voisin par elements
	while not (faceBitAr as array).count == 0 do
	(
		turn +=1
		
		-- collecte des face du m^me element que la face à tester
		facesSel = meshop.getElementsUsingFace s facesSel
		
		-- collecter les vertex voisins à  tester
		if vxSel.isEmpty then otherVx = vxBitAr - vxSel
		else otherVx = otherVx - vxSel
		
		-- collecter les vertex utilisants les Face Selection
		vxSel += (meshop.getVertsUsingFace s facesSel)
		
		-- collecte des vertex voisins, par distance
		nearVx = #{}
		for v in vxSel do
		(
	-- 		format "v: % otherVx.count: %\n" v (otherVx as array).count
		-- 	posref = vxPos[v]
			for ov in otherVx do
			(
		-- 		posTest = vxPos[ov]
				if (distance  vxPos[v] vxPos[ov]) <= distTresh then 
				(
		-- 			format " v: % ov:% distance: %\n" v ov (distance  vxPos[v] vxPos[ov])
					nearVx += #{ov}
				)
				else if (distance  vxPos[v] vxPos[ov]) > 500 then 
				(
					otherVx -= #{ov}
				)
			)
		)
		vxSel += nearVx
		
		-- collecter les faces utilisant  les vertex
		facesSel += (meshop.getFacesUsingVert s vxSel)
		
		-- si collecte est nulle, passer au groupe suivant
		if nearVx.isempty then
		(
			append grpAr facesSel
			
			local lastTurnTime = (((timestamp()) - bef) / 1000 as float)
			local ellapsedTime = (((timestamp()) - startingTime) / 1000 as float)
			local passedFacesCount = (startingFacesCount - faceBitAr.numberset)
			local remainingFacesCount = faceBitAr.numberset
			local timePerFace =  (ellapsedTime/passedFacesCount)
			local remainingTime = timePerFace*remainingFacesCount
			
			format "group % collected " grpAr.count
	-- 		format "turns: % " turn
	-- 		format "remainingFacesCount: % " remainingFacesCount
			format "in: %s " lastTurnTime
			format "remaining: %s " remainingTime 
			format "ellapsed: %s " ellapsedTime
	-- 		format "passed_faces: % " passedFacesCount
	-- 		format "timePerFace: %s " timePerFace
			
	-- 		format "\nfacesSel: %\n"  facesSel
	-- 		format "collect done: % s\n" 
			format "\n"
			
			bef = timestamp()
			
			faceBitAr -= facesSel
			
		-- 	format "faceBitAr: % facesSel: % grpAr: %\n" faceBitAr facesSel grpAr.count
			
			if not faceBitAr.isempty then
			( 
				-- collecte de la face de la nouvelle fenetre à trouver
				facesSel = #{(faceBitAr as array)[1]}
				-- retranchement des vertex du précedent froupe de tous les vertex à tester
				vxBitAr = vxBitAr - vxSel
				-- reinitialisation des vertex de la selection
				vxSel = #{}
				-- reinitialisation du nombre de tour
				turn = 0 
			
			)
			else
			(
				format "\n###############this is the end ! groups count: % done in % s\n" grpAr.count (((timestamp()) - startingTime) / 1000 as float)
			) 
		)
		
		if turn > 10 then 
		(
			format "maximum turns done! Force Group\n"
		
			-- collecte de la face de la nouvelle fenetre à trouver
			facesSel = #{(faceBitAr as array)[1]}
			-- retranchement des vertex du précedent froupe de tous les vertex à tester
			vxBitAr = vxBitAr - vxSel
			-- reinitialisation des vertex de la selection
			vxSel = #{}
			-- reinitialisation du nombre de tour
			turn = 0 
			
			
-- 			exit
		)
		if grpAr.count >= 1000 then 
		(
			format "Total Time: %s\n" (((timestamp()) - startingTime) / 1000 as float)
			exit
		)
	)
)
-- format "\n############### DONE! groups count: %\n" grpAr.count

-- countShiftGroupNum()

---CREATION D un GABARIT par group de FACES
fn createGabarits s =
(
	global gabaritAr = #()
	local shiftCount = 
	
	startGabaritTime = timestamp()
	
	angleTresh = 1.0
	groupNum = 0

	for faceSel in grpAr do
	(
		goodNorms = #()
		faceAreaSum = #()
		
		for i in faceSel  do
		(
			local minAngle
			local alreadyCollected = false
			
			faceNorm = getFaceNormal s i
			faceArea = meshop.getFaceArea s #{i}
					
			-- 	comparaison de la dernière normale collectée avec les normales deja selectionnées
			for j = 1  to goodNorms.count do
			(		
				-- formule alambiqué pour supprimer le -nan(ind).0
				minAngle = ((((acos(dot goodNorms[j] faceNorm))*100)as integer)as float)/100

				if minAngle <= angleTresh then 
				(
					faceAreaSum[j] += faceArea
					alreadyCollected = true
				)
				
				if alreadyCollected then exit
			)
			
			-- collecte d'une normale qui n'a pas déja été collecté
			if not alreadyCollected then 
			(
				append goodNorms faceNorm
				append faceAreaSum faceArea
			)
			else
			(
				
			)
		)

		-- determination des trois normales de la nouvelle fenetre
		global NZ, NX, NY
		
-- selection de la premiere normale pour déterminer l'orientation de la boite
		faceAreaSumSort = deepCopy faceAreaSum
		sort faceAreaSumSort

		local faceSumId, Ntmp
		
		for i = faceAreaSumSort.count to 1 by -1 do
		(
			
			local minAngle
			
			faceSumId = finditem faceAreaSum faceAreaSumSort[i]
			
			Ntmp = goodNorms[faceSumId]
			
			minAngle = ((((acos(dot Ntmp [0,0,1]))*100)as integer)as float)/100
-- 			format "minAngle: %\n" minAngle
			
-- 			if Ntmp == [0,0, -1] or Ntmp == [0,0,1] then continue
			if minAngle > - 1.0 and minAngle < 1.0 then continue
			if minAngle > 179.0 and minAngle < 181.0 then continue
			else exit
		)
		
-- 		format "Ntmp: % goodNorms:% \n" Ntmp goodNorms
		
		-- determination  de la normale X, on prend la normale de la face area la plus importante
-- 		NX = normalize goodNorms[finditem faceAreaSum (amax faceAreaSum)]
		NX = normalize Ntmp
		NY = normalize (cross [0,0,1] NX)
		NZ = normalize (cross NX NY)

		-- récuperer les positions des vertex et les redefinir par rapport à l'origine
		vxSel = meshop.getVertsUsingFace s faceSel
		vxPos = meshop.getVerts s vxSel -- node: pt
		-- 		format "vxpos.count: %\n" vxpos.count
			
		-- trouver le centre de la selection
		bbXmax = -1000000
		bbYmax = -1000000
		bbZmax = -1000000
		bbXmin = 1000000
		bbYmin = 1000000
		bbZmin = 1000000

		for i = 1 to  vxpos.count do
		(
			if vxpos[i].x > bbXmax then bbXmax = vxpos[i].x
			if vxpos[i].y > bbYmax then bbYmax = vxpos[i].y
			if vxpos[i].z > bbZmax then bbZmax = vxpos[i].z
				
			if vxpos[i].x < bbXmin then bbXmin = vxpos[i].x
			if vxpos[i].y < bbYmin then bbYmin = vxpos[i].y
			if vxpos[i].z < bbZmin then bbZmin = vxpos[i].z
		)

		posMax = point3 bbXmax bbYmax bbZmax
		posMin = point3 bbXmin bbYmin bbZmin
		posCenter = (posMax + posMin)/2

		-- 		pt = point name: (uniquename "pos_center_") pos: posCenter
		-- calcul du nouveau transform
		nodeMT = (matrix3 NX NY NZ  posCenter)

		-- calculer la taille du gabarit
		Xmax = -1000000
		Ymax = -1000000
		Zmax = -1000000
		Xmin = 1000000
		Ymin = 1000000
		Zmin = 1000000

		for i = 1 to vxpos.count do 
		-- for i = 1 to 10 do 
		(
			ptTM = copy nodeMT
			ptTM.translation = vxpos[i]

			vxMTRoot =  (ptTM * (inverse nodeMT))
			vxPosRoot = vxMTRoot.translation

			if vxPosRoot.x > Xmax then Xmax = vxPosRoot.x
			if vxPosRoot.y > Ymax then Ymax = vxPosRoot.y
			if vxPosRoot.z > Zmax then Zmax = vxPosRoot.z
				
			if vxPosRoot.x < Xmin then Xmin = vxPosRoot.x
			if vxPosRoot.y < Ymin then Ymin = vxPosRoot.y
			if vxPosRoot.z < Zmin then Zmin = vxPosRoot.z
		)

		Xsize = distance (point3 xmax 0 0) (point3 xmin 0 0) 
		Ysize = distance (point3 0 ymax 0) (point3 0 ymin 0) 
		Zsize = distance (point3 0 0 Zmax) (point3 0 0 zmin)  

		-- creation du gabarit
		-- tester l'existence du nom du gabarit 
		gabarit = box height: Zsize width: Xsize length: Ysize name: ( uniquename "fenetre_detach_" )
		gabarit.pivot = gabarit.center
		gabarit.transform = nodeMT
		gabarit.renderable = false
		converttomesh gabarit
		
		-- add properties
		setUserPropVal gabarit "isGabarit" true
		
		append gabaritAr gabarit
		
			groupNum += 1
-- 		
		format "gabarit % / % done, facesel: %\n" (groupNum) grpAr.count facesel
		
		
	)
	
	format "Gabarit Time: %s\n" (((timestamp()) - startGabaritTime) / 1000 as float)
	format "Total Time: %s \n " (((timestamp()) - startingTime) / 1000 as float)
	gabaritAr
)

fn createGabarits2 s =
(
	local faceSelCount = 0
	global gabaritAr = #()

	startingTime = timestamp()

	angleTresh = 1.0

	for faceSel in grpAr do
	(
		faceSelCount += 1
-- 		format "faceSelCount: %/% faceSel: %\n" faceSelCount grpAr.count faceSel
	-- collecte des normales et des array de faces pour calculer les surfaces 
		turnsCount = 0
		turnsCountTrigger = 0
		turnTime = timestamp()
		
		goodNorms = #()
		faceIDforArea = #()
		
		startCollectNormalsTime = timestamp()
		for i in faceSel  do
		(
			turnsCount += 1
		-- 	format "i:%\n" i
			local minAngle
			local alreadyCollected = false
			
			faceNorm = getFaceNormal s i
		-- 	faceArea = meshop.getFaceArea s #{i}
					
			-- 	comparaison de la dernière normale collectée avec les normales deja selectionnées
			-- à la première boucle la première normale est collectée
			for j = 1  to goodNorms.count do
			(		
				-- formule alambiqué pour supprimer le -nan(ind).0
					-- pour corriger il faut arrondir le résultat de dot à 1 ou -1 pour éviter l'erreur
				local dotRes = dot goodNorms[j] faceNorm

				if dotRes > 1.0 then  dotRes = 1.0
				else if dotRes < -1.0 then dotRes = -1.0
				else()
				
				minAngle = acos dotRes

				if minAngle <= angleTresh then 
				(
		-- 			faceAreaSum[j] += faceArea
					append faceIDforArea[j] i
					alreadyCollected = true
				)
				
				if alreadyCollected then exit
			)
			
			-- collecte d'une normale qui n'a pas déja été collecté
			if not alreadyCollected then 
			(
				append goodNorms faceNorm
		-- 		append faceAreaSum faceArea
				append faceIDforArea #(i)
			)
			else
			(
				
			)
			
			-- sécurité pour sortir de la boucle
			if turnsCount >= turnsCountTrigger then 
			(
		-- 		gc()
-- 				format "faces tested: %/% turnTime: %ms \n" turnsCount facesel.count  (((timestamp()) - turnTime) as float)
				turnTime = timestamp()
		-- 		format "turns: %\n" turnsCount
				turnsCountTrigger += 1000
			) 
			
			if turnsCount > 2000 then
			(
				format "faces tested: %/%\n" turnsCount facesel.count
				exit
			)
		)
		format "	Collect Normal and face for aera Time: %s\n" (((timestamp()) - startCollectNormalsTime) / 1000 as float)

		-- calcul des aires de faces
		startfaceAeraTime = timestamp()
		faceAreaSum = #()
		for i = 1 to faceIDforArea.count do
		(
			faceArea = meshop.getFaceArea s (faceIDforArea[i] as bitarray)
			append faceAreaSum faceArea
		)
		format "	Collect face aera Time: %s\n" (((timestamp()) - startfaceAeraTime) / 1000 as float)

		-- calcul de l'orientation de la boite
		startboxTime = timestamp()
		(
			-- determination des trois normales de la nouvelle fenetre
			global NZ, NX, NY
				
			-- selection de la premiere normale pour déterminer l'orientation de la boite
			faceAreaSumSort = deepCopy faceAreaSum
			sort faceAreaSumSort

			local faceSumId, Ntmp

			for i = faceAreaSumSort.count to 1 by -1 do
			(
		-- 		format "i: % \n" i
				local minAngle
				
				faceSumId = finditem faceAreaSum faceAreaSumSort[i]
				
				Ntmp = goodNorms[faceSumId]
			 
		-- 		for val in Ntmp do print val
		-- 		format "Ntmp: % \n" Ntmp
				local dotRes = dot Ntmp [0,0,1]
				
				if dotRes > 1.0 then  dotRes = 1.0
				else if dotRes < -1.0 then dotRes = -1.0
				else()

		-- 		format "i: % dotRes: % \n" i dotRes
				
		-- 		minAngle = ((((acos(dotRes))*100)as integer)as float)/100
				minAngle = acos dotRes
		-- 		format "minAngle: %\n" minAngle
				
			-- 			if Ntmp == [0,0, -1] or Ntmp == [0,0,1] then continue
				if minAngle > - 1.0 and minAngle < 1.0 then continue
				if minAngle > 179.0 and minAngle < 181.0 then continue
				else exit
			)
				
			-- 		format "Ntmp: % goodNorms:% \n" Ntmp goodNorms

			-- determination  de la normale X, on prend la normale de la face area la plus importante
			-- 		NX = normalize goodNorms[finditem faceAreaSum (amax faceAreaSum)]
			NX = normalize Ntmp
			NY = normalize (cross [0,0,1] NX)
			NZ = normalize (cross NX NY)															
		

		-- calcul de la taille de la boite
		
			-- récuperer les positions des vertex et les redefinir par rapport à l'origine
			vxSel = meshop.getVertsUsingFace s faceSel
			vxPos = meshop.getVerts s vxSel -- node: pt
			-- 		format "vxpos.count: %\n" vxpos.count
				
			-- trouver le centre de la selection
			bbXmax = -1000000
			bbYmax = -1000000
			bbZmax = -1000000
			bbXmin = 1000000
			bbYmin = 1000000
			bbZmin = 1000000

			for i = 1 to  vxpos.count do
			(
				if vxpos[i].x > bbXmax then bbXmax = vxpos[i].x
				if vxpos[i].y > bbYmax then bbYmax = vxpos[i].y
				if vxpos[i].z > bbZmax then bbZmax = vxpos[i].z
					
				if vxpos[i].x < bbXmin then bbXmin = vxpos[i].x
				if vxpos[i].y < bbYmin then bbYmin = vxpos[i].y
				if vxpos[i].z < bbZmin then bbZmin = vxpos[i].z
			)

			posMax = point3 bbXmax bbYmax bbZmax
			posMin = point3 bbXmin bbYmin bbZmin
			posCenter = (posMax + posMin)/2

			-- 		pt = point name: (uniquename "pos_center_") pos: posCenter
			-- calcul du nouveau transform
			
		-- 	nodeMT = matrix3 1
		-- 	nodeMT.pos = posCenter
			nodeMT = (matrix3 NX NY NZ  posCenter)

			-- calculer la taille du gabarit
			Xmax = -1000000
			Ymax = -1000000
			Zmax = -1000000
			Xmin = 1000000
			Ymin = 1000000
			Zmin = 1000000

			for i = 1 to vxpos.count do 
			-- for i = 1 to 10 do 
			(
				ptTM = copy nodeMT
				ptTM.translation = vxpos[i]

				vxMTRoot =  (ptTM * (inverse nodeMT))
				vxPosRoot = vxMTRoot.translation

				if vxPosRoot.x > Xmax then Xmax = vxPosRoot.x
				if vxPosRoot.y > Ymax then Ymax = vxPosRoot.y
				if vxPosRoot.z > Zmax then Zmax = vxPosRoot.z
					
				if vxPosRoot.x < Xmin then Xmin = vxPosRoot.x
				if vxPosRoot.y < Ymin then Ymin = vxPosRoot.y
				if vxPosRoot.z < Zmin then Zmin = vxPosRoot.z
			)

			Xsize = distance (point3 xmax 0 0) (point3 xmin 0 0) 
			Ysize = distance (point3 0 ymax 0) (point3 0 ymin 0) 
			Zsize = distance (point3 0 0 Zmax) (point3 0 0 zmin)  

			-- creation du gabarit
			-- tester l'existence du nom du gabarit 
			gabarit = box height: Zsize width: Xsize length: Ysize name: ( uniquename "fenetre_detach_" )
			gabarit.pivot = gabarit.center
			gabarit.transform = nodeMT
			gabarit.renderable = false
			converttomesh gabarit
			
			-- add properties
			setUserPropVal gabarit "isGabarit" true
			
		 	append gabaritAr gabarit
			
		-- 	groupNum += 1
		-- 		
			
		)
		format "	Box Time: %s\n" (((timestamp()) - startboxTime) / 1000 as float)
		format "gabarit % / % done, facesel: %\n" faceSelCount grpAr.count facesel
		
	)
	format "		Total Time: %s \n " (((timestamp()) - startingTime) / 1000 as float)
	gabaritAr

)

fn detachOriginMeshes s forceDelete: false = 
(
	local originMeshesAr = #()
	local id = 0
	
	startOrigineTime = timestamp()
	
	-- creation du Layer
	Lname = s.name + "_fenetre_detach_origin"
	-- Lname = "toto"
	daddyL = s.layer

	-- daddyName
	if not iskindof (layermanager.getlayerfromname Lname) MixinInterface then layermanager.newlayerfromname Lname
	L = layermanager.getlayerfromname Lname

	L.setParent daddyL
	L.current = true
	L.on = true
	
	for faceSel in grpAr do
	(
		id += 1
		-- clonage de la mesh d'origine
		local newMesh = meshop.detachFaces s facesel delete: false asMesh: true
		
		local emesh =  Editable_mesh () -- name: ("fenetre_detach_"+ (groupNum as string) + "_origin")   --create an empty Editable_mesh
		
		emesh.mesh = newMesh --assign the detached faces to the new mesh
		update emesh --update the mesh
		
		-- repostionnement de la mesh séparée dans l'orientation de la mesh d'origine
		emesh.transform = s.transform
		emesh.objectoffsetrot = s.objectoffsetrot
		emesh.objectoffsetpos = s.objectoffsetpos
		emesh.objectoffsetpos = s.objectoffsetpos
		
-- 		groupNum += 1
		
		emesh.parent = gabaritAr[id]
		emesh.wirecolor = gabaritAr[id].wirecolor
		emesh.name = gabaritAr[id].name + "_origin"
		emesh.renderable = false
		setTransformLockFlags emesh #all
		
		emesh.showFrozenInGray
-- 		freeze emesh
		
		gabaritAr[id].visibility = bezier_float()
		gabaritAr[id].visibility.controller.value = 0.5
	)
	
	if forceDelete then
	(
		local facesToDel = #{}
		for g in grpAr do facesToDel += g
			
		meshop.deleteFaces s facesToDel delIsoVerts: true
	)

	format "Detach origine Mesh Time: %s\n" (((timestamp()) - startOrigineTime) / 1000 as float)
	format "Total Time: %s \n " (((timestamp()) - startingTime) / 1000 as float)
)


