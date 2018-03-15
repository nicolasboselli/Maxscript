faceSel = polyop.getfaceselection $ 
posObj = $.pos
posCenter = polyop.getFaceCenter $ (faceSel as array)[1]
theZ = polyop.getFaceNormal $ (faceSel as array)[1]
theY = normalize (cross [0,0,1] theZ )
theX = normalize (cross theY theZ)
theTM = matrix3   theX theY theZ posCenter
-- theTM.scale = [1,1,1]

-- $.transform = theTM


rep = box transform: theTM

fn pivotOnFAce s = 
(

	posCenter = s.center

	theX = normalize ((polyop.getFaceNormal s 1)*-1)
	theY = normalize (cross [0,0,1] theX )
	theZ= normalize (cross theX theY)
	localTM = matrix3   theX theY theZ posCenter

	s.transform = localTM
	
	addmodifier s (xform ())

	s.modifiers[#xform].gizmo.rotation = in coordsys local localTM.rotation
	s.modifiers[#xform].gizmo.position = (in coordsys local s.center)* -1
)
pivotOnFAce $

