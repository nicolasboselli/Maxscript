
/*

maj:
/- placer le premier main plus au centre du balcon, s'appuer sur les coordonnées border
-- mettre un seed sur le placement des objets
-- ajouter une zone de bordure à ignorer pour le main, dissocier la valeur border en deux
-- faire un prévisionnel de la durée du findimpact, précalculer le nombre d'impact à trier, mettre à jour le nombre tiré

*/


-- meshop.getPolysUsingFace newMesh #{impact[2]} ignoreVisEdges: true threshhold: 1.0



-- travailler les impacts sur chaque objet
fn findImpacts s shift: 50 = 
(
	format "############ IMPACTS s: % shift: % ###########\n" s.name shift
-- 	shift = 50
	rayCount = 0
	impactCount = 0
	noImpactCount = 0

	shortDistance = 0
	goodDistance = 0
	longDistance = 0

	grpImpAr = #()
	zval = 10000

	local allImpAr = #()

	for xval = (s.min.x - (shift/2)) to (s.max.x + (shift/2)) by shift do
	(
		for yval = (s.min.y - (shift/2)) to (s.max.y + (shift/2)) by shift do
		(
			for zval = (s.min.z - (shift/2)) to (s.max.z + (shift*2)) by shift do
			(
				rayCount += 1
				oneRay = ray  (point3 xval yval zval) (point3 0 0 -1)
				res = intersectRay s oneRay
				
				-- pour chaque nouvel impact
				if res != undefined then
				(
					impactCount += 1
					local impactPos = res.position
					local grpImpID = 0
					local goodgrpImpID
					local impID = 0
					local goodImpID
					
					-- si c'est le premier impact, collecter
					if allImpAr.count == 0 then 
					(
						append allImpAr impactPos
					)
					else
					-- sinon 
					(
						local minDist = 100000
						local collected = false 
						local soFar = false
						
						-- pour chaque groupe d'impact deja collecter 
						for imp in allImpAr do
						(
	-- 						grpImpID += 1
							
							-- pour chaque impact du groupe d'impact

							impID += 1
							-- calculer la distance entre le nouvel impact et les impact deja collecter
							testDist = distance impactPos imp
							
							-- conserver la distance minimale
							if testDist < minDist then 
							(
								minDist = testDist
	-- 							goodgrpImpID = grpImpID
								goodImpID = impID
							)
						)
						
						-- si la distance minimalle == 0 ne pas collecter
						if minDist <= 5 then
						(
							shortDistance += 1
						)
						else
						(
							appendifunique allImpAr impactPos
						)
					)
				)
				else
				(
					noImpactCount += 1
				)
			)
		)
	)	
	format "allImpAr :%\n" allImpAr.count
	format "rayCount: %\n" rayCount
	format "impactCount :%\n" impactCount
	format "noImpactCount: %\n" noImpactCount
	
	allImpAr
)

-- trouver des bordures des groupes par distance
fn findBorderImpact2 s grpImpAr size: 30 =
(
	format "############ BORDER IMPACTS s: % size: % ###########\n" s.name size

	local goodForDressingAr = #()
	local goodForBorderAr = #()
-- 	local goodForBorderAr2 = #()

	for imp in grpImpAr do
	(
-- 		(
	-- 		format "== start test imp: %\n" imp
			local goodforDessing = false
			local res
			local posTest
		
			for oneAng = 0 to 360 by 45  do
			(
				-- oneAng = 
				shift = point3  (cos oneAng) (sin oneAng) 1
				shift = shift * ( point3 (size*2) (size*2) 50)
			
				posTest = imp + shift

				oneRay = ray  posTest (point3 0 0 -1)

				local res = intersectRay s oneRay
				
				if res == undefined then 
				(
	-- 				format "oneRay: % res: %\n" oneray res
					goodforDessing = false
					exit
				)
				else if res.position.z != imp.z then 
				(
-- 						format "res.position.z: % imp.z: %\n" res.position.z imp.z
					goodforDessing = false
					exit
				) 
				else 
				(
					goodforDessing = true
				)
			)
			
			if goodforDessing then
			(
				append goodForDressingAr imp
			)
			else
			(
				append goodForBorderAr  imp
			)
-- 		)
	)
	
-- 	format "goodForDressingAr: %\n" goodForDressingAr
	#(goodForDressingAr, goodForBorderAr)
	
)

