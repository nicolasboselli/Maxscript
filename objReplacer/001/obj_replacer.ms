/*
-- maj:
	x- freezer les axe de scale
		-- aligner sur le fonde la box
	-- faire fonctionner sur une selection d'objet en respectant la hierarchie
	
	-- proposer l alignement pivot>pivot ou pivot>centre ou centre/pivot
	-- proposer aligner sur x y z
	-- proposer un remap x sur x y ou z puis y sur x y ou z
	
	-- ajouter un picker
	
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
	local params = #("pos","rescaleXCB", "rescaleYCB", "rescaleZCB", "randomCB", "rescaleOnBT")
	--vars
	local modFFD
	local refObj = undefined
	local targetArr = undefined
	-- function
	local RLTvers = getScriptVersion (getThisScriptFilename())
		
	local refAr = #()
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
				format "arr: %\n" arr
				
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
		multiListBox refArMLB "selection:"
		button addSelBT "add" across: 2
		button removeBT "remove"
	)
	
	group "rescale on bounding box:"
	(
		checkbox rescaleOnBT "on"
		checkbox rescaleXCB "x"  checked: true across: 3 
		checkbox rescaleYCB "y"  checked: true -- enabled: false
		checkbox rescaleZCB "z"  checked: true
	)
	
	checkbox randomCB "random" across: 2
	button replaceV2BT "replace" -- across: 2
	
	group "picker"
	(
		checkbutton placeCB "place"
	)
	
	
	fn refreshUI =
	(		
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
		loadRolloutParams objReplacerRLT Params
		if RLTvers != undefined then objReplacerRLT.title = objReplacerRLT.title + " v." + (RLTvers as string)
		enableBT rescaleOnBT.state
		refreshUI()
	)
	
	on objReplacerRLT close do
	(
		writeRolloutParams objReplacerRLT Params
	)
	
	-- connections
	
	on addSelBT pressed do
	(
		local refObjTmp =  checkReference2 (selection as array)
		
		for r in refObjTmp do appendifunique refAr r
		
		refreshUI()
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
	
	on rescaleOnBT changed state do
	(
		enableBT state
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
							local res 
							-- operation de replace
							if rescaleOnBT.state then
							(
								res = replaceObject2 refSelAr[j] s  rescaleX: rescaleXCB.state rescaleY: rescaleYCB.state rescaleZ: rescaleZCB.state
							)
							else
							(
								res = replaceObjectOnPivot refSelAr[j] s
							)
							format  "result: %\n" res
							
						)else(format "not valid node: %\n" refObj)
					)
					else
					(
						format "reference et target sont un même objet\n"
					)
				)
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
		if refSelAr.count > 0 then
		(
			maxOps.cloneNodes refSelAr[1] cloneType:#instance newNodes:&mergedNodes
			
			sourceObj = point name: (uniquename "toto_CTRL")
			
			local toParent = for m in  mergedNodes collect m
			append toParent sourceObj
			lastParent toParent
			
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
createdialog objReplacerRLT width: 400

objReplacerRLT.refArMLB.selection.count

