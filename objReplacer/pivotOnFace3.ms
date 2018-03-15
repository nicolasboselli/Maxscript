fn pivotOnFAce3  s normal: 1 flipNormal: true upnode: 3 flipUpnode: false = 
(
-- 	local copyS = copy s
-- 	format "\n\n################:%\n" s.name
	
-- 	local copyS = copy s
	
	local theX, theY, theZ
	local invNormal, invUpnode
	local theOrder = #(0,0,0)
	
	local theRest = #{1,2,3} - #{normal, upnode}
	local theRestAr = theRest as array
	local Other = theRestAr[1]
	
	if flipNormal then invNormal = -1 else invNormal = 1
	if flipUpnode then invUpnode = -1 else invUpnode = 1
	
	local posCenter = s.center
	local bakTM = s.transform
	
	theNormal = normalize ( ( polyop.getFaceNormal s 1) * invNormal )
	theOther = normalize ( cross   ( [0,0,1] * invUpnode ) theNormal)
	theUpnode= normalize ( cross theNormal theOther )
	
	theOrder[normal] = theNormal
	theOrder[Other] = theOther
	theOrder[upnode] = theUpnode
	
	local localTM = matrix3   theOrder[1] theOrder[2] theOrder[3] posCenter
	
	s.transform = localTM
	
	addmodifier s (xform ())
	s.modifiers[#xform].gizmo.transform = bakTM * inverse(localTM)
)

undo on
(
	sel = selection as array
	for s in sel do pivotOnFAce3  s normal: 2 flipNormal: false upnode: 1 flipUpnode: false 
)
