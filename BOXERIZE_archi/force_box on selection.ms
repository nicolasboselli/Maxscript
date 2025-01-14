
-- collectWindowsGroup $
-- grpAr

s = $
faceselBitAr = getFaceSelection s
facesel = faceselBitAr as array
-- meshop.getFaceSelection s

-- gabaritAr = #(facesel)
turnsCount = 0
turnsCountTrigger = 0
turnTime = timestamp()

startingTime = timestamp()

angleTresh = 1.0
-- groupNum = 0
goodNorms = #()

faceIDforArea = #()


-- collecte des normales et des array de faces pour calculer les surfaces 
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
		format "faces tested: %/% turnTime: %ms \n" turnsCount facesel.count  (((timestamp()) - turnTime) as float)
		turnTime = timestamp()
-- 		format "turns: %\n" turnsCount
		turnsCountTrigger += 1000
	) 
	
	if turnsCount > 100000 then
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
)

-- calcul de la taille de la boite
(
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
	
-- 	append gabaritAr gabarit
	
-- 	groupNum += 1
-- 		
-- 	format "gabarit % / % done, facesel: %\n" (groupNum) grpAr.count facesel
)

format "	Box Time: %s\n" (((timestamp()) - startboxTime) / 1000 as float)
format "		Total Time: %s \n " (((timestamp()) - startingTime) / 1000 as float)
-- gabaritAr

