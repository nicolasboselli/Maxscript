/*
maj:
- tester la creation d'un objet correctement orienté en z au point d'impact
- la selection de sous objet au point d'impact(face, edge, spline...)
- prendre en charge les categories objets caché par raccourcis(geometry, spline, lights)
- prendre en charge les spline

snapMode.hitPoint 
snapMode.node 

*/


try(destroydialog testPickerRLT)catch()
rollout testPickerRLT "Test Picker"
(
	local goodRes
	
	checkbutton pickCB "pick"
	
	tool testTool
	(
		on mousePoint clickno do
		(
			local myRay = mapScreenToWorldRay viewPoint
			local arr = intersectRayScene myRay
			
			local viewMatrix =  Inverse(viewport.getTM())
			local viewPos = viewMatrix.pos
			local nearestDist = 1000000
			goodRes = undefined
				
			if arr.count>0 do	
			(				
				for obj in arr where not obj[1].ishidden do
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
			format "goodRes: %\n" goodRes
			format "hitPoint: %\n" snapMode.hitPoint 
			format "node: %\n" snapMode.node 
			
		)
	)
	
	on pickCB changed state do
	(
		if state do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool testTool
			)
			pickCB.state = false
		)
	)
)
createdialog testPickerRLT