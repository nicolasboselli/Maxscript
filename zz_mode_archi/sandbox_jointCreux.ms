
edgeSel1
edgeSel2

if polyop.inSlicePlaneMode $ then
(
	baseRay = polyop.getSlicePlane $ size:&raySize
	
	polyop.slice $ #all baseRay
	edgeSel1 = polyop.getEdgeSelection $
	
	baseRay.position.z += -4
	
	polyop.slice $ #all baseRay
	edgeSel2 = polyop.getEdgeSelection $
		
	polyop.setSlicePlane $ baseRay raySize
	redrawViews ()
)
edgeSel2 = edgeSel2 - edgeSel1

face1= #()
for i in edgeSel1 do 
(
	faces =  polyop.getEdgeFaces $ i
	format "edge: %, faces: %\n" i faces
	for f in faces do appendifunique face1 f
)

face2= #()
for i in edgeSel2 do 
(
	faces =  polyop.getEdgeFaces $ i
	format "edge: %, faces: %\n" i faces
	for f in faces do appendifunique face2 f
)

format "face1: %\n" face1
format "face2: %\n" face2

lastSel = #()

for f in face1 do
(
	res = finditem face2 f
	format "res:%\n" res
	if res > 0 then append lastSel f
)
format "lastSel: %\n" lastSel

-- ignore open edge
openedgesAr = polyop.getOpenEdges $
openfaces = #()

for i in openedgesAr do 
(
	faces =  polyop.getEdgeFaces $ i
-- 	format "edge: %, faces: %\n" i faces
	for f in faces do appendifunique openfaces f
)

format "openfaces: %\n" openfaces

for f in openfaces do
(
	res = finditem lastSel f
	if res > 0 then deleteitem lastSel res
)

lastSelBA = lastSel as bitarray

polyop.setEdgeSelection $ #{}
polyop.setFaceSelection $ lastSelBA
subobjectLevel = 4
-- polyop.getEdgeSelection $
redrawViews ()