struct planSTR 
(
	path,

	fn checkinscene  =
	(
		local inscene = False
		for mat in scenematerials do 
		(
			bitMapFile = undefined
			try
			(
				bitMapFile = mat.diffuseMap.bitmap.filename
			)
			catch
			(
				bitMapFile = undefined
			)
			
			if bitMapFile != undefined do
			(
				if  mat.diffuseMap.bitmap.filename == path do
				(
					inscene =  true
					break
				)
			)
		)
		return inscene
	),
		
	inscene = checkinscene(),
	
	fn checkname =
	(
		print inscene
		local basename = getFilenameFile path
		if inscene == true then
		(
			return ("LOADED___" + basename)
		)
		else
		(
			return basename
		)
	),

	name = checkname()
	
)

test = planSTR "J:\_svn\scenesis\46_asnieres\plans_jpg\TOIT-50.jpg" 

print test