-- classement des impacts dans des groupes par distance
fn sortByGroup allImpAr shift: 50 =
(
	format "############ GROUPE IMPACTS ###########\n"
	local grpImpAr = #()
	if grpImpAr.count == 0 then 
	(
		append grpImpAr #(allImpAr[1])
		idToDel = finditem allImpAr grpImpAr[1][1]
		deleteitem allImpAr idToDel
	)
	
	turn = 0
	for grpImp in grpImpAr do
	(
		turn += 1
		-- impactCollected = false
		
		lastImp2 = undefined
		for imp in grpImp do
		(
			
			for imp2 in allImpAr do
			(
				testDist = distance imp imp2
				if testDist <= (shift + 1) then
				(
					-- ajouter dans le grpimp
					append grpImp imp2
					
					-- enlever de allImpAr
					idToDel = finditem allImpAr imp2
					deleteitem allImpAr idToDel
				)
			)	
		)
		
		-- si il y a un transfer répéter l'opération
		-- s'il n'y a plus de collecte 
		-- création d'un nouveau groupe s'il n'y a pas de nouvelle collecte
		
		if allImpAr.count > 0 then append grpImpAr #(allImpAr[1])
		if turn > 200 then 
		(
			format "turn > 200 : exit!\n"
			exit
		)
	)
	format "grpImpAr.count: %\n" grpImpAr.count
	grpImpAr
)

-- dans les positions collectées pour le dressing 
fn distImpact goodForDressingAr size2: 80 multi2: 2 = 
(
	format "############ DISTANCES IMPACTS ###########\n"
	local perfectForDressingAr = #()
	superTurn = 0
-- 	size2 = 80
-- 	multi2 = 2

	for oneForDressing in goodForDressingAr do
	(
		superTurn += 1
-- 		format "\n################ superTurn: % ############\n" superTurn
		if oneForDressing.count > 0 then 
		(
			onePerfectAr = #(oneForDressing[1])
			deleteitem oneForDressing 1
		)
		else
		(
-- 			format "oneForDressing: %\n" oneForDressing
			continue
		)
		turn = 0
		
		for onePerfect in onePerfectAr do
		(
			turn += 1
			
-- 			format "################ turn: % ############\n" turn
			minDist = 10000
			local nextPerfect = undefined
			
			for oneGood in oneForDressing do
			(		
	-- 			format "onePerfect: % oneGood: %\n" onePerfect oneGood
				testDist = distance onePerfect oneGood

				-- suppression des points trop prêts
				if testDist < (size2*multi2) then
				(
					toDel = finditem oneForDressing oneGood
					deleteitem oneForDressing toDel
					
	-- 				format "delete oneGood: %\n" oneGood 
				)
				-- collecter le point le plus prêt
				else if testDist < minDist and  testDist >= (size2*multi2) then
				(		
					reallyGood = true
					nextPerfectCandidat = oneGood
					for o in onePerfectAr do
					(
						testdist2 = distance o nextPerfectCandidat
						if testdist2 < (size2*multi2) then
						(		
							reallyGood = false
							exit
						)
					)
					
					if reallyGood then
					(
						nextPerfect = oneGood
						minDist = testDist
	-- 					format "update nextperfect minDist: % nextPerfect: %\n" minDist nextPerfect
					)				
				)
				else(/*format "ignore oneGood: % \n" oneGood*/)
			)
			
			
			if iskindof nextPerfect point3 then
			(
				append onePerfectAr nextPerfect

				toDel = finditem oneForDressing nextPerfect
				deleteitem oneForDressing toDel
-- 				format "Final onePerfectAr: % minDist: % nextPerfect: %\n" onePerfectAr minDist nextPerfect
			)
		)
		append perfectForDressingAr onePerfectAr
	)
	perfectForDressingAr
)

