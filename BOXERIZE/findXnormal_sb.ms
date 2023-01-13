sel = selection as Array

for s in sel do
(
	facesNum = getnumfaces s 

	angleTresh = 5.0
	goodNorms = #()
	faceAreaSum = #()
			
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

	NX = normalize goodNorms[finditem faceAreaSum (amax faceAreaSum)]

	testAngle = ((((acos(dot NX s.transform.row1))*100)as integer)as float)/100
	
	format "s: % testAngle: % \n" s.name  testAngle
)
