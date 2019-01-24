-- descente gouttiere creator
-- maj:
	-- creer une descente de gouttiere apres cahque knot
	-- rendre le declage editable

masse = $masse

l = $
spCount = numSplines l
pointList = #()
l.name
s = splineShape() --create a spline shape

for sp = 1 to spCount do
(
	local knotCount = numKnots l sp
	
-- 	local newSp = 0
	for k = 1 to (knotCount - 1) do
	(	
		format "sp: % knot: %\n" sp k

		
		local knotPos = getKnotPoint l sp k
		
		-- direction de la spline	
		local dirZ = [0,0,1]
		local dirX = normalize ((getKnotPoint l sp (k+1)) - (getKnotPoint l sp k))
		local dirY = normalize (cross dirZ dirX)
			
		local TM = matrix3 dirX dirY dirZ knotPos
		
		-- decalage
		local decayK = 50	
		local shift2 = -10
		local shift3 = 5
		
		local Pt1pos = [decayK, shift2, 10]
		local Pt2pos = [decayK, shift2, -10]
		local Pt3pos = [decayK, shift3, -20]

		-- tracer un rayon jusqu au sol
		local testRay = ray (Pt3pos * TM) [0,0,-1]
		local masseImpact = intersectRay masse testRay
		
		-- creation des points
		newSp = addNewSpline s

		addKnot s newSp #corner #line  (Pt1pos * TM) 
		addKnot s newSp #corner #line  (Pt2pos * TM) 
		addKnot s newSp #corner #line  (Pt3pos * TM) 
		addKnot s newSp #corner #line  (masseImpact.pos) 
	)
	
)
-- redrawviews()
updateshape s



