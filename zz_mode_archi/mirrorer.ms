

rollout mirrorerRLT "mirrorer"
(
	local sel
	
	fn checkSelFN =
	(
		selTmp = $selection as array
		return selTmp
	)
	button mirrorXBT "X" across:3
	button mirrorYBT "Y"
	button mirrorZBT "Z"
	
	
	on mirrorXBT pressed do
	(
		sel = checkSelFN()
		for s in sel do
		(
			sTmp = s.scale.controller.value
			s.scale.controller.value = [(sTmp.x*-1),sTmp.y,sTmp.z]
		)
	)
	
	on mirrorYBT pressed do
	(
		sel = checkSelFN()
		for s in sel do
		(
			sTmp = s.scale.controller.value
			s.scale.controller.value = [sTmp.x,(sTmp.y*-1),sTmp.z]
		)
	)
	
	on mirrorZBT pressed do
	(
		sel = checkSelFN()
		for s in sel do
		(
			sTmp = s.scale.controller.value
			s.scale.controller.value = [sTmp.x,sTmp.y,(sTmp.z*-1)]
		)
		
	)
)
createdialog mirrorerRLT