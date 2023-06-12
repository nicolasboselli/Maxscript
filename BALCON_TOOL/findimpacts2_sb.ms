
-- travailler les impacts sur chaque objet
fn findImpacts2 s shift: 50 shiftz: 50 = 
(
-- 	local rayPreCount = calculateRays s shift: shift shiftz: shiftz
	
	format "############ IMPACTS s: % shift: % shiftZ: % ###########\n" s.name shift shiftZ
-- 	shift = 50
	local rayCount = 0
	
	impactCount = 0
	noImpactCount = 0
		
	grpImpAr = #()
	
	local allImpAr = #()

	for xval = (s.min.x - (shift/2)) to (s.max.x + (shift/2)) by shift do
	(
		for yval = (s.min.y - (shift/2)) to (s.max.y + (shift/2)) by shift do
		(
			local zval = 10000
			local testZ = true
			local testZturn = 0
			while testZ do
			(
				rayCount += 1
				testZturn += 1
				
				Zray = ray (point3 xval yval zval) (point3 0 0 -1)
				
				-- s'il y a un point en dessous 
				resZ = intersectRay s Zray
				
				if resZ != undefined then
				(
					impactCount += 1
					zval = resZ.position.z - 100
					
-- 					format "rayCount: % resZ: % testZturn: %\n" rayCount resZ testZturn
					appendifunique allImpAr resZ.position
				)
				else
				(
					noImpactCount += 1
					testZ = false
-- 					format "rayCount: % resZ: % testZturn: %\n" rayCount resZ testZturn
					exit
				)
				
				-- exit d'urgence
				if testZturn > 10 then
				(
					format "Fail! res: % testZturn: %\n" resZ.position testZturn
					exit
				)
			)
		)
	)	

	format "rayCount: %\n" rayCount
	format "allImpAr :%\n" allImpAr.count
	
	format "impactCount :%\n" impactCount
	format "noImpactCount: %\n" noImpactCount
	
	allImpAr
)

allImps = #()
allImps = findImpacts2 $Object002

pts_to_del = for o in allImps collect point position: o
	
/*
for o in pts_to_del do delete o
*/