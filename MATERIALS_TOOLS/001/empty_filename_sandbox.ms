-- testPath = @"T:\CA Immobilier\Sanary sur Mer_0419\Maquette\Cellules\VILLA09\texture\"
-- doesfileexist testPath

-- isFilename = false
fn collectEmptyFilenameBitmap =
(
	bmpAr = getclassinstances bitmaptexture target: scenematerials
	i = 0
	j = 1
	k = 0
	for b in bmpAr do
	(
		local next = false
		i +=1
		local isFilename = true
	-- 	format "%: %\n" i b.filename
		local res = getFilenameType b.filename
		if res.count == 0 then 
	-- 	if not isFilename then format "not filename: %\n" b.filename
		(
			format "%: not filename: %\n" i b.filename
			k +=1
	-- 		format "missing filename: %\n" b.filename
			refdep = refs.dependents b  -- immediateOnly: true
	-- 		meditmaterials[i] = b
			
			for d in refdep do
			(
		-- 					format "d: % classof: %, i:%\n" d (classof d) i
				if superclassof d == material then 
				(
					format "d: % classof: %, i:%\n" d (classof d) j
					if j < 24 then
					(
						meditmaterials[j] = d
						j += 1
					)
					else
					(
						next = true
					)
				)
				if next then exit
			)
		)
		if next then exit
	)
	
	format "total empty filename: %\n" k
)
