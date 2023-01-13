/*
-- 11. placer un plan sur le centre des gabarits et taper dessus avec les normale x 
pour trouver la bonne orientation
*/

sel = selection as array

fn fix180normal sel = 
(
	local centerSum = point3 0 0 0
	for s in sel do centerSum += s.center
		
	local ptfdc = matrix3 1 
	ptfdc.translation = (centerSum /= sel.count)
	
	
	negSel = #()
	for s in sel do
	(
		centerPos = in coordsys s ptfdc.position

		if centerPos.x > 0 then ()
		else if centerPos.x < 0 then append negSel s
	)

	shiftRot = 180.0
	for s in negSel do
	(
		s.transform = prerotate s.transform (EulerAngles 0 0 shiftRot)
		s.objectOffsetRot *= (EulerAngles 0 0 shiftRot)
	)
)

-- fix180normal sel

fn fix180normalOnPoint sel =  
(
	global ptfdc
	local centerSum = point3 0 0 0

	for s in sel do centerSum += s.center

	if not isvalidnode ptfdc do ptfdc = point pos: (centerSum /= sel.count) name: "fenetre_detach_center"

	negSel = #()

	for s in sel do
	(
		centerPos = in coordsys s ptfdc.position
		format "centerPos: %\n" centerPos
		
		if centerPos.x > 0 then ()
		else if centerPos.x < 0 then append negSel s

		-- 	point pos: (point3 centerPos.x 0 0) name: (s.name + "_Xpos")
	)

	-- select negSel

	shiftRot = 180.0
	for s in negSel do
	(
		s.transform = prerotate s.transform (EulerAngles 0 0 shiftRot)
		s.objectOffsetRot *= (EulerAngles 0 0 shiftRot)
	)
)

fix180normalonPoint sel

-- select negSel