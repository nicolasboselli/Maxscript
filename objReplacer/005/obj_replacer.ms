/*
-- maj:
	x- freezer les axe de scale
		-- aligner sur le fond de la box
	-- faire fonctionner sur une selection d'objet en respectant la hierarchie
	
	-- faire une version de l'interface mini
	
	x- proposer de travailler sur l'original ou la copie
	
	x- proposer l alignement pivot>pivot ou pivot>centre ou centre/pivot:
	-- proposer aligner sur x y z
	-- proposer un remap x sur x y ou z puis y sur x y ou z
	
	/- ajouter un picker
	
	--  replace sur bounding box:
		-- revoir le systeme pour ne plus avoir a creer de groupe dans le processus
		-- ne plus se caler sur le pivot ou le centre des selection  mais recalculer le placement du pivot de la copy dans la bounding
		-- faire evoluer la methode replace on boundingbox en rescale on bounding box
		
-- bug:
	-- l'asset panneau solaire ne supporte pas le replac et je ne sais pas pourquoi
*/

filein "objReplacerDef2.ms"

try(destroydialog objReplacerRLT)catch()
rollout objReplacerRLT "objects replacer "
(
	local params = #("pos","rescaleXCB", "rescaleYCB", "rescaleZCB", "randomCB", "cloneTypeRB", "alignTypeTB", "layerRB", "workOnRB","oneSelCB")
	--vars
	local modFFD
	local refObj = undefined
	local targetArr = undefined
	-- function
	local RLTvers = getScriptVersion (getThisScriptFilename())
		
	global refAr
	local sourceObj
	local mergedNodes = #()	
	
	tool placeObjTool
	(
		on mousePoint clickno do
		(
-- 			format "############################### clickno1: %\n"  clickno
			
			local myRay = mapScreenToWorldRay viewPoint
			local arr = intersectRayScene myRay
			
			local viewMatrix =  Inverse(viewport.getTM())
			local viewPos = viewMatrix.pos
			local nearestDist = 1000000
			local goodRes = undefined
			
			if arr.count>0 do	
			(				
				for obj in arr do
				(
					local res = finditem mergedNodes obj[1]
-- 					local res = 0

					if obj[1] != sourceObj  and  obj[1].ishidden == false and res == 0 do
					(
					
						tmpDist = distance viewPos obj[2].pos
						
						if tmpDist < nearestDist do
						(
-- 							format "mn: %\n" mn.name
							nearestDist = tmpDist
							goodRes = obj
-- 							format "obj: %\n" obj
						)
					)
				)
			)			
			
			if goodRes != undefined do
			(
				sourceObj.controller.pos.controller.value =  goodRes[2].pos
				sourceObj.dir =  goodRes[2].dir
			)
		)

		on mouseMove clickno do
		(
-- 			format "############################ clickno2: %\n"  clickno
			if lButton == true do
			(
				local myRay = mapScreenToWorldRay viewPoint

				local arr = intersectRayScene myRay
-- 				format "arr: %\n" arr
				
				local viewMatrix =  Inverse(viewport.getTM())
				local viewPos = viewMatrix.pos
				local nearestDist = 1000000
				local goodRes = undefined
				
				if arr.count>0 do	
				(				
					for obj in arr do
					(
						local res = finditem mergedNodes obj[1]

						if obj[1] != sourceObj  and  obj[1].ishidden == false and res == 0 do
						(
						
							tmpDist = distance viewPos obj[2].pos
							
							if tmpDist < nearestDist do
							(
-- 									format "mn: %\n" mn.name
								nearestDist = tmpDist
								goodRes = obj
-- 								format "obj: %\n" obj
							)
						)
					)
				)			
				
				if goodRes != undefined do
				(
					undo on
					(
						sourceObj.controller.pos.controller.value =  goodRes[2].pos
						sourceObj.dir =  goodRes[2].dir
					)
				)
			)
		)
		
		on mouseAbort clickno do
		(
-- 			format "clickno3: %\n"  clickno
-- 			if isvalidnode sourceObj then delete sourceObj
		)
	)
	
	-- ui	
	group "Muli-Selections:"
	(
		checkbox oneSelCB "selection unique" enabled: true
		
		multiListBox refArMLB "selection:" height: 5		
		button addSelBT "add" across: 4
		button selSelBT "select" -- across: 2
		button removeBT "remove"
		button clearBT "clear"
		
	)
	
	group "copy options:"
	(
		radiobuttons workOnRB "object:" labels: #("original", "copy") offsets:#([50,-16], [80,-16])
		radiobuttons layerRB "layer:" labels: #("source", "target") offsets:#([50,-16], [80,-16]) -- enabled: false
		radiobuttons cloneTypeRB "clone type:" labels: #("copy", "instance")   offsets:#([80,-16], [80,-16]) 
	)
	

	
	group "rescale on bounding box:"
	(
-- 		checkbox rescaleOnBT "on" enabled: false checked: true
		checkbox rescaleXCB "x"  checked: true across: 3 
		checkbox rescaleYCB "y"  checked: true -- enabled: false
		checkbox rescaleZCB "z"  checked: true
	)

	
	group "Align type (ref > target):"
	(
		radiobuttons alignTypeTB "Align type:" labels: #("pivot > pivot", "pivot > center", "center > pivot", "center > center")  offsets:#([80,-16], [220,-32], [80,-32],[220,-48]) 
	)
	
	group "Targets:"
	(
		button selByWcBT "select object by wirecolor"
	)
	
	checkbox randomCB "random" across: 3
	button resizeBT "resize"
	button replaceV2BT "replace" -- across: 2
	
	group "picker"
	(
		checkbutton placeCB "place"
	)
	
	
	fn refreshUI =
	(	
		refAr = for o in refAr where isvalidnode o collect o
		refArMLB.items = for o in refAr collect o.name
	)
	
	fn enableBT state =
	(
		rescaleXCB.enabled = state
		rescaleYCB.enabled = state
		rescaleZCB.enabled = state
	)
	
-- 	actions
	on objReplacerRLT open do
	(
		if refAr == undefined then refAr = #()
		refAr = for ref in refAr where isvalidnode ref collect ref
		loadRolloutParams objReplacerRLT Params
		if RLTvers != undefined then objReplacerRLT.title = objReplacerRLT.title + " v." + (RLTvers as string)
-- 		enableBT rescaleOnBT.state
		refreshUI()
	)
	
	on objReplacerRLT close do
	(
		writeRolloutParams objReplacerRLT Params
	)
	
	-- connections
	on selSelBT pressed do
	(
		local refSelAr = for i in refArMLB.selection collect refAr[i]
		select refSelAr
	)
	
	on addSelBT pressed do
	(
		local refObjTmp =  checkReference2 (selection as array)
		
		if oneSelCB.checked then 
		(
			refAr = #(refObjTmp[1])
		)
		else
		(
			for r in refObjTmp do appendifunique refAr r
		)
		
		format "%\n" refAr.count
		
		refreshUI()
		refArMLB.selection = refAr.count
	)
	
	on removeBT pressed do
	(
		refSelIdAr = refArMLB.selection as array
		
		for i = refSelIdAr.count to 1 by - 1  do
		(
			deleteitem refAr refSelIdAr[i]
		)
		refreshUI()
	)
	
	on clearBT pressed do
	(
		refAr = #()
		refreshUI()
	)
	
	on selByWcBT pressed do
	(
		local sel = selection as array
		if sel.count > 0 then 
		(
			local sameWireAr = #()
			local refWire = sel[1].wirecolor
			for g in geometry where g.wirecolor == refWire do append sameWireAr g
			select sameWireAr
		)
		
	)
	
	on resizeBT pressed do
	(
		-- tous les objets de la fenetre
		local refSelAr = for i in refArMLB.selection collect refAr[i]
		format "refSelAr: %\n" refSelAr
		
		-- selection de gabarits
		local targetArr = selection as array
		format "targetArr: %\n" targetArr
		
		if refSelAr.count >= 1 and targetArr.count >= 1 then
		(
			undo on
			(
				jmax = refSelAr.count
				j = 1
				
				for s in targetArr do
				(			
-- 					j+=1
					-- replace
					if (s != refSelAr[j]) then
					(
						if isvalidnode refSelAr[j] then
						(
							local res = #()
							local copyRef
							
							-- copy ref 
							maxOps.cloneNodes refSelAr[j] cloneType: #copy newNodes:&copyRef

							-- placement sur layer
							if layerRB.state == 1 then()
							else if layerRB.state == 2 then for c in copyRef do s.layer.addnode c
							else()
							
							-- unhide de la copy
							if copyRef == undefined then()
							else if copyRef.count > 0 then for o in copyRef do o.ishidden = false
							else()
							
							-- convertoPoly
							for o in copyRef where not iskindof s editable_poly do converttopoly o

							-- trouver la tete de hierarcchie de la copy
							local copyHead = findHeadsOfHierarchy2 copyRef
								
							-- resize
							if copyHead.count == 1 then 
							(			
								
								copyHead[1].rotation = s.rotation
								copyHead[1].center = s.center
								
								-- relever la taille du gabarit
								local bb = nodeGetBoundingBox  s s.transform
								local gabaritSize = point3 (distance (point3 bb[1].x 0 0) (point3 bb[2].x 0 0 )) (distance (point3 0 bb[1].y 0) (point3 0 bb[2].y 0 )) (distance (point3 0 0 bb[1].z) (point3 0 0 bb[2].z))
								
								-- determiner les valeurs maximales et minimales en z et y des  vertex par rapport au ref
								xmax = -1000
								xmin = 1000
								ymax = -1000
								ymin = 1000
								zmax = -1000
								zmin = 1000	
								
								for o in copyRef do
								(
									onebb = (nodeGetBoundingBox o copyHead[1].transform)
									if onebb[1].x > xmax then xmax =  onebb[1].x
									if onebb[2].x > xmax then xmax =  onebb[2].x
									if onebb[1].x < xmin then xmin =  onebb[1].x
									if onebb[2].x < xmin then xmin =  onebb[2].x
									
									if onebb[1].y > ymax then ymax =  onebb[1].y
									if onebb[2].y > ymax then ymax =  onebb[2].y
									if onebb[1].y < ymin then ymin =  onebb[1].y
									if onebb[2].y < ymin then ymin =  onebb[2].y
										
									if onebb[1].z > zmax then zmax =  onebb[1].z
									if onebb[2].z > zmax then zmax =  onebb[2].z
									if onebb[1].z < zmin then zmin =  onebb[1].z
									if onebb[2].z < zmin then zmin =  onebb[2].z
								)	
								
								-- relever la taille de la fentres
								fenetreSize = point3 (distance (point3 xmin 0 0) (point3 xmax 0 0 )) (distance (point3 0 ymin 0) (point3 0 ymax 0 )) (distance (point3 0 0 zmin) (point3 0 0 zmax))

								-- calculer le decalage entre la fenetre et le gabarit
								theShift =  gabaritSize - fenetreSize
								
								format "theShift: %\n" theShift
								-- valeur de decalage arbitraire
								zMaxMove = theShift.z * 0.5
								zMinMove = theShift.z * -0.5
								yMaxMove = theShift.y  * 0.5
								yMinMove = theShift.y * -0.5
								xMaxMove = theShift.x  * 0.5
								xMinMove = theShift.x * -0.5
									

								-- plage de selection des vertex
								zMaxRange = -30
								zMinRange = 18
								yMaxRange = -15
								yMinRange = 15
								xMaxRange = -15
								xMinRange = 5
									
														
								-- deplacement des vertex et des pivots
-- 								for s in fenSelAr do
								for o in copyRef where not iskindof o dummy do
								(
									format "========= %\n" o.name
									
									numVert = o.GetNumVertices () 
									wireTmp = color (random 1 255) (random 1 255) (random 1 255)
									
						-- 			test et d�calage du pivot si necessaire
									pvtPos = in coordsys copyHead[1] o.pivot
									pvtPosXShift = 0
									pvtPosYShift = 0
									pvtPosZShift = 0
									movePivot = false
										
									if pvtPos.x >= xmax + xMaxRange then
									(
										format "yMaxMove: %\n" pvtPos
										movePivot = true
										pvtPosXShift = xMaxMove
									)
									else if pvtPos.x <= xmin + xMinRange then
									(
										format "yMinMove: %\n" pvtPos
										movePivot = true
										pvtPosXShift = xMinMove
									)
									else() 
									
									if pvtPos.y >= ymax + yMaxRange then
									(
										format "yMaxMove: %\n" pvtPos
										movePivot = true
										pvtPosYShift = yMaxMove
									)
									else if pvtPos.y <= ymin + yMinRange then
									(
										format "yMinMove: %\n" pvtPos
										movePivot = true
										pvtPosYShift = yMinMove
									)
									else()
									
									if pvtPos.z >= zmax + zMaxRange then
									(
										format "zMaxMove: %\n" pvtPos
									)
									else if pvtPos.z <= zmin + zMinRange then
									(
										format "zMinMove: %\n" pvtPos
									)
									else()
									
									if movePivot then o.pivot = (transMatrix([pvtPosXShift,pvtPosYShift,pvtPosZShift]) * o.transform).translation
									
												
									-- test et deplacement de chaque vertex
									for i = 1 to numVert do
									(
										vPos = ((polyop.getvert o  i) * inverse copyHead[1].transform)
										vPosXShift = 0
										vPosYShift = 0
										vPosZShift = 0
										moveVertex = false
										
										-- determiner s'il doit y avoir un saut du vertex sur l'axe z
										if vPos.z >= zmax + zMaxRange then
										(
											moveVertex = true
											vPosZShift = zMaxMove
										)
										else if  vPos.z <= zmin + zMinRange then
										(
											moveVertex = true
											vPosZShift = zMinMove
										)
										else()
										
										-- determiner s'il doit y avoir un saut du vertex sur l'axe y
										if vPos.y >= ymax + yMaxRange then
										(
											moveVertex = true
											vPosYShift = yMaxMove
										)
										else if  vPos.y <= ymin + yMinRange then
										(
											moveVertex = true
											vPosYShift = yMinMove
										)
										else()
										
										-- determiner s'il doit y avoir un saut du vertex sur l'axe x
										if vPos.x >= xmax + xMaxRange then
										(
											moveVertex = true
											vPosXShift = xMaxMove
										)
										else if  vPos.x <= xmin + xMinRange then
										(
											moveVertex = true
											vPosXShift = xMinMove
										)
										else()
										
										-- deplacement du vertex si n�cessaire
										if moveVertex then polyop.setvert o #{i} ((vPos + [vPosXShift, vPosYShift, vPosZShift])*copyHead[1].transform)
									)
								)		
							)							
						)
						else
						(
							format "not valid node: %\n" refObj
							refreshUI()
						)
					)
					else
					(
						format "reference et target sont un m�me objet\n"
					)
				)
-- 				format "j: %\n" j
			)
		)
		else(format "check selection\n")
	)
	
	on replaceV2BT pressed do
	(
		
		local refSelAr = for i in refArMLB.selection collect refAr[i]
		format "refSelAr: %\n" refSelAr
		
		local targetArr = selection as array
		format "targetArr: %\n" targetArr
		
		if refSelAr.count >= 1 and targetArr.count >= 1 then
		(
			undo on
			(
				jmax = refSelAr.count
				j = 0
				
				for s in targetArr do
				(
					-- calcul de j
					if randomCB.state then
					(
						-- suite
						j = random 1 jmax
						format "random: %\n" j
					)
					else
					(
						-- random
						if j >= jmax then j = 0
						j += 1
						format "order: %\n" j
					)
					
					-- replace
					if (s != refSelAr[j]) then
					(
						if isvalidnode refSelAr[j] then
						(
							local res = #()
							local copyRef
							
							-- copy ref 
							if workOnRB.state == 1 then
							(
								copyref = #(refSelAr[j])
							)
							else if cloneTypeRB.state == 1  then
							(
								maxOps.cloneNodes refSelAr[j] cloneType: #copy newNodes:&copyRef
							)
							else if cloneTypeRB.state == 2 then
							(
								maxOps.cloneNodes refSelAr[j] cloneType: #instance newNodes:&copyRef
							)
							else()
							
							-- placement sur layer
							if layerRB.state == 1 then
							(
								
							)
							else if layerRB.state == 2 then
							(
								for c in copyRef do s.layer.addnode c
							)
							else()
							
							-- unhide de la copy
							if copyRef == undefined then()
							else if copyRef.count > 0 then
							(
								for o in copyRef do o.ishidden = false
							)
							else()
							


							-- trouver la tete de hierarcchie de la copy
							local copyHead = findHeadsOfHierarchy2 copyRef
							
							-- replace
							if copyHead.count == 1 then 
							(
								res = replaceObject3 copyHead[1] s  rescaleX2: rescaleXCB.state rescaleY: rescaleYCB.state rescaleZ: rescaleZCB.state \
								aligntype: alignTypeTB.state
								
								format  "result: %\n" res
							)							
						)
						else
						(
							format "not valid node: %\n" refObj
							refreshUI()
						)
					)
					else
					(
						format "reference et target sont un m�me objet\n"
					)
				)
-- 				format "j: %\n" j
			)
		)
		else
		(
			format "check your selections\n"
		)
	)	
	
	on placeCB	changed state do
	(	
		
		format "start picker\n"
		local refSelAr = for i in refArMLB.selection collect refAr[i]
		if refSelAr.count == 1  then
		(
-- 			maxOps.cloneNodes refSelAr[1] cloneType:#instance newNodes:&mergedNodes
			
-- 			local mergedNodes
							
			-- copy ref 
			if workOnRB.state == 1 then
			(
				mergedNodes = #(refSelAr[1])
			)
			else if cloneTypeRB.state == 1  then
			(
				maxOps.cloneNodes refSelAr[1] cloneType: #copy newNodes:&mergedNodes
			)
			else if cloneTypeRB.state == 2 then
			(
				maxOps.cloneNodes refSelAr[1] cloneType: #instance newNodes:&mergedNodes
			)
			else()
			
			
			for m in mergedNodes do m.ishidden = false
			
			sourceObj = point name: (uniquename "toto_CTRL")
			
			local toParent = for m in  mergedNodes collect m
			append toParent sourceObj
			lastParent toParent
			
			format "mergedNodes: %\n" mergedNodes
			format "toParent: %\n" toParent
			-- alignement de l'objet sur le helper
			mergedNodes[1].transform.controller.value = matrix3 1
			
			if state == true do
			(
				continueTool = true
				while continueTool == true do
				(
					continueTool = starttool placeObjTool
				)
				placeCB.state = false
			)
			delete sourceObj
			format "picker done\n"
		)
		else 
		(
			format "selectionner un objet dans la liste\n"
			placeCB.state = false
		)
	)
)
createdialog objReplacerRLT width: 350


