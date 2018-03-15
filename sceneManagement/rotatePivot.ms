-- rotate pivot on y axis with 90 degree

-- rotate object 
fn rotatePivot s xVal yVal zVal =
(
	in coordsys local rotate s (eulerangles xVal yVal zVal)
	-- rotate object offset
	bakRot = s.objectoffsetrot 
	s.objectoffsetrot = bakRot + ((eulerangles (xVal*-1) (yVal*-1) (zval*-1)) as quat)
)

-- rotatePivot $ 0 90 0
try (destroydialog reorientatorRLT )catch()
rollout reorientatorRLT "RE-ORIENTATOR"
(
	function reorient xval yval zval pivotOnly =
	(
		sel = selection as array
		for s in sel do 
		(
			if pivotOnly then rotatePivot s  xval yval zval
			else in coordsys local rotate s (eulerangles  xval yval zval)
		)
	)
	
	checkbox reorientBT  "reorient pivot only" checked: false
	group "x:"
	(
		button xPlus90BT "+90" across: 2
		button xMinus90BT "-90"
	)
	
	group "y:"
	(
		button yPlus90BT "+90" across: 2
		button yMinus90BT "-90"
	)
	
	group "z:"
	(
		button zPlus90BT "+90" across: 2
		button zMinus90BT "-90"
	)
	
-- 	Actions
	on xPlus90BT pressed do 		reorient 90 0 0 reorientBT.state
	on xMinus90BT pressed do 	reorient -90 0 0 reorientBT.state
	on yPlus90BT pressed do 		reorient  0 90 0 reorientBT.state
	on yMinus90BT pressed do 	reorient  0 -90 0 reorientBT.state
	on zPlus90BT pressed do 		reorient  0 0 90 reorientBT.state
	on zMinus90BT pressed do 	reorient  0 0 -90 reorientBT.state
	
)
createdialog reorientatorRLT