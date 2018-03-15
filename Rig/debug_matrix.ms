fn createBoxOrient2 s =
(
	faceSel = polyop.getfaceselection s 
	posObj = s.pos
	posCenter = polyop.getFaceCenter s (faceSel as array)[1]
	theZ = polyop.getFaceNormal s (faceSel as array)[1]
	for i = 1 to theZ.count do theZ[i] = round_to theZ[i] 4
		
	theY = normalize (cross [0,0,1] theZ )
	theX = normalize (cross theY theZ)
	theTM = matrix3   theX theY theZ posCenter

	rep = box transform: theTM
)

s = $
faceSel = polyop.getfaceselection s 
posObj = s.pos
posCenter = polyop.getFaceCenter s (faceSel as array)[1]
theZ = polyop.getFaceNormal s (faceSel as array)[1]
-- for i = 1 to theZ.count do theZ[i] = round_to theZ[i] 4
	
theY = normalize (cross [0,0,1] theZ )
theX = normalize (cross theY theZ)
theTM = matrix3   theX theY theZ posCenter

rep = box transform: theTM


theZ = [0,-1,-1.13724e-05]
theZ = [0, 1, 1.13724e-05]
theZ = [0, 1, 1.73724e-05]
theZ = [-1.94716e-07,1,0]
theZ = [0,1,-1.94716e-05]
theZ = [-1.13724e-05,-1,0]
theZ = [-1.13724e-05,-1,0]

theZ = [1.25e-05,1,1.25e-05]
-- theZ = [1,1.74046e-05,0]
-- theY = normalize (cross [0,0,1] theZ )
-- theX = normalize (cross theY theZ)
-- theTM = matrix3   theX theY theZ [0,0,0]
theTM = matrixfromnormal theZ
box transform: theTM


$.rotation.x_rotation = 90.0001
$.rotation.x_rotation = 90
$.transform.row3
$.transform = matrix3 1

$.transform
$.rotation = (quat 0 0 0 1)

$.scale == [1,1,1]