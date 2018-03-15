-- create root
nameAr = filterString  maxFileName "_"
basename = nameAr[1] + "_" + nameAr[2]

ptRoot = point name: (basename + "_ROOT") wirecolor: (color 14 255 2)  size: 50 box: on cross: off axistripod: off centermarker: off
ptParent = point name: (basename + "_Parent_CTRL") wirecolor: (color 225 198 87) size: 50 box: off cross: on axistripod: off centermarker: off

ptParent.parent = ptRoot


--  create point in center of vertices loop
sum = 0
vxAr = (polyop.getVertSelection $) as array
for v in vxAr do
(
	sum += polyop.getVert $ v
)
midPos = sum/vxAr.count

point pos: midPos cross: true box: false axistripod: false


-- get edge orient
s = $
edgeNum = ((polyop.getEdgeSelection s) as array)[1]
for s in selection do
(
	-- polyop.setedgeSelection #{157}
	-- edgeSel = (polyop.getEdgeSelection s) as array
	vxAr = polyop.getEdgeVerts s edgeNum
	vecX = normalize ((polyop.getVert s vxAr[1]) - (polyop.getVert s vxAr[2]))
	-- pos = ((polyop.getVert s vxAr[1]) + (polyop.getVert s vxAr[2]))/2
	pos = s.center
	
	local sum =[0,0,0]
	faceNum = polyop.getEdgeFaces  s edgeNum
	for f in facenum do 	sum += (polyop.getfacenormal s f)
	
-- 	vecY = normalize (cross vecX [0,0,1])
-- 	vecZ = normalize (cross vecX vecY)
	
	vecZ = normalize sum
	vecY = normalize (cross vecX vecZ)

	pt = point cross: off box: off axistripod: true
	pt.transform = (matrix3 vecX vecY vecZ pos)

-- 	s.parent = pt
-- 	resetxform s
-- 	delete pt
-- 	converttopoly s
)



