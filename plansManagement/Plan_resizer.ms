/*
HOW TO:
numeric resize
1. "create scaler to create" or init scaler object
2. "create size reference" to create or init size reference object
3. "parent map" to init map to resize
4. place resizer
5. "resize" to resize map
tz
maj:

-- make distance interactive(event)
-- make ui interactive to scaler deletion(event)
-- condition "resize map" active to map to resize selected(event)

x add tool to pick root position  and target position (event with checkbutton)

-- scale resizer with map
-- calculate dimension on bounding box and do not use plane size anymore

-- create scaler on opennig and delete on close?

-- add deletion system?
-- add root and target system selection?

-- separate ui and function

-- add plan opacity
-- add scaler on each plan
-- activate reference on demand
-- add function to rotate plan
-- add function to snap scaler

x-- hide scaler
x-- place scaler on helper layer
x-- minimize scaler size
x-- add init scaler and resizer on opening rollout

*/

-- check system presence
fn checkScalerDef =
(
	local scalerAr =#()
	local startPt, endPt, scaler
	startPt = getnodebyname  "startPoint"
	endPt = getnodebyname  "endPoint"
	scaler = getnodebyname  "scaler"
	
	if startPt != undefined do append scalerAr startPt
	if endPt != undefined do append scalerAr endPt
	if scaler != undefined do append scalerAr scaler
		
	if scalerAr.count == 3 then
	(
		scalerAr
	)
	else
	(
		undefined
	)
)


--  create system
fn createScalerSys =
(
	-- create layer
	local LM = layermanager
	local planLayer
	if (LM.getLayerFromName "helpers") == undefined then
	(
		planLayer = LM.newLayerFromName "helpers"
	)
	else
	(
		planLayer = LM.getLayerFromName "helpers"
	)
	
	-- create scaler
	local startPt, endPt, scaler

	startPt = getnodebyname  "startPoint"
	if  startPt == undefined do startPt = point name: "startPoint" wirecolor: red size: 20 box: true cross: true

	endPt = getnodebyname  "endPoint"
	if  endPt == undefined do endPt = point name: "endPoint" wirecolor: red parent: startPt size: 15 box: false cross: true pos: [10,0,0]
		
	scaler = getnodebyname  "scaler"
	if  scaler == undefined do scaler = point name: "scaler" wirecolor: yellow parent: startPt size: 2 box: true cross: false
	
	planLayer.addnode startPt
	planLayer.addnode endPt
	planLayer.addnode scaler
	
	#(startPt, endPt, scaler)
	
	-- handler

)

fn resizePlan scaler ratio = 
(
	undo on
	(
		scaler.scale = scaler.scale*ratio
	)
)

-- GetDialogPos planResizerRLT

