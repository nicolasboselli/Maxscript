/*
memo session concours empalot:



reflexion sur l'outil:
l'outil pourrait etre un picker au pick on designe la direction en x et l'element � transformer
- nescessite une fonction pour selectionner tout un element � partir d'une FaceSelection
- nescessite un outil pour donner une face au pickage

1. determiner l'orientation du gabarit
	x 1.1 deter de la normale x en fonction de la taille des faces
	x debug: quand le debord de fenetre est dans l'objet, il y a trop de normale collecter
2. determiner la taille du gabarit
	x 2.1 convertir la selection de faces en Vertex
	x 2.2 collecter les positions de tous les vertex dans la matrice du futur gabarit
	x 2.3 garder les valeurs maximales 
3. x fonctions pour changer l'orientation du gabarit � la vol�e
3.5 x fonction pour distinguer des groupes de face en fonction de la distance
4. x distinguer plusieurs elements dans une selection de face en fonction de la distance

5. x cr�er un calque GABARITS pour mettre toute les fenetres d�tachees dedans
6. x faire focntionner le parallax placer sur les gabarits

8. x Ajouter un user properties GABARIT sur les gabarits, s'appuyer sur le nom des objets plutot
9.x corriger l'orientation des gabarit et recalculant sur le gabarit la plus grande surface pour r�orient� en x
10. x refaire un wirecolor by orientation sur l'ensemble des gabarits. r�cup�r�s dans la scne par nom d'objet

101. x rendre les gabarits non rendable
102. ajouter les fonction de wirecolor par taille

11. x une fonction qui oriente les gabarits par rapport � un helper.
	x le helper est cr�� au premier emploi
	
12. x une fonction rapide pour transformer une selection des fenetres en fenetres
	x utiliser le script objetc replacer par script

13. x detacher la mesh de la fenetre selectionn�e, 
	x au changement de fenetre (quick replacer) seelctionner la mesh de fenetre ave le gabarit pour une suppression plus facile(freeze de la fenetre)
	x retester le freeze de la fenetre en plus du Lock
	x placer les origines dans un calque diff�rents
	/restreindre le fix 180 aux gabarits
	x au fix 180 deparenter les fenetre avant de faire la rotation
	faire des sous calques en focntion de la taille des gabarits(revoir la fonction de color by size)
	
14. x au replace placer le gabarit dans un sous calque: ajouter une option replace dans le calque active
	x decrash pour donner de l'�paisseur au boite plate, changer la m�thode pour augmenter la taille des boites, tenir compte de la taille de la boite

15. debug des mesh origin
	- ne pas faire un colorbyorient systematique apr�s un resize gabarit ou un reorient?la couleur de la mesh origine ne suit pas
	- au wirecolor by size, appliquer la couleur sur la fenetre origine tout en ignorant la fenetre origine. et appliquer la couleur � la fenetre origine
	- quand on fait une rotation du pivot � 90� la mesh fenetre origine tourne aussi 
	- freeze des fenetres origine? ou du calque

16. decrash du acos(-1.0) = error avec condition if dot value < -1.0 then dot value == -1

17. wirebyorient : utiliser les valeur de la normale multiplier par 255 pour obtenir une couleur

21. mettre en banque des fenetres sans appuis de fenetres

20. faire les gabarit en creant vertex et poly dans edit mesh

31. faire fonctionner la focnction classique de parallax placer
32. faire converger la m�thode de creation des box avec le boxerize v1
33. faire un quick replacer qui fonctionne sur la selection de face d'edit mesh

88. optimiser le code pour acc�l�rer l'op�ration

404. TOOLS
x-- flipper l'axe x
x- r�fl�chir � un outil qui mettent les normales d'une selection d'objet dans le sens de la majorit�
x- r�fl�chier � un outil qui fasse ressortir les normales invers�e
x conformer l'�paisseur des gabarit

debug:
x- voir pourquoi � la cr�ation des gabarits, le script comme les boites deux fois
- revoir la table des wirecolor en fonction de l'orientation, mettre plus de couleure pour ne pas tomber en rade
	- editer le treshold pour comparer les orientations
- decrasher le script sur les edit Poly
- decrasher le script sans selection de sous objets
- decrasher le reorientGabarits sur une selection 
- decrasher le quick replacer
*/

