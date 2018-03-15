-- maj: ignore hidden object


try(destroyDialog testtoolRLT)catch()

rollout testtoolRLT "test tool"
(
	
	local sourceObj = undefined
	local rootObj = undefined
	local targetObj = undefined
	
	-- tools
	tool placeObjTool
	(

		on mousePoint clickno do
		(
-- 			print clickno
			local myRay = mapScreenToWorldRay viewPoint
-- 			print myRay
			local arr = intersectRayScene myRay
-- 			print "===="
			print arr
			
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
				print arr
				print "ploufe"
				
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
	
	--UI
	group "snapping tool:"
	(
		checkbutton placeObjBT "snapping root" enabled: false
		checkbutton placeTgtBT "snapping target" enabled: false
	)
	
	
	-- UI relative functions

	
	-- actions
	on testtoolRLT open do
	(
		
		rootObj = point()
		targetObj = point()
		targetObj.parent = rootObj
		
		if rootObj != undefined and targetObj != undefined then
		(
			placeObjBT.enabled = true
			placeTgtBT.enabled = true
		)
	)
	
	on testtoolRLT close do
	(
		try
		(
			delete rootObj
			delete targetObj
		)catch()
	)
	
	on placeObjBT changed state do
	(
		bakParent = targetObj.parent
		targetObj.parent = undefined
		sourceObj = rootObj
		
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool
			)
			placeObjBT.state = false
		)
		
		targetObj.parent = bakParent
	)
	
	on placeTgtBT changed state do
	(
		bakParent = targetObj.parent
		targetObj.parent = undefined
		sourceObj = targetObj
		
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool
			)
			placeTgtBT.state = false
		)
		
		targetObj.parent = bakParent
		
	)
)
createdialog testtoolRLT