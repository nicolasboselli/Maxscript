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
-- récupérer les valeur en pixel des jpg et la resolution, calculer la taille de l'image et faire x100

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
	
	tool placeObjTool2
	(
		
		local snapNode
		
		on mousePoint clickno do
		(
			local myRay = mapScreenToWorldRay viewPoint
			if snapMode.node != undefined then snapNode = snapMode.node
			
			format "snapNode: %\n" snapNode
			if isvalidnode snapNode then
			(
				tmpHit = intersectRayEx snapNode myRay
				format "tmpHit: %\n" tmpHit
				if tmpHit != undefined then
				(				
					sourceObj.controller.pos.controller.value =  tmpHit[1].pos
					sourceObj.dir =  tmpHit[1].dir
					
				)
			)
		)

		on mouseMove clickno do
		(
			if lButton == true do
			(
				local myRay = mapScreenToWorldRay viewPoint
-- 				if snapMode.node != undefined then snapNode = snapMode.node
									
				if isvalidnode snapNode then
				(
					tmpHit = intersectRayEx snapNode myRay
					if tmpHit != undefined then
					(
						sourceObj.controller.pos.controller.value =  tmpHit[1].pos
						sourceObj.dir =  tmpHit[1].dir
					)
				)				
			)
		)
	)
	
-- 	UI

	-- pick blueprint resizer
			-- create resizer
	group "Inspection:"
	(
		edittext scalerSpyET "scaler in scene :" readonly: true
		
		button createScaler_bt "create scaler"  enabled: false across:3
		button selScaler_bt "select scaler" enabled: false
		button centerScaler_bt "center map" enabled: false
	)
	
	group "Scaler:"
	(
		checkbutton placeObjBT "snapping root" enabled: true across: 2
		checkbutton placeTgtBT "snapping target" enabled: true
		
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
	
	group "realSize:"
	(
		button realSizeBT "Real Size Map" across: 3
		spinner scaleSP "X" type: #integer range: [0,1000,1]
		button scaleBT "scale"
-- 		button scale100BT "x100"
-- 		button scale200BT "x200"
	)
	
	group "Distance in scene:"
	(
		edittext distResize_et "size in scene:" readOnly: true
		button refreshDistResize_pb "refresh distance"
	)
	
	group "Numeric:"
	(
		spinner size_sp "real size:" range: [0,1000000,0]  type: #worldunits 
		-- display size reference	
	)
	
	-- rescale points
	button rescale_bt "Resize Map"
	
	
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
		
	on realSizeBT pressed do
	(
		sel = selection as array
		for s in sel where iskindof s.baseobject plane do
		(
			local oneDifMap
			local jpgPath --= s.material.diffusemap.bitmap.filename
			
			if isKindOf s.material PhysicalMaterial  then
			(
-- 				jpgPath = s.material.base_color_map.bitmap.filename
				oneDifMap = s.material.base_color_map
			)
			else if isKindOf  s.material standard then
			(
				format "check1\n" 
-- 				jpgPath = s.material.diffusemap.bitmap.filename
				oneDifMap = s.material.diffusemap
				format "check2\n" 
			)
			else()
			
			if iskindof oneDifMap bitmaptexture then
			(
				jpgPath = oneDifMap.filename
			)
			else if iskindof oneDifMap vraybitmap then
			(
				format "oneDIfMap: %\n" oneDifMap
				jpgPath = oneDifMap.HDRIMapName
			)
			else()

			img = (dotNetClass "System.Drawing.Image").FromFile jpgPath

			s.baseobject.length = (img.Height / img.VerticalResolution)*2.54
			s.baseobject.width = (img.Width / img.HorizontalResolution)*2.54
						
			s.scale = [1,1,1]
-- 			s.uvwmap
			
			s.uvwmap.gizmo.scale = [1,1,1]
			s.uvwmap.length = s.baseobject.length
			s.uvwmap.width = s.baseobject.width
			
		)
	)
	
	on scaleBT pressed do
	(
-- 		format "scale: %\n" scaleSP.value
		sel = selection as array
		for s in sel do
		(
			s.scale = [1,1,1]
			s.scale *= scaleSP.value
		)
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
		format "place root - scalerArray: %\n" scalerArray
		-- unhide helpers
		l = LayerManager.getLayerFromName "helpers"	
		l.on = true
		for s in scalerArray do s.ishidden = false
		
		when transform scalerArray[1]  changes do (
			distResize_et.text = ((distance scalerArray[1] scalerArray[2]) as string) + "cm"
		)
		
		bakParent = startPt.parent
		bakChildParent = endPt.parent
		
		startPt.parent = undefined
		endPt.parent = undefined
		
		sourceObj = startPt
		
		-- settings du snap
		-- activaton du display

		-- activaton du snap
		local bakSnapActive = snapMode.active
		if not bakSnapActive then snapMode.active = true
			
		-- active face
		bakFaceSnap = snapMode.getOSnapItemActive 7 5
		if not bakFaceSnap then snapMode.setOSnapItemActive 7 5 true
		-- desactiver reste
		
		max drawingaids; max drawingaids 
		
		
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool2
			)
			placeObjBT.state = false
		)
		
		startPt.parent = bakParent
		endPt.parent = bakChildParent
		
		-- apply bak settings
-- 		snapMode.display = bakSnapDisplay
		snapMode.active = bakSnapActive		
		snapMode.setOSnapItemActive 7 5 bakFaceSnap

	)
	
	on placeTgtBT changed state do
	(
		format "place target - scalerArray: %\n" scalerArray
		-- unhide helpers
		l = LayerManager.getLayerFromName "helpers"	
		l.on = true
		for s in scalerArray do s.ishidden = false
		
		when transform scalerArray[2]  changes do (
			distResize_et.text = ((distance scalerArray[1] scalerArray[2]) as string) + "cm"
		)
		
		bakParent = endPt.parent
		endPt.parent = undefined
		sourceObj = endPt
		
		-- snap setting				
		-- activaton du snap
		local bakSnapActive = snapMode.active
		if not bakSnapActive then snapMode.active = true
			
		-- active face		
		bakFaceSnap = snapMode.getOSnapItemActive 7 5
		if not bakFaceSnap then snapMode.setOSnapItemActive 7 5 true
-- 		
		max drawingaids; max drawingaids 
		if state == true do
		(
			format "place tangent: % \n" sourceObj
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool2
			)
			placeTgtBT.state = false
		)
		
		endPt.parent = bakParent
		
		-- apply bak settings
-- 		snapMode.display = bakSnapDisplay
		snapMode.active = bakSnapActive		
		snapMode.setOSnapItemActive 7 5 bakFaceSnap
		
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