fn createLayer s = 
(
	-- cr�ation du layer de base la fen�tre
	Lbase = s.name + "_base"
	daddyL = s.layer
	
	if not iskindof (layermanager.getlayerfromname Lbase) MixinInterface then layermanager.newlayerfromname Lbase
	LB = layermanager.getlayerfromname Lbase
	
	LB.setParent daddyL
	
	-- placement de la selection dans le layer fen�tre
	LB.addnode s 
	
	-- creation du layer pour les gabarits
	Lname = s.name + "_fenetre_detach"

	if not iskindof (layermanager.getlayerfromname Lname) MixinInterface then layermanager.newlayerfromname Lname
	L = layermanager.getlayerfromname Lname

	L.setParent LB

	-- creation du layer pour les nouvelle fen�tres
	LNname = s.name + "_fenetre_nouvelles"
	
	if not iskindof (layermanager.getlayerfromname LNname) MixinInterface then layermanager.newlayerfromname LNname
	LN = layermanager.getlayerfromname LNname
	
	LN.setParent LB
	
	L.current = true
	L.on = true
)

fn wirecolorByOrientation sel = 
(
	/*utiliser les valeur de la normale multiplier par 255 pour obtenir une couleur*/
	
	colors = #(red, green, blue, yellow, brown, orange, \
		(color 225 88 199), (color 88 177 27), (color 141 7 58), (color 87 225 198),\
		(color 27 177 27),(color 225 88 199), (color 28 149 177), (color 224 86 86),
		(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),
		(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),
		(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),
		(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),
		(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),
		(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),
		(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),
		(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8),(color 135 59 8))

	normalsCollected = #()

	for s in sel do
	(
-- 		format "start s: %\n" s.name
		colorid = undefined
		alreadycollectd = false
		
		if normalsCollected.count == 0 then
		(
			append normalsCollected s.transform.row1
			s.wirecolor = colors[normalsCollected.count]
			continue
		)
		
		for i = 1 to normalsCollected.count do
		(
			test = minAngle = ((((acos(dot s.transform.row1 normalsCollected[i]))*100)as integer)as float)/100
			if test <= 5 then 
			(
				
				alreadycollectd = true
				colorid = i
-- 				format "alreadycollectd: % corlorid: %\n" alreadycollectd i
			)
		)
		
		if alreadycollectd then
		(
			s.wirecolor = colors[colorid]
		)
		else
		(
			append normalsCollected s.transform.row1
			s.wirecolor = colors[normalsCollected.count]
-- 			format "s: % newColorId: % \n" s.name normalsCollected.count
		)
		
-- 		format "done s: %\n" s.name
		

		
	)
	format "wirecolor by orientation done \n" 
	
	for s in sel do
	(
		-- mettre la bonne couleur sur l'origine
		local testOrigin = getNodeByName (s.name + "_origin")
-- 		format "s.name: % testOrigin: %\n" s.name testOrigin
		
		if isValidNode testOrigin then 
		(
			
			testOrigin.wirecolor = s.wirecolor
		)
	)
	
	format "wirecolor origine meshes done \n" 	
)

fn flipX s =
(
	s.transform = prerotate s.transform (EulerAngles 0 0 90)
	s.objectOffsetRot *= (EulerAngles 0 0 -90)
)

