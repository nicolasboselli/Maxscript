/* 
-- créer deux torus knot
o1 = $o1
target = $o2

TM = o1.transform
TM.scalepart

-- align x to x and invert
theX = TM.row1
-- align x to y and invert
theX = TM.row2
-- align x to z and invert
the X= TM.row3

-- align y to x and invert
theY = TM.row1
-- align y to y and invert
theY = TM.row2
-- align y to z and invert
theY = TM.row3

theZ = cross theX theY

-- calcul de z, cross
TM2 = matrix3  theX theY theZ TM.row4

-- TM2.scalepart
o2.transform = orthogonalize TM2 

 */

try(destroydialog alignRLT)catch()
rollout alignRLT "align tool"
(
	local sel
	local forbiddenY
	
	local theX, theY, theZ
	local invertX, invertY
	
	-- UI
	radiobuttons theXRB "align X to:" labels:#("X", "Y", "Z") default: 1 across: 2
	checkbox invertXCB "X*-1"
	radiobuttons theYRB "align Y to:" labels:#("X", "Y", "Z") default: 2 across: 2
	checkbox invertYCB "Y*-1" 
	
	button alignBT "align"
	
	-- fn
	fn refreshUI =
	(
		if theYRB.state == forbiddenY then  theYRB.state = 0
	)
	
	--actions
	on theXRB changed arg do
	(
		forbiddenY = theXRB.state
		format "forbiddenY:%\n" theXRB.state
		refreshUI()
	)
	
	on theYRB changed arg do
	(
-- 		forbiddenY = theXRB.state
-- 		format "forbiddenY:%\n" theXRB.state
		refreshUI()
	)
	
	on alignBT pressed do
	(
		sel = selection as Array
		o1 = sel[sel.count]
		
		TM = o1.transform

		-- the X
		if theXRB.state == 1 then
		(
			theX = TM.row1
		)
		else if theXRB.state == 2 then
		(
			theX = TM.row2
		)
		else if theXRB.state == 3 then
		(
			theX = TM.row3
		)
		
		if invertXCB.checked then theX *= -1 
		
		-- the Y
		if theYRB.state == 1 then
		(
			theY = TM.row1
		)
		else if theYRB.state == 2 then
		(
			theY = TM.row2
		)
		else if theYRB.state == 3 then
		(
			theY = TM.row3
		)
		
		if invertYCB.checked then theY =* -1
		
-- 		format "theX: % theY: % \n" theX theY
		-- the Z
		theZ = cross theX theY
		
		TM2 = matrix3  theX theY theZ TM.row4
		
		undo on
		(
			for i = 1 to sel.count - 1 do
			(
				sel[i].transform = TM2
			)
		)
		
	)
)
CreateDialog alignRLT width: 300 

