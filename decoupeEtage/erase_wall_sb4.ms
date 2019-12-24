-- sur une selection de cellule

fn createWall sel =
(
	-- faire des copies
-- 	sel = selection as array
	maxOps.cloneNodes sel cloneType: #copy newNodes: &wallSplines
	select wallSplines

	-- supprimer les modifiers 
	for w in wallSplines do
	(
		count = w.modifiers.count
		if count > 0 then 
		(
			for i = count to 1 by - 1 do deletemodifier w 1
		)
	)

	-- convertion de tout ce qui n'est pas line ou spline shape
	for w in wallSplines where classof w == rectangle do converttosplineshape w
		
	-- merger toutes les splines dans le meme objet
	-- converttosplineshape wallSplines[1] 
	for i = 2 to wallSplines.count do
	(
	-- 	converttosplineshape wallSplines[i] 
		addAndWeld wallSplines[1] wallSplines[i] 0.1
	)

	-- deselection de tous les segments
	spCount = numsplines wallSplines[1] 
	for sp = 1 to spCount do
	(
	-- 	segCount = numSegments s sp
		setSegSelection wallSplines[1]  sp #()
	)

	updateshape wallSplines[1]

	-- ajout d'un sweep
	addmodifier wallSplines[1] (sweep PivotAlignment:3 length: 250 width: 25)
	wallSplines[1].sweep.PivotAlignment = 3
	wallSplines[1].sweep.CurrentBuiltInShape = 2
	wallSplines[1].sweep[#Bar_Section].length = 250
	wallSplines[1].sweep[#Bar_Section].width = 25
	wallSplines[1].sweep.SmoothPath = off

	-- renommage
	wallSplines[1].name = uniquename "wall_" 

	wallSplines[1]
)


fn selectSegSpline s eraser = 
(
	local segToDel -- = --#()
	local collectCompleted = false
	format "### start selection\n"
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
-- 				format "to del s: %, sp:%  k:% res1: % res2: % \n"  s.name sp  k res1 res2
-- 				append segToDel #(s, sp, k)
-- 				setSegSelection s sp #(k)
				segToDel = #(s, sp, k)
				collectCompleted = true
			)
			
			if collectCompleted then exit
		)
		if collectCompleted then exit
	)
	
-- 	format "segToDel: %\n" segToDel
	format "### selection done: %\n" segToDel
-- 	if segToDel.count >= 1 then #(segToDel[1]) else segToDel
	segToDel
)


fn eraseSplineSeg2 s sp segDel =
(
	undo on
	(
		local segCount = numSegments s sp
		format "### start erasing\n"
	-- 	spCount = numsplines s
		format "s: % sp:% segDel: %\n" s sp segDel
		-- si la spline est ouverte
		if isClosed s sp then
		(
			format "closed spline: % sp: % segDel: %\n" s sp segDel
			-- mettre le segment selectionné en premier knot de la spline
			if not segDel == segCount then setFirstKnot s sp (segDel + 1)
			-- ouvrir la spline
			open s sp
			updateshape s
		)
		else
		(
			format "open spline: % sp: % segDel: %\n" s sp segDel
		-- 	if not  isClosed s sp then
		-- 	for sp = 1 to spCount do
-- 			segCount = numSegments s sp
-- 			format "segCount: %\n" segCount
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
		format "### erasing done\n"
	)	
)

try(destroydialog testPickerRLT)catch()
rollout testPickerRLT "wall destructor"
(
	local goodRes
	local snapNode
	
	button selObjBT "create wall"
-- 	edittext objectSelET
	checkbutton pickCB "destroy wall"
	
	tool testTool
	(
		on mousePoint clickno do
		(
			format "########## start click\n"
			format "clickno:%\n" clickno
			local myRay = mapScreenToWorldRay viewPoint
-- 			format "viewPoint: %\n" viewPoint
-- 			format "node: %\n" snapNode.name
			
			-- si l'objet est un editable poly
			if snapNode == undefined or clickno == 2 then(format "abandonnez la mission!\n")
			-- si l'objet est une line avec un sweep
			else if iskindof snapNode.baseobject line or iskindof snapNode.baseobject SplineShape then
			(
				-- test de l'impact de la souris sur l objet
				tmpHit = intersectRayEx snapNode myRay
-- 				format "tmpHit:%\n" tmpHit
				if tmpHit == undefined then ()
				else
				(
					-- creation de l'objet de colision
					sourceObj = sphere radius: 15 name: (uniquename "eraser")
					sourceObj.controller.pos.controller.value =  tmpHit[1].pos
					sourceObj.dir =  tmpHit[1].dir
					
					-- test de la collision
					local segtoDelAr = selectSegSpline snapNode sourceObj
					format "segtoDelAr: %\n" segtoDelAr
					
					-- suppression de l'objet de collision
					delete sourceObj
					
					-- si il y a collision suppression du segment collisionné
					if segtoDelAr == undefined then()
					else
					(
						undo on
						(
							-- ceation d'une copy pour permettre le control Z
							local copyS = copy segtoDelAr[1]
							segtoDelAr[1].layer.addnode copyS
							copyS.wirecolor = segtoDelAr[1].wirecolor
							copyS.name = segtoDelAr[1].name
							delete segtoDelAr[1]
							snapNode = copyS
							select snapNode
							
							-- suppression du segment
							eraseSplineSeg2 copyS segtoDelAr[2] segtoDelAr[3]							
						)
					)
					
				)
			)
			else(format "############## ¯\_(?)_/¯ ################")
			-- si l'objet est un mesh
			-- si l'objet est un edit poly avec un shell
		)
		
		on mouseMove clickno do(
-- 			format "######## move #######\n"
-- 			format "clickno:%\n" clickno
			)
		
		on stop do 
		(
-- 			format "######## stop #######\n"
-- 			format "clickno:%\n" clickno
		)
	)
	
	on selObjBT pressed do
	(
		sel = selection as array
		createWall sel
	)
	
	on pickCB changed state do
	(
		if state do
		(
-- 			snapMode.display = false
-- 			bakSnapDisplay = snapMode.display
-- 			bakSnapActive = snapMode.active
-- 			bakFaceSnap = snapMode.getOSnapItemActive 7 5

			-- active vertex, edge et face
-- 			snapMode.display = false
-- 			snapMode.active = true	
-- 			snapMode.setOSnapItemActive 7 5 true
-- 			max drawingaids; max drawingaids 
			sel = selection as array
			if sel.count == 1 then snapNode = sel[1]
			
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool testTool
			)
			pickCB.state = false
			
-- 			snapMode.display = bakSnapDisplay
-- 			snapMode.active = bakSnapActive		
-- 			snapMode.setOSnapItemActive 7 5 bakFaceSnap

		)
	)
)
createdialog testPickerRLT