try(destroydialog planResizerRLT)catch()
rollout planResizerRLT "blueprint resizer" width: 250
(
-- 	vars
	local scalerArray = #()
	local refArray = #()
	local reelDist
	
	local scalerParent
	local resizerParent
	
	local sourceObj
	
	local	startPt 
	local	endPt 
	local	scaler 
	
	local	startSize
	local	endSize 

	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
-- 	fonctions

	
-- 	tools
	
	tool placeObjTool
	(

		on mousePoint clickno do
		(
-- 			print clickno
			local myRay = mapScreenToWorldRay viewPoint
-- 			print myRay
			local arr = intersectRayScene myRay
-- 			print "===="
-- 			print arr
			
			local viewMatrix =  Inverse(viewport.getTM())
			local viewPos = viewMatrix.pos
			local nearestDist = 1000000
			local goodRes = undefined
			
			if arr.count>0 do	
			(				
				for obj in arr do
				(
					if obj[1] != sourceObj and obj[1].ishidden == false do
					(
						tmpDist = distance viewPos obj[2].pos
						
						if tmpDist < nearestDist do
						(
-- 							print  obj[1]
-- 							print tmpDist
							nearestDist = tmpDist
							goodRes = obj
						)
					)
				)
			)			
-- 			print "==== result"
-- 			print goodRes
			
			if goodRes != undefined do
			(
				sourceObj.controller.pos.controller.value =  goodRes[2].pos
				sourceObj.dir =  goodRes[2].dir
			)
		)

		on mouseMove clickno do
		(
			if lButton == true do
			(
				local myRay = mapScreenToWorldRay viewPoint
	-- 			print myRay
				local arr = intersectRayScene myRay
	-- 			print "===="
-- 				print arr
-- 				print "ploufe"
				
				local viewMatrix =  Inverse(viewport.getTM())
				local viewPos = viewMatrix.pos
				local nearestDist = 1000000
				local goodRes = undefined
				
				if arr.count>0 do	
				(				
					for obj in arr do
					(
						if obj[1] != sourceObj  and obj[1].ishidden == false do
						(
							tmpDist = distance viewPos obj[2].pos
							
							if tmpDist < nearestDist do
							(
	-- 							print  obj[1]
	-- 							print tmpDist
								nearestDist = tmpDist
								goodRes = obj
							)
						)
					)
				)			
	-- 			print "==== result"
	-- 			print goodRes
				
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
	)
	
-- 	UI

	-- pick blueprint resizer
			-- create resizer
	group "Scaler:"
	(
		edittext scalerSpyET "scaler in scene :" readonly: true
		
		button createScaler_bt "create scaler" across:3
		button selScaler_bt "select scaler"
		button centerScaler_bt "center map" 
		
		checkbutton placeObjBT "snapping root" enabled: false across: 2
		checkbutton placeTgtBT "snapping target" enabled: false
		
-- 		spinner multiScaler "Scaler size x" range: [0,100,1] type:#float across:2
		button resizeScaler "size x 10" across: 2
		button resizeScalerBT2 "size x 0.1"
-- 		button resetScaler "Reset Scaler"
	)
	
	group "Map:"
	(
		button parentScaler_bt "parent map" 
		edittext mapToResize_et "map to resize:" readOnly: true
	)
	
	group "Distance in scene:"
	(
		edittext distResize_et "distance:" readOnly: true
		button refreshDistResize_pb "refresh distance"
	)
	
	group "Numeric:"
	(
		spinner size_sp "size:" range: [0,100000,0]  type: #worldunits 
		-- display size reference	
	)
	
	-- rescale points
	button rescale_bt "resize map"
	
-- 	UI functions
	fn refreshUI  =
	(
		if scalerArray == undefined then
		(

			scalerSpyET.text = "no"
			
			createScaler_bt.enabled = true
			selScaler_bt.enabled = false
			centerScaler_bt.enabled = false
			
			placeObjBT.enabled = false
			placeTgtBT.enabled = false
			
			resizeScaler.enabled = false
			resizeScalerBT2.enabled = false
			
			parentScaler_bt.enabled = false
			mapToResize_et.enabled = false

			distResize_et.enabled = false
			refreshDistResize_pb.enabled = false			
		)
		else 
		(
			scalerSpyET.text = "yes"
		
			startPt = scalerArray[1]
			endPt = scalerArray[2]
			scaler = scalerArray[3]
			
			createScaler_bt.enabled = false
			selScaler_bt.enabled = true
			centerScaler_bt.enabled = true
			
			placeObjBT.enabled = true
			placeTgtBT.enabled = true
			
			resizeScaler.enabled = true
			resizeScalerBT2.enabled = true
			
			parentScaler_bt.enabled = true
			mapToResize_et.enabled = true

			distResize_et.enabled = true
			refreshDistResize_pb.enabled = true
		)
	)

-- 	actions
	on planResizerRLT open do
	(
		scalerArray = createScalerSys()
		scalerArray = checkScalerDef()
		
		loadRolloutParams planResizerRLT #("pos")

-- 		loadPosition "planResizerRLT" planResizerRLT
		refreshUI()
		
		sel = selection as array
		if sel.count == 1 then
		(			
			if superclassof sel[1] == geometryclass then
			(				
				scalerParent = sel[1]
				startPt.parent = sel[1]
				mapToResize_et.text = sel[1].name
			)
		)
	)
	
	on planResizerRLT close do
	(
		writeRolloutParams planResizerRLT #("pos")

		try(delete scalerArray)catch(print "nothing to delete")
-- 		writePosition "planResizerRLT" planResizerRLT
	)
	
	on createScaler_bt pressed do
	(
		createScalerSys()
		
		scalerArray = checkScalerDef()
		refreshUI scalerArray
	)

	on selScaler_bt pressed do select scalerArray
	
	on refreshDistResize_pb pressed do
	(
		reelDist = distance startPt endPt
		distResize_et.text = (reelDist as string) + "cm"
	)
	
	on parentScaler_bt pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			for s in sel do
			(
				if superclassof s == geometryclass then
				(
				scalerParent = s
				startPt.parent = s
				mapToResize_et.text = s.name
				)
				else
				(
					print "fail!"
				)
				
			)
		)
		else
		(
			print "bad selection"
		)
	)
	
	on centerScaler_bt pressed do
	(
		map = getnodebyname mapToResize_et.text
		if map != undefined then
		(	
			startPt.rotation = map.rotation
			startPt.pos = map.pivot
		)
		else
		(
			print "no map selected"
		)
		
	)
	
	on placeObjBT changed state do
	(
		format "scalerArray: %\n" scalerArray
		for s in scalerArray do s.ishidden == false
		l = LayerManager.getLayerFromName "helpers"	
		l.on = true
		
		when transform scalerArray[1]  changes do (
			distResize_et.text = ((distance scalerArray[1] scalerArray[2]) as string) + "cm"
		)
		
		bakParent = startPt.parent
		bakChildParent = endPt.parent
		
		startPt.parent = undefined
		endPt.parent = undefined
		
		sourceObj = startPt
		
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool
			)
			placeObjBT.state = false
		)
		
		startPt.parent = bakParent
		endPt.parent = bakChildParent
		

	)
	
	on placeTgtBT changed state do
	(
		format "scalerArray: %\n" scalerArray
		for s in scalerArray do s.ishidden == false
		
		when transform scalerArray[2]  changes do (
			distResize_et.text = ((distance scalerArray[1] scalerArray[2]) as string) + "cm"
		)
		
		bakParent = endPt.parent
		endPt.parent = undefined
		sourceObj = endPt
		
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool
			)
			placeTgtBT.state = false
		)
		
		endPt.parent = bakParent
		
	)
	
	on resizeScaler pressed do
	(
		startPt.size = startPt.size*10
		endPt.size = endPt.size*10
		scaler.size = scaler.size*10
-- 		multiScaler.value = 1.0 
	)
	
	on resizeScalerBT2 pressed do
	(
		startPt.size = startPt.size*0.1
		endPt.size = endPt.size*0.1
		scaler.size = scaler.size*0.1
	)
