
fn selectSegSpline s eraser = 
(
	local segToDel = --#()
	local collectCompleted = false
	format "start erasing\n"
	-- 	spSel = getSplineSelection s
	spCount = numsplines s
	-- 	spSel = 1
	for sp = 1 to spCount do
	(
		segCount = numSegments s sp
		-- calcul du vecteur
		for k = 1 to segCount do
		(
			kk = k +1
			if isClosed s sp and k == segCount  then kk = 1

-- 			format "k1:%\n" k
-- 			format "kk:%\n" kk
	
			k1 = getKnotPoint s sp k
			k2 = getKnotPoint s sp kk
-- 			format "s: %, sp:%  k:% k1:% k2:%\n" s.name sp  k k1 k2
			v1 = normalize (k2-k1)
			v2 = normalize (k1-k2)

			ray1 = ray k1 v1
			ray2 = ray k2 v2
			
			res1 = intersectRay eraser ray1
			res2 = intersectRay eraser ray2
			
			
			if not res1 == undefined and not res2 == undefined then
			(
-- 				format "res1: % res2: % \n" res1 res2
-- 				format "delete s: % sp:% k:%\n" s.name sp k
				format "to del s: %, sp:%  k:% res1: % res2: % \n"  s.name sp  k res1 res2
-- 				append segToDel #(s, sp, k)
-- 				setSegSelection s sp #(k)
				segToDel = #(s, sp, k)
				collectCompleted = true
			)
			
			if collectCompleted then exit
		)
		if collectCompleted then exit
	)
	
	format "segToDel: %\n" segToDel
	format "selection done\n"
-- 	if segToDel.count >= 1 then #(segToDel[1]) else segToDel
	segToDel
)


fn eraseSplineSeg2 s sp segDel =
(
	undo on
	(
		local segCount = numSegments s sp
		format "start erasing 2\n"
	-- 	spCount = numsplines s
		format "s: % sp:% segDel: %\n" s sp segDel
		-- si la spline est ouverte
		if isClosed s sp then
		(
			-- mettre le segment selectionné en premier knot de la spline
			if not segDel == segCount then setFirstKnot s sp (segDel + 1)
			-- ouvrir la spline
			open s sp
			updateshape s
		)
		else
		(
		-- 	if not  isClosed s sp then
		-- 	for sp = 1 to spCount do
-- 			segCount = numSegments s sp
			format "segCount: %\n" segCount
			newSpline1 = #()
			newSpline2 = #()
			
			-- collecter les coordonnées des knot avant le seg supprimé
-- 			format "newSpline1: \n" 
			for k = 1 to segDel do
			(
-- 				format "k: %\n" k
				append  newSpline1 (getKnotPoint s sp k)
			)
			
-- 			format "newSpline2: \n" 
			-- collecter les coordonnées des knot aprés le seg supprimé
			for k = (segDel + 1) to (segCount + 1) do
			(
-- 				format "k: %\n" k
				append  newSpline2 (getKnotPoint s sp k)
			)
			
-- 			format "newSpline1: %\n" newSpline1
-- 			format "newSpline2: %\n" newSpline2
			
					-- recréer la spline avant le segment supprimé
			if newSpline1.count > 1 then
			(
				newSp = addNewSpline s
				for nk in newSpline1 do
				(
					addKnot s newSp #corner #line nk
				)
			)
			
		-- recréer la spline aprés le segment supprimé
			if newSpline2.count > 1 then
			(
				newSp = addNewSpline s
				for nk in newSpline2 do
				(
					addKnot s newSp #corner #line nk
				)
			)
			
			deleteSpline s sp
			updateshape s
		)
	)	
)

try(destroydialog testPickerRLT)catch()
rollout testPickerRLT "wall destructor"
(
	local goodRes
	local snapNode
	
	button selObjBT "select object"
	edittext objectSelET
	checkbutton pickCB "pick"
	
	
	tool testTool
	(
		on mousePoint clickno do
		(
			format "########## start click\n"
			
			local myRay = mapScreenToWorldRay viewPoint
-- 			format "clickno:%\n" clickno
-- 			format "viewPoint: %\n" viewPoint
-- 			format "node: %\n" snapMode.node.name
			
			-- si l'objet est un editable poly
			if snapMode.node == undefined then()
			else if iskindof snapMode.node.baseobject editable_poly then
			(
							
				-- Selectionner une face
				selVx = #()
				polyFaceAr = #()
				
				-- ajouter un editmesh sur l'objet
				em = (Edit_Mesh ())
				addmodifier snapMode.node  em
				
				-- retourner la face de l'edit mesh selectionné
				if isvalidnode snapMode.node then
				(
					tmpHit = intersectRayEx snapMode.node myRay
					if tmpHit != undefined then
					(
						format "face id: %\n" tmpHit[2]
						-- recuperer les trois vertex de la face
						selVx = meshop.getVertsUsingFace snapMode.node tmpHit[2]
						format "vx: %\n" selVx
					)
				)
				deletemodifier snapMode.node  em
				
				-- dans le poly retourner les faces avec les trois vertex
				for id in selVx do
				(
					polyFace = polyop.getFacesUsingVert snapMode.node # {id}
	-- 				format "polyFace: %\n" polyFace
					append polyFaceAr polyFace
				)
				
				-- recouper les bitarray			
				for  p in polyFaceAr do polyFaceAr[1] *= p
				faceSel = (polyFaceAr[1] as array)[1]
				format "faceSel: %\n" faceSel
			)
			-- si l'objet est une line avec un sweep
			else if iskindof snapMode.node.baseobject line or iskindof snapMode.node.baseobject SplineShape then
			(
				tmpHit = intersectRayEx snapMode.node myRay
-- 				format "tmpHit:%\n" tmpHit
				if not tmpHit == undefined then
				(
					sourceObj = sphere radius: 15 name: (uniquename "eraser")
					sourceObj.controller.pos.controller.value =  tmpHit[1].pos
					sourceObj.dir =  tmpHit[1].dir
					
-- 					eraseSplineSeg snapMode.node sourceObj
					
					local segtoDelAr = selectSegSpline snapMode.node sourceObj
					
-- 					for one in segtoDelAr do
					(
						format "segtoDelAr: %\n" segtoDelAr
						undo on
						(
							local copyS = copy segtoDelAr[1]
							copyS.wirecolor = segtoDelAr[1].wirecolor
							copyS.name = segtoDelAr[1].name
							delete segtoDelAr[1]
							eraseSplineSeg2 copyS segtoDelAr[2] segtoDelAr[3]
						)
-- 						eraseSplineSeg2 one[1] one[2] one[3]
					)
					delete sourceObj
				)
			)
			-- si l'objet est un mesh
			-- si l'objet est un edit poly avec un shell
		)
		
		on mouseMove clickno do(
-- 			format "######## move #######\n"
			)
		
		on stop do 
		(
			format "######## stop #######\n"
		)
	)
	
	on pickCB changed state do
	(
		if state do
		(
-- 			snapMode.display = false
			bakSnapDisplay = snapMode.display
			bakSnapActive = snapMode.active
			bakFaceSnap = snapMode.getOSnapItemActive 7 5

			-- active vertex, edge et face
			snapMode.display = false
			snapMode.active = true	
			snapMode.setOSnapItemActive 7 5 true
			max drawingaids; max drawingaids 
			
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool testTool
			)
			pickCB.state = false
			
			snapMode.display = bakSnapDisplay
			snapMode.active = bakSnapActive		
			snapMode.setOSnapItemActive 7 5 bakFaceSnap

		)
	)
)
createdialog testPickerRLT