fn resizeGabarit s size: 35 =
(
	converttomesh s
	vertsCount = meshop.getNumVerts s
	vertsList = (for i = 1 to vertsCount collect i)as bitarray

	-- calcul du decalage
	xmax = -1000
	xmin = 1000
	for v in vertsList do
	(
		oneVMat = copy s.transform
		oneVMat.translation = meshop.getVert s v 
		localPos = (oneVMat * inverse s.transform)
		if localPos.translation.x < xmin then xmin = localPos.translation.x
		if localPos.translation.x > xmax then xmax = localPos.translation.x
	)
	res35 = distance (point3 xmax 0 0) (point3 xmin 0 0)
	shift = res35 - size
	
	-- deplacement les vertex negatif
	for v in vertsList do
	(
		oneVMat = copy s.transform
		oneVMat.translation = meshop.getVert s v 
		localPos = (oneVMat * inverse s.transform)
		if localPos.translation.x <(xmax - 1) then 
		(
			localPos.translation.x = localPos.translation.x + shift
			newPos = localPos * s.transform
			meshop.setVert s v newPos.translation
		)
	)
	redrawViews()
)

fn resizeGabarit2 s size: 35 =
(
	convertToMesh s
	facesCount = meshop.getNumfaces s
	refNormal= s.transform.row1
	goodBitAr = #{}
	for i = 1 to facesCount do
	(
		oneNormal = meshop.getFaceRNormals s i
-- 		format "refNormal: %  oneNormal: %\n" refNormal oneNormal[1]
		local testAngle
		
		if (meshop.getFaceArea s i) < 1 then
		(
-- 			format "i: % s.facearea: %\n"  i (meshop.getFaceArea s i)
			testAngle = 0
		)
		else if ((dot oneNormal[1] refNormal) < -1.0) then
		(
-- 			format "i: % dot oneNormal[1] refNormal = %\n" i (dot oneNormal[1] refNormal)
			testAngle = 180.0
-- 			format "testAngle: %\n" testAngle
		)
		else
		(
			testAngle = ((((acos(dot oneNormal[1] refNormal))*100)as integer)as float)/100
-- 			format "i: % testAngle: %\n" i testAngle
		)
	 		
	 	
		if testAngle > 179 and testAngle < 181 then append goodBitAr i
-- 		format "goodBitAr: %\n" goodBitAr
	)
	
	vxBitAr = meshop.getVertsUsingFace  s goodBitAr
-- 	format "vxBitAr: % \n" vxBitAr 
			
	-- calcul du decalage � appliquer
	vertsCount = meshop.getNumVerts s
	vertsList = (for i = 1 to vertsCount collect i)as bitarray

	xmax = -1000
	xmin = 1000
-- 	size = 35
	for v in vertsList do
	(
		oneVMat = copy s.transform
		oneVMat.translation = meshop.getVert s v 
		localPos = (oneVMat * inverse s.transform)
		if localPos.translation.x < xmin then xmin = localPos.translation.x
		if localPos.translation.x > xmax then xmax = localPos.translation.x
	)
-- 	format "xmax: % xmin: %\n" xmax xmin 
	res35 = distance (point3 xmax 0 0) (point3 xmin 0 0)
	shift = res35 - size
	
-- 	format "vxBitAr: % shift: %\n" vxBitAr shift
	
-- 	move s.faces[goodBitAr]  [5,0,0]
	
	for v in vxBitAr do
	(
		
		oneVMat = copy s.transform
		oneVMat.translation = meshop.getVert s v 
		localPos = (oneVMat * inverse s.transform)

		localPos.translation.x = localPos.translation.x + shift
		newPos = localPos * s.transform
		meshop.setVert s v newPos.translation
		
-- 		format "v:% newPos.translation: %\n" v newPos.translation
	)
	redrawViews()
)	


