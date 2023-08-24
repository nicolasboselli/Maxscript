vrbmpAr = getclassinstances VRayBitmap target: scenematerials
-- vrbmpAr[1].Bitmap
i = 1
for b in vrbmpAr do
(
	
	if not doesfileexist b.Bitmap then
	(
		format "missing filename: %\n" b.filename
-- 		refdep = refs.dependents b  -- immediateOnly: true
-- 				meditmaterials[i] = b
		
		i +=1
		
/* 		for d in refdep do
		(
-- 					format "d: % classof: %, i:%\n" d (classof d) i
			if classof d == vraymtl then 
			(
				format "d: % classof: %, i:%\n" d (classof d) i
				if i < 24 then
				(
					meditmaterials[i] = d
					i += 1
				)
			)
		) */
	)
	else
	(
		format "filename: %\n" b.Bitmap
	)
)

autodesk_map_ar = getClassInstances Autodesk_Map target: scenematerials 
