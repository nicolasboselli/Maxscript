/*
reflexion sur l'outil:
l'outil pourrait etre un picker au pick on designe la direction en x et l'element à transformer
- nescessite une fonction pour selectionner tout un element à partir d'une FaceSelection
- nescessite un outil pour donner une face au pickage

1. determiner l'orientation du gabarit
	x 1.1 deter de la normale x en fonction de la taille des faces
	x debug: quand le debord de fenetre est dans l'objet, il y a trop de normale collecter
2. determiner la taille du gabarit
	x 2.1 convertir la selection de faces en Vertex
	x 2.2 collecter les positions de tous les vertex dans la matrice du futur gabarit
	x 2.3 garder les valeurs maximales 
3. fonctions pour changer l'orientation du gabarit à la volée
4. selectionner un element à partir d'une Face
5. distinguer plusieurs elements dans une seelction de face

*/


fn flipX s =
(
	s.transform = prerotate s.transform (EulerAngles 0 0 180)
	s.objectOffsetRot *= (EulerAngles 0 0 -180)
)

try(destroydialog changeArchVizWindowsRLT)catch()
rollout changeArchVizWindowsRLT "Boxerize Archviz Windows"
(
	button createGabBT "Create Gabarit" -- across: 2
	button flipXaxisBT "Flip X axis"
	
	on createGabBT pressed do
	(
				
		s = $
		faceSel = getFaceSelection s
		(faceSel as array).count

		goodNorms = #()
		faceAreaSum = #()

		tresh = 1.0


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

				if minAngle <= tresh then 
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

		-- determination  de la normale X, on prend la normale de la face area la plus importante
		NX = normalize goodNorms[finditem faceAreaSum (amax faceAreaSum)]
		NY = normalize (cross [0,0,1] NX)
		NZ = normalize (cross NX NY)

		-- récuperer les positions des vertex et les redefinir par rapport à l'origine
		-- meshop.getVerts
		faceSel = getFaceSelection s
		vxSel = meshop.getVertsUsingFace s faceSel
		vxPos = meshop.getVerts s vxSel -- node: pt
		format "vxpos.count: %\n" vxpos.count
			
		-- trouver le centre de la selection
		bbXmax = -10000
		bbYmax = -10000
		bbZmax = -10000
		bbXmin = 10000
		bbYmin = 10000
		bbZmin = 10000

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


		-- calcul du nouveau transform
		nodeMT = (matrix3 NX NY NZ  posCenter)

		-- calculer la taille du gabarit
		Xmax = -10000
		Ymax = -10000
		Zmax = -10000
		Xmin = 10000
		Ymin = 10000
		Zmin = 10000


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
		gabarit = box height: Zsize width: Xsize length: Ysize name: (uniquename "fenetre_detach_")
		gabarit.pivot = gabarit.center
		gabarit.transform = nodeMT
		converttopoly gabarit

	)
	
	on flipXaxisBT pressed do
	(
		sel = selection as Array
		for s in sel do flipX s
	)
	
)
CreateDialog changeArchVizWindowsRLT 

	