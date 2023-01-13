sel = selection as Array

fn reorientGabarits sel = 
(
	masterSel = sel[1]
	for i = 2 to sel.count do
	(
		shiftRot = 0.0
		shiftAngle = ((((acos(dot masterSel.transform.row1 sel[i].transform.row1))*100)as integer)as float)/100
		
		if shiftAngle > - 5.0 and shiftAngle < 5.0 then shiftRot = 0.0
		else if shiftAngle > 85.0 and shiftAngle < 95.0 then shiftRot = -90.0
		else if shiftAngle > -95.0 and shiftAngle < -85.0 then shiftRot = 90.0
		else if shiftAngle > 175.0 and shiftAngle < 195.0 then shiftRot = 180.0
		else shiftRot = 0.0
		
		if not shiftRot == 0.0 then  
		(
			sel[i].transform = prerotate sel[i].transform (EulerAngles 0 0 shiftRot)
			sel[i].objectOffsetRot *= (EulerAngles 0 0 shiftRot)
			format "sel[i]: % shiftAngle: % shiftRot: %\n" sel[i].name shiftAngle shiftRot
		)
	)
)	
reorientGabarits sel

allGab = $fenetre_detach* as array
wirecolorByOrientation allGab