-- develop tool to place object
	-- keep tool active on viewport after clik mid button
	-- keep, initial rotation
	-- work with group 
	-- copy hierarchy
	-- ignore hidden object 
	-- ignore chidren object
-- tool to add edge loop
	-- turn the plane on the right side
	-- connect on the right side

rollout testtoolRLT "test tool"
(
	local sourceObj = undefined
	
	tool testTool
	(
		local snapPoint
		
		on mousePoint clickno do
		(
-- 			print viewPoint
			myRay = mapScreenToWorldRay viewPoint
-- 			print myRay
			arr = intersectRayScene myRay
-- 			arr = intersectRayEx $ myRay
			if arr.count>0 do
			(
				dad =  arr[1][1]
				onePos =  arr[1][2].pos
				oneDir =  arr[1][2].dir
				snapPoint = point pos: onePos parent: dad cross: false axistripod: true wirecolor: orange dir: oneDir
			)
		)
		
		on mouseMove clickno do
		(
				myRay = mapScreenToWorldRay viewPoint
		-- 			print myRay
				arr = intersectRayScene myRay
				try
				(
					snapPoint.position = arr[1][2].pos
					snapPoint.dir = arr[1][2].dir
				)
				catch()
				
				if ctrlKey == true do
				(
					print "youpi"
				)
			
		)

	)
	
	fn intersectDef oneObj oneRay =
	(
-- 		convertToMesh oneObj
		meshMod = edit_mesh()
		addmodifier oneObj meshMod
		res = intersectRayEx oneObj oneRay
		deletemodifier oneObj meshMod
		return res
	)
	
	fn meshFaceToPoly2 poly mesh_face =
	(
		 face_verts = meshop.getVertsUsingFace poly.mesh mesh_face
		 vert_faces = for item in face_verts collect (polyOp.getFacesUsingVert poly item)
		 result = (vert_faces[1] * vert_faces[2] * vert_faces[3]) as array
		 result[1]
	)
	
	tool selectEdgeTool
	(
		on mousePoint clickno do
		(
			myRay = mapScreenToWorldRay viewPoint
-- 			print myRay
			arr = intersectRayScene myRay
			local res = undefined
			
-- 			print arr.count
			if arr.count > 0 do
			(
				res = intersectDef arr[1][1] myRay
			)
			
			if res != undefined do
			(
				-- get face
-- 				meshFaceNum =  res[2]
				faceNum = meshFaceToPoly2 arr[1][1]  res[2]
				
-- 				arr[1][1] .editablepoly.setselection #face #{faceNum}
				
				-- get edge
					-- return edge relative to face
				edgeList = polyop.getFaceEdges  arr[1][1] faceNum 
				print edgeList
					-- get one position by edge
						-- get positon impact
						-- get dir from edge


						-- define ray from impact point with edge orientation
						-- create plane from edge
						-- intersect the two ray
						-- return pos
					-- calculate distance to edge
					-- select nearest edge
					
				-- get edge portion
			)
			
			 
		)
	)
	
	
	
	fn edgeToVector sel edgeNum =
	(
		local vertArr = polyop.getEdgeVerts sel edgeNum
		vertPosAr = for v in vertArr collect (in coordsys world (polyop.getVert sel v))
		vector = normalize(vertPosAr[1] - vertPosAr[2])
		return vector
	)
	

	
	tool insertLoop
	(
		on mousePoint clickno do
		(
			local sel = $
-- 			print clickno
			if clickno == 1 do 
			(
				local edgeId = undefined
				
				local tmpEdgeSel = (polyop.getEdgeSelection  sel) as array
				edgeId = tmpEdgeSel[1]
				print edgeId
				
				-- on edge selected
				local bak = subobjectlevel 
				local myRay = mapScreenToWorldRay viewPoint
				local res = intersectDef sel myRay
			
				subobjectlevel = bak

				-- get positon impact
				local impactPos = res[1].pos
				-- get direction impact
				local normalVector = res[1].dir
				
				-- get vertices from edge
				local vertArr = polyop.getEdgeVerts sel edgeId
				-- get vertices position
				local vertPosAr = for v in vertArr collect (in coordsys world (polyop.getVert sel v))
				
				local planeSize = distance vertPosAr[1] vertPosAr[2]
				-- get dir from edge
				local edgeDir = normalize(vertPosAr[1] - vertPosAr[2])
				
				-- define ortho vector
				local missingVector = cross normalVector edgeDir

	-- 			point axistripod: true pos: impactPos dir: missingVector
				
				-- create plane from edge
				local edgePlane = plane pos: vertPosAr[1] dir: missingVector   length: (planeSize*2) width:  ( planeSize*2) backfacecull: true
				converttomesh edgePlane
					
				-- define ray
				local dirPoint = point pos: impactPos dir: missingVector axistripod: true 
				-- intersect the plane and ray
				local newRay = ray impactPos (missingVector*-1)
				local intersect = intersectRayEx edgePlane newRay
				if intersect == undefined do 
				(
					newRay = ray impactPos (missingVector)
					intersect = intersectRayEx edgePlane newRay
				)
-- 				delete edgePlane
-- 				delete edgePlane
				
				if intersect != undefined then
				(
					print vertPosAr[1]
					print intersect[1].pos
					
					-- calculate proportion on edge 
					dist1 = distance vertPosAr[1] intersect[1].pos
					dist2 = distance vertPosAr[2] intersect[1].pos
					dist = dist1 + dist2
					midDist = dist/2
					slideSize = midDist - dist1
					slideVal = (slideSize/midDist)*100
					
					print slideVal
					
					select sel
					subobjectlevel = 2
					-- set connect parameters
					PolyToolsSelect.ring()
					sel.connectEdgeSegments   = 1
					sel.connectEdgeSlide = slideVal
					sel.editablepoly.previewBegin #connectEdges

					-- select edge ring
					-- preview connect
		-- 			 $.previewBegin #ConnectEdges 
					print "done"
				)
				else
				(
				 print "no impact"
				)
			)
			
			if clickno == 1 do 
			(
				sel.editablepoly.previewAccept() 
			)
			
		)
	)
		
-- 	fn insertloop poly edge prop =
-- 	(
-- 		print "youpi"
-- 	)
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
					if obj[1] != sourceObj do
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
			
			if mButton == true do
			(
				print "youpi"
			)
			
			if shiftKey == true do
			(
				undo on
				(
					copy sourceObj
				)
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
	-- 			print arr
				
				local viewMatrix =  Inverse(viewport.getTM())
				local viewPos = viewMatrix.pos
				local nearestDist = 1000000
				local goodRes = undefined
				
				if arr.count>0 do	
				(				
					for obj in arr do
					(
						if obj[1] != sourceObj do
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

	group "snapping tool:"
	(
		button resetBT "R" across: 2
		button addBT "add>>" 
		editText selET  readonly: true
		checkbutton placeObjBT "snapping object" enabled: false
	)
	button selEdgeBT "sel edge (wip)"
	button insertEdgeBT "insert loop"
	button testMoveBT "test move"
	
	fn refreshUI =
	(
		if sourceObj != undefined then 
		(
			selET.text = sourceObj.name
			placeObjBT.enabled = true
		)
		else  
		(
			selET.text = ""
			placeObjBT.enabled = false
		)
	)
	
	on placeObjBT changed state do
	(
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool
			)
			placeObjBT.state = false
		)
	)
	
	on addBT pressed do
	(
		sel = selection as array
		if sel.count > 0 do
		(
			sourceObj = sel[1]
		)
		refreshUI()
	)
	
	on resetBT pressed do
	(
		sourceObj = undefined
		refreshUI()
	)
	
	on selEdgeBT pressed do
	(
		starttool selectEdgeTool
	)
	
	on insertEdgeBT pressed do
	(
		continueTool = true
		while continueTool == true do
		(
			print continueTool
			continueTool = starttool insertLoop
		)
	)
	
	on testMoveBT pressed do
	(
		starttool testTool
	)
)
createdialog testtoolRLT