-- déroulé
try(destroydialog BalconizerRLT)catch()
rollout BalconizerRLT "Spline BalconIzer v.alpha"
(
	local allImpAr = #()
	local twoArrays = #(#(),#())
		
	local newShape 
	local newShapeBorder
	
	group "settings:" 
	(
		spinner ImpactShiftSP "Impact Shift:" type: #worldunits range: [0,500,30]
		spinner borderRadiusSP "Border Radius:" type: #worldunits range: [0,500,50]
		spinner mainRadiusSP "Main Density:" type: #worldunits range: [0,500,150]
		spinner borderDensitySP "Border Density:" type: #worldunits range: [0,500,150]
	)
		
	group "Create Splines:"
	(
		button createMainHelperBT "Main / Table "
		button createBorderHelperBT "Borders / Pots"
	)
	
	group "Merge FP"
	(
		button mergeBT "Merge"
	)

	
	on createMainHelperBT pressed do
	(
		-- s = $
		sel = selection as array
		for s in sel do
		(
			-- recherche des impacts
			allImpAr += findImpacts s shift: ImpactShiftSP.value
			
			-- tri des impacts entre border et main
			NewtwoArrays = findBorderImpact2 s allImpAr size: borderRadiusSP.value
			twoArrays[1] += NewtwoArrays[1]
		)
		
		-- mise en groupe guide creation
		MainGrpImpAr = sortByGroup twoArrays[1] shift: ImpactShiftSP.value
		
		-- test des distances
		perfectForDressingAr = distImpact MainGrpImpAr size2: mainRadiusSP.value
		
		-- creation de la spline dressing
		try(delete newShape)catch()
		newShape = splineShape wirecolor: red name: (Uniquename "balcon_main_FP_guide_")
		for grpImp in perfectForDressingAr do
		(
			for imp in grpImp do 
			(
				num = addNewSpline newShape
				
				addKnot newShape num #corner #line imp
				addKnot newShape num #corner #line (imp + (point3 100 0 0))
			)
		)
		updateShape newShape
		redrawViews()
	)
		
	on createBorderHelperBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			-- recherche des impacts
			allImpAr += findImpacts s shift: ImpactShiftSP.value
			
			-- tri des impacts entre border et main
			NewtwoArrays = findBorderImpact2 s allImpAr size: borderRadiusSP.value
			twoArrays[2] += NewtwoArrays[2]
		)
		
		BorderGrpImpAr = sortByGroup twoArrays[2] shift: ImpactShiftSP.value
		
		-- selection des impacts à une certaine distance les uns des autres 
		perfectForBorderAr = distImpact BorderGrpImpAr size2: borderDensitySP.value
		
		-- creation de la spline border
		try(delete newShapeBorder)catch()
		newShapeBorder = splineShape wirecolor: green (Uniquename "balcon_border_FP_guide_")
		for grpImp in perfectForBorderAr do
		(
			for imp in grpImp do 
			(
				num = addNewSpline newShapeBorder
				local imp2
				
/* 				oneAng = random 0 360 
				shift = point3 (cos oneAng) (sin oneAng) 0
				shift = shift * ( point3 50 50 50) */
				
-- 				posTest = imp + shift
							
				addKnot newShapeBorder num #corner #line imp
-- 				addKnot newShapeBorder num #corner #line posTest
				addKnot newShapeBorder num #corner #line (imp + (point3 100 0 0))
			)
		)
		updateShape newShapeBorder
		redrawViews()
	)
	
	on mergeBT pressed do
	(
		mergeMAXFile  @"M:\Elements_batiments\Amenagement perspectives\Forest_Tables et pots Aleatoire.max"
	)
)
createdialog BalconizerRLT