-- 	
-- 	-- resize with a dimension, resize with a size reference.

-- 	-- create visual resizer	
	on selSize_bt pressed do
	(
		select refArray
	)
	
	on refreshDistRef_pb pressed do
	(
		refDist = distance startSize endSize
		print refDist
		distRef_et.text =  refDist as string
	)

	
	on parentRef_bt pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			
			for s in sel do
			(
				if superclassof s == geometryclass then
				(
					refParent = s
					startSize.parent = s
					mapAsRef_et.text = s.name
				)
				else
				(
					print "fail"
				)
			)
		)
		else
		(
			print "bad selection"
		)
	)

	
	on centerRef_bt pressed do
	(
		print mapAsRef_et.text
		mapRef = getnodebyname mapAsRef_et.text
		print mapRef
		if mapRef != undefined then
		(	
			startSize.rotation = mapRef.rotation
			startSize.pos = mapRef.pivot
		)
		else
		(
			print "no map selected"
		)
		
	)
		
-- 	-- resize!
	on rescale_bt pressed do
	(

			local aimedDist = size_sp.value
			format "aimedDist: %\n" aimedDist 
					
			if startPt != undefined and scalerParent != undefined and aimedDist != 0 then
			(
				reelDist = float( distance startPt endPt)
				-- aimedDist =  float(distance startSize endSize)
				ratio = aimedDist/reelDist

				startPt.parent = undefined
				scalerParent.parent = scaler
				
				resizePlan scaler ratio
-- 				scaler.scale = scaler.scale*ratio
	-- 			startPt.scale = scaler.scale*ratio
				scalerParent.parent = undefined
				
				scaler.scale = [1,1,1]
				startPt.parent = scalerParent
			)
			else
			(
				format "correct your selection"
			)
		
	)
)




/*
try(closeRolloutFloater planResizerRF)catch()
planResizerRF = newRolloutFloater "Blueprint Tools" 300 400 
-- addRollout opaRLT theNewFloater
addRollout planResizerRLT planResizerRF
*/

createdialog planResizerRLT style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

-- planResizerRF.pos 