fn reorientGabarits sel = 
(
	masterSel = sel[1]
	imax =  sel.count
	local turn = 0
	for s in sel do
	(
		turn +=1
		if turn == 1 then continue
			
		shiftRot = 0.0
		shiftAngle = ((((acos(dot masterSel.transform.row1 s.transform.row1))*100)as integer)as float)/100
		
		if shiftAngle > - 5.0 and shiftAngle < 5.0 then shiftRot = 0.0
		else if shiftAngle > 85.0 and shiftAngle < 95.0 then shiftRot = -90.0
		else if shiftAngle > -95.0 and shiftAngle < -85.0 then shiftRot = 90.0
		else if shiftAngle > 175.0 and shiftAngle < 195.0 then shiftRot = 180.0
		else shiftRot = 0.0
		
		if not shiftRot == 0.0 then  
		(
			s.transform = prerotate s.transform (EulerAngles 0 0 shiftRot)
			s.objectOffsetRot *= (EulerAngles 0 0 shiftRot)
-- 			format "sel[i]: % shiftAngle: % shiftRot: %\n" s.name shiftAngle shiftRot
		)
		
		postAngle = ((((acos(dot masterSel.transform.row1 s.transform.row1))*100)as integer)as float)/100
-- 		format "postAngle: % s: %\n" postAngle s.name
		if postAngle > 5.0 or postAngle < - 5.0 then
		(	
			format "second turn for %\n" s.name
			append sel s
			imax =  sel.count
		)
	)
	
	format "reorient done\n"
)	

-- cale l'orientation de l'objet sur la normale de la plus grande face
fn fix90Normal s =
(
	local facesNum = getnumfaces s 

	local angleTresh = 5.0
	local goodNorms = #()
	local faceAreaSum = #()
			
	for i = 1 to facesNum do
	(
		
		local minAngle
		local alreadyCollected = false
		
		faceNorm = getFaceNormal s i
		faceArea = meshop.getFaceArea s #{i}
		
					-- 	comparaison de la derni�re normale collect�e avec les normales deja selectionn�es
		for j = 1  to goodNorms.count do
		(		
			-- formule alambiqu� pour supprimer le -nan(ind).0
			minAngle = ((((acos(dot goodNorms[j] faceNorm))*100)as integer)as float)/100

			if minAngle <= angleTresh then 
			(
				faceAreaSum[j] += faceArea
				alreadyCollected = true
			)
			
			if alreadyCollected then exit
		)
		
		if not alreadyCollected then 
		(
			append goodNorms faceNorm
			append faceAreaSum faceArea
		)
		else
		(
			
		)
		
	)
	
	local NX = normalize goodNorms[finditem faceAreaSum (amax faceAreaSum)]

	local testAngle = ((((acos(dot NX s.transform.row1))*100)as integer)as float)/100
-- 	format "OK s: % testAngle: % \n" s.name  testAngle
	
	if  testAngle > 85.0 and testAngle < 95.0 then  
	(
		shiftRot = 90.0
		s.transform = prerotate s.transform (EulerAngles 0 0 shiftRot)
		s.objectOffsetRot *= (EulerAngles 0 0 shiftRot)
-- 		format "s: % shiftAngle: % shiftRot: %\n" s.name shiftAngle shiftRot
-- 		format "Fixed s: % testAngle: % \n" s.name  testAngle
	)
	format "fix 90 done\n"
)

fn fix180normalOnPoint sel =  
(
	global ptfdc
	local centerSum = point3 0 0 0

	for s in sel do centerSum += s.center

	if not isvalidnode ptfdc do ptfdc = point pos: (centerSum /= sel.count) name: "fenetre_detach_center" size: 200

	negSel = #()

	for s in sel do
	(

		-- ignorer les fenetre d'origines
		if MatchPattern s.name pattern: "fenetre_detach*origin" then continue
			
		-- ignorer tout ce qui n'est ps fenetre detach
-- 		if not MatchPattern s.name pattern: "fenetre_detach*" then continue
			
		centerPos = in coordsys s ptfdc.position
-- 		format "centerPos: %\n" centerPos
		
		if centerPos.x > 0 then ()
		else if centerPos.x < 0 then append negSel s

		-- 	point pos: (point3 centerPos.x 0 0) name: (s.name + "_Xpos")
	)

	-- select negSel

	shiftRot = 180.0
	for s in negSel do
	(
		-- collecter les enfants
		local childsAr = for c in s.children collect c
			
		-- deparent des enfants
		for c in childsAr do c.parent = undefined
		
		s.transform = prerotate s.transform (EulerAngles 0 0 shiftRot)
		s.objectOffsetRot *= (EulerAngles 0 0 shiftRot)
		
		-- reparent enfants
		for c in childsAr do c.parent = s
	)
	format "fix 180 done\n"
)

