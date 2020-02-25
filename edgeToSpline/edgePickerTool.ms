tool edgePickerTool
(
	on mousePoint clickno do
	(
		try
		(
			local minDist = 100000
			local picked
			
			if clickno == 1 then()
			else
			(
				local screenRay = mapScreenToWorldRay viewPoint
	-- 			format "\nmousePoint: %\n" clickno
				local impacts = intersectRayScene screenRay
				for o in impacts where not o[1].ishidden do
				(
					local testDist = distance screenRay.pos o[2].pos
	-- 				format "intersect: % pos: % distance: %\n" o[1].name o[2] testDist
					if testDist < minDist then
					(
						minDist = testDist
						picked = o[1]
	-- 					format "intersect: % pos: % distance: %\n" o[1].name o[2].pos testDist
					)
				)
				
-- 				format "picked: %\n" picked
				if isvalidnode picked then
				(	
					addmodifier picked (edit_mesh())
					local faceImpact = intersectRayEx picked screenRay
					format "faceImpact: %\n" faceImpact[2]
					deleteModifier picked 1
				)
			)
		)
		catch
		(
			format "*** % ***\n" (getCurrentException())
		)
	)
	
	on mouseMove clickno do ()
	
-- 	on mouseAbort clickno do 
-- 	(
-- 		format "mouseAbort:%\n" clickno
-- 	)
	
-- 	on stop do
-- 	(
-- 		format "stop:%\n" clickno
-- 	)
)
starttool edgePickerTool

