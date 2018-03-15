-- descente gouttiere creator

masse = $masse

l = $
spCount = numSplines l
pointList = #()
l.name
s = splineShape() --create a spline shape

for sp = 1 to spCount do
(
	addNewSpline s

	local knotPos = getKnotPoint l sp 1
	
	-- direction de la spline	
	local dirZ = [0,0,1]
	local dirX = normalize ((getKnotPoint l sp 2) - (getKnotPoint l sp 1))
	local dirY = normalize (cross dirZ dirX)
		
	local TM = matrix3 dirX dirY dirZ knotPos
		
	local Pt1pos = [10, -10, 10]
	local Pt2pos = [10, -10, -10]
	local Pt3pos = [10, 35, -20]

	-- tracer un rayon jusqu au sol
	local testRay = ray (Pt3pos * TM) [0,0,-1]
	local masseImpact = intersectRay masse testRay
	
	-- creation des points
	addKnot s sp #corner #line  (Pt1pos * TM) 
	addKnot s sp #corner #line  (Pt2pos * TM) 
	addKnot s sp #corner #line  (Pt3pos * TM) 
	addKnot s sp #corner #line  (masseImpact.pos) 
	
)
updateshape s