fn forceParallax w =
(
	local onePlane

	-- recup�rer les objets qui le compase
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

	-- d�finir la taille de la fenetre 
	xSize = distance (point3 xmin 0 0) (point3  xmax 0 0)
	ySize = distance (point3 0 ymin 0) (point3  0 ymax 0)
	zSize = distance (point3 0 0 zmin) (point3  0 0 zmax)

	shift = 50
	shift2 = 75
	oneplane = plane width: (ySize + shift2) length: (zSize + shift) widthsegs: 1 lengthsegs:1 transform: w.transform name: (uniqueName "ParallaxPlane_")
	oneplane.position = w.center
	oneplane.scale = [1,1,1]
	
	-- ajouter un random material
	-- exclure les ids 7 et 9
 -- exclure 7 et 9
-- 	randID = random 1 15
-- 	if randID == 7 or randID == 9 then randID = random 1 15
	randID = random 1 35
	
	addmodifier oneplane (Materialmodifier materialID: randID)
		
	addmodifier oneplane (uvwmap length: 300 width: 600)
	
	-- d�calage de la plane
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

filein "boxerize_archviz_autogroup_sb.ms"

try(destroydialog changeArchVizWindowsRLT)catch()
rollout changeArchVizWindowsRLT "Boxerize Archviz Windows"
(	
	
	global tresh = 1.0
	global groupNum = 1
	
-- 	button createGabBT "Create Gabarit on Selection" -- across: 2
	button autoGabaritBT "Auto Create Gabarits" -- across: 2
	checkbox detachMeshCB "Detach Origin Mesh" checked: true
	checkbox deleteMeshCB "Delete Origin Mesh" checked: false
	
	group "Fixing orientation:"
	(
		button wirecolorByOrientationBT "Wirecolor by Orientation"
		button flipXaxisBT "Rotate Zaxis +90"
		button reorientGabBT "Reorient Gabarit on selection" enabled: false
		button fix90normalBT "Fix 90 normal" enabled: false
		button fix180normalBT "Fix 180 normal" 
		button selectFDCBT "select fenetre_detach_center"
	)
	
	group "Gabarits Size:"
	(
		spinner resizeGabSP "Gabarit Size:" type: #worldunits range: [0,100,35]
		button resizeGabBT "Resize Gabarit"
	)
	
	group "Gabartis Tools:"
	(
		
		button forceParallaxBT "Force Parallax"
		button quickReplaceBT "Quick Replace"
	)

	-- 
	fn collectFenDetachOnly =
	(
		local FDAr = #()
		local testGab = $fenetre_detach* as array
		for o in testGab do
		(
			if MatchPattern o.name pattern: "fenetre_detach*origin" then continue
			if MatchPattern o.name pattern: "fenetre_detach_center" then continue
			else append FDAr o
		)
		FDAr
	)
	
	-- Actions
	on changeArchVizWindowsRLT open do
	(
		filein "boxerize_archviz_autogroup_sb.ms"
	)
	
	on autoGabaritBT pressed do
	(
		s = $
		
		if iskindof s Editable_mesh then
		(
			faceBitAr = getFaceSelection s
			if not faceBitAr.isempty then
			(
				createLayer s
				
				collectWindowsGroup s
				local newGab = createGabarits s -- forceClone: detachMeshCB.checked forceDelete: deleteMeshCB.checked
				for g in newGab do fix90Normal g
				fix180normalonPoint newGab
				wirecolorByOrientation newGab
				
				if detachMeshCB.checked then
				(
					detachOriginMeshes s forceDelete: deleteMeshCB.checked
				)	
			)
			else (format "s�lectionnez un sous element\n")
		)
		else(format "convertissez l'objet en editable_mesh\n")
		
		LNname = s.name + "_fenetre_nouvelles"
		LN = layermanager.getlayerfromname LNname
		
		LN.current = true
		LN.on = true
		
	)
	
	on wirecolorByOrientationBT pressed do
	(
		allGab = collectFenDetachOnly()
		wirecolorByOrientation allGab
	)
	
	on flipXaxisBT pressed do
	(
		sel = selection as Array
		for s in sel do flipX s
	)
	
	on reorientGabBT pressed do
	(
		sel = selection as Array
		undo on
		(
			reorientGabarits sel
		)
-- 		reorientGabarits sel
-- 		wirecolorByOrientation sel
		allGab = $fenetre_detach* as array
		wirecolorByOrientation allGab
	)
	
	on fix90normalBT pressed do
	(
		sel = selection as Array
		for s in sel do fix90Normal s
			
		allGab = collectFenDetachOnly()
		wirecolorByOrientation allGab
	)
	
	on fix180normalBT pressed do
	(
		sel = selection as Array
		fix180normalonPoint sel
		
		allGab = collectFenDetachOnly()
		wirecolorByOrientation allGab
	)
	
	on resizeGabBT pressed do
	(
		sel = selection as Array
		if sel.count > 0 then 
		(
			for s in sel where iskindof s Editable_mesh do
			(
				if MatchPattern s.name pattern: "fenetre_detach*origin" then continue
				else if MatchPattern s.name pattern: "fenetre_detach*" then resizeGabarit2 s size: resizeGabSP.value
				else(format "ne fonctionne pas.\n")
			)
			
			allGab = collectFenDetachOnly()
			wirecolorByOrientation allGab
		)
		else(format "ne fonctionne pas, faites un e selection.\n")
	)
	
	on selectFDCBT pressed do
	(
		ptfdc = getNodeByName "fenetre_detach_center"
		if isvalidnode ptfdc then select ptfdc
		else format "no \"fenetre_detach_center\"\n"
	)
	
	on forceParallaxBT pressed do
	(
		global wpLib
		global wPRoomsMat
		
		local pLname = "WPARALLAX_planes"
		local pL
		local wpMatPath = @"M:\Biblio\VISIOLAB\3-Materials\VISIOLAB_MATLIB.mat"
			
		-- creation du layer
		if not iskindof (layermanager.getlayerfromname pLname) MixinInterface then layermanager.newlayerfromname pLname
		pL = layermanager.getlayerfromname  pLname

	
		-- chargement du material
		if not iskindof wpLib MaterialLibrary then wpLib = loadTempMaterialLibrary wpMatPath
		wPRoomsMat = wpLib["PARALLAX__TOUT_JOUR"]
		
		
		sel = selection as Array
		for s in sel do
		(
			oneplane = forceParallax s
			oneplane.wirecolor = yellow
			
			pL.addnode oneplane
			oneplane.material = wPRoomsMat
		)
	)
	
	on quickReplaceBT pressed do
	(
		-- chargement du script rendu non visible
		global objReplacerRLT
		try(objReplacerRLT.inDialog)catch(filein (getRoot() + @"objReplacer/003/obj_replacer.ms"))
		if objReplacerRLT.inDialog then objReplacerRLT.visible = false

		-- utilisation du script
		sel = selection as array

		-- selection de la fenetre � dupliquer
		objReplacerRLT.addSelBT.pressed()

		-- reselection des gabarits � remplacer
		selClean = checkReference2 sel
		sel2 = for i = 2 to selClean.count collect selClean[i]
		select sel2

		--application du script
		objReplacerRLT.replaceV2BT.pressed()
	)
)
CreateDialog changeArchVizWindowsRLT 

-- iskindof $ Editable_mesh 