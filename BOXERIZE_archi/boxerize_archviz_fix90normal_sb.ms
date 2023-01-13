fn fix90Normal s =
(
	local facesNum = getnumfaces s 

	local angleTresh = 5.0
	local goodNorms = #()
	local faceAreaSum = #()
			
	for i = 1 to facesNum do
	(
		
		local minAngle
		local alreadyCollected = false
		
		faceNorm = getFaceNormal s i
		faceArea = meshop.getFaceArea s #{i}
		
					-- 	comparaison de la dernière normale collectée avec les normales deja selectionnées
		for j = 1  to goodNorms.count do
		(		
			-- formule alambiqué pour supprimer le -nan(ind).0
			minAngle = ((((acos(dot goodNorms[j] faceNorm))*100)as integer)as float)/100

			if minAngle <= angleTresh then 
			(
				faceAreaSum[j] += faceArea
				alreadyCollected = true
			)
			
			if alreadyCollected then exit
		)
		
		if not alreadyCollected then 
		(
			append goodNorms faceNorm
			append faceAreaSum faceArea
		)
		else
		(
			
		)
		
	)
	
	local NX = normalize goodNorms[finditem faceAreaSum (amax faceAreaSum)]

	local testAngle = ((((acos(dot NX s.transform.row1))*100)as integer)as float)/100
	format "s: % testAngle: % \n" s.name  testAngle
	
	if  testAngle > 85.0 and testAngle < 95.0 then  
	(
		shiftRot = 90.0
		s.transform = prerotate s.transform (EulerAngles 0 0 shiftRot)
		s.objectOffsetRot *= (EulerAngles 0 0 shiftRot)
-- 		format "s: % shiftAngle: % shiftRot: %\n" s.name shiftAngle shiftRot
		format "s: % testAngle: % \n" s.name  testAngle
	)
)

sel = selection as Array
for s in sel do fix90Normal s


