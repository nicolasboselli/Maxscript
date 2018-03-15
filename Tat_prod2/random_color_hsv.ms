

	clearlistener()
	try (destroydialog RandomWirecolorHSV) catch()
	
	rollout RandomWirecolorHSV "Random Wirecolor HSV"
	(	label huelabel "Hue Range" align:#left across:3
		spinner spn_huelow  range:[0,255,0] type:#integer width:40 align:#right
		spinner spn_huehigh range:[0,255,255] type:#integer width:40 align:#right
		
		label satlabel "Sat Range" align:#left across:3
		spinner spn_satlow range:[0,255,0] type:#integer width:40 align:#right
		spinner spn_sathigh range:[0,255,255] type:#integer width:40 align:#right
		
		label vallabel "Val Range" align:#left across:3
		spinner spn_vallow range:[0,255,0] type:#integer width:40 align:#right
		spinner spn_valhigh range:[0,255,255] type:#integer width:40 align:#right
		
		button btn_randomise "Randomise selected"
		
		fn checkLow &lowVal &highVal =
		(	if lowVal > highVal do
			(	highval = lowval
			)
		)	
			
			fn checkHigh &lowVal &highVal =
		(	if lowVal > highVal do
			(	lowval = highval
			)
		)
			
		on spn_huelow changed huelowval do
		(	checkLow &spn_huelow.value &spn_huehigh.value
		)
			
		on spn_huehigh changed huehighval do
		(	checkHigh &spn_huelow.value &spn_huehigh.value
		)
			
		on spn_satlow changed satlowval do
		(	checkLow &spn_satlow.value &spn_sathigh.value
		)
			
		on spn_sathigh changed sathighval do
		(	checkHigh &spn_satlow.value &spn_sathigh.value
		)
			
		on spn_vallow changed vallowval do
		(	checkLow &spn_vallow.value &spn_valhigh.value
		)
			
		on spn_valhigh changed valhighval do
		(	checkHigh &spn_vallow.value &spn_valhigh.value
		)
			
		on btn_randomise pressed do
		(	for i in selection do 
			(	hue = (random spn_huelow.value spn_huehigh.value)
				sat = (random spn_satlow.value spn_sathigh.value)
				val = (random spn_vallow.value spn_valhigh.value)
				tempColor = color 0 0 0
				tempColor.v = val
				tempColor.s = sat
				tempColor.h = hue
				i.wirecolor = tempColor
		
			)
		)
	)
		
		
	createdialog RandomWirecolorHSV 185 92
	
	
tmpColor = color 0 0 0
tmpColor.h = 50
tmpColor.saturation = 150
tmpColor
$.wirecolor = tmpColor

$.wirecolor = val1

meditmaterials[activeMeditSlot ].diffuse.h = 150
meditmaterials[activeMeditSlot ].diffuse.v = 120
meditmaterials[activeMeditSlot ].diffuse.s = 150
