-- clean modifiers
for s in selection do
(
	for m in s.modifiers do
	(
		if classof m == turbosmooth do
		(
	-- 		toDel = m
			deleteModifier s m
			format "turbosmooth: %\n" s.name
		)
		
		if classof m == MeshSmooth do
		(
	-- 		toDel = m
			deleteModifier s m
			format "MeshSmooth: %\n" s.name
		)
		
		if classof m == UVWMap do
		(
	-- 		toDel = m
-- 			deleteModifier s m
			format "UVWMap: %\n" s.name
		)
		
		if classof m == symmetry do
		(
	-- 		toDel = m
-- 			deleteModifier s m
			format "symmetry: %\n" s.name
		)
		
	)
)



-- for m in scenematerials do print m
-- remove raytrace
rayTraceAr = #()
for r in getClassInstances  raytrace do
(
	format "Name : %,  Affected Nodes : %\n" r.name (refs.dependentNodes r)
-- 	instanceReplace r undefined
	for d in refs.dependents r do
	(
-- 		format "Affected Nodes : %\n" d 
		if classof d == standard or  classof d == vraymtl then
		(
			append rayTraceAr d
			format "Affected Nodes : %\n" d 
		)
	)
)
for i = 1 to rayTraceAr.count where i < 24 do meditMaterials[i] =   rayTraceAr[i]

--
matAr = for m in scenematerials collect m 

count = 0
for mat in matAr do
(
	if classof mat == Multimaterial then
	(
		for m in mat do
		(
			if m != undefined do
			(
				append matAr m
-- 				format "name:%, class:%\n" m.name (classof m)
			)
		)
	)
	else if classof mat == standard then
	(
		count += 1
		if count <= 24 then 
		(
			format "EDIT: name:%, class:%\n" mat.name (classof mat)
			meditMaterials[count] = mat
		)
		else format "OUT: name:%, class:%\n" mat.name (classof mat)
	)		
	else format "VALID: name:%, class:%\n" mat.name (classof mat)
)





