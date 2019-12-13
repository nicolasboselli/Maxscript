-- descente gouttiere creator
-- maj:
	-- creer une descente de gouttiere apres cahque knot
	-- rendre le declage editable

masse = $masse3

l = $
spCount = numSplines l
pointList = #()
l.name
s = splineShape() --create a spline shape

for sp = 1 to spCount do
(
	local knotCount = numKnots l sp
	
		-- decalage
	local Xshift = 50	
		
	local Yshift1 = -10
	local Yshift2 = 20
		
	local Zshift1 = 10
	local Zshift2 = -10
	local Zshift3 = -20
	
	local Pt1pos = [Xshift, Yshift1, Zshift1]
	local Pt2pos = [Xshift, Yshift1, Zshift2]
	local Pt3pos = [Xshift, Yshift2, Zshift3]
	
	
	for k = 1 to (knotCount ) do
	(	
		format "sp: % knot: %\n" sp k
-- 		local k1 = k
		local k2 = k + 1
		
		-- sur une spline fermée quand on arrive au dernier point repartir vers 1
		if k == knotCount then if isClosed l  sp then   k2 = 1 else continue
		
		local knotPos = getKnotPoint l sp k
		
		-- direction de la spline	
		local dirZ = [0,0,1]
		local dirX = normalize ((getKnotPoint l sp (k2)) - (getKnotPoint l sp k))
		local dirY = normalize (cross dirZ dirX)
			
		local TM = matrix3 dirX dirY dirZ knotPos
		
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


