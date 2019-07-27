rollout libMissBmpRLT "Library Missing Bmp Tools"
(
	local altDir =  @"M:\Textures"
	local params = #("open")
	
	group "Library missing bmp Tools:"
	(
		
		button scanLibBT "List Missing BMP" -- across: 2
		edittext libraryPatchET "Alternative Folder:" text: altDir
		button altPathBT "..."
		
		checkbox noAltDisplayCB "no alt display" -- enabled: false 
		checkbox remapLibCB "1 alt remap" -- across: 2
		checkbox multiDialBoxCB "multi alt dialogBox" enabled: false
		 
		button testLib2BT "Look for alternatives BMP" tooltip: "test missing bitmpas in alternative folder" 
	)
	
	on libMissBmpRLT open do
	(
		loadRolloutParams libMissBmpRLT Params
	)
	
	on libMissBmpRLT close do
	(
		writeRolloutParams libMissBmpRLT Params
	)
	
	on scanLibBT pressed do
	(
		format "scan start\n"
-- 		local oneDir = @"M:\Textures"
		local startTime  = timestamp()
		i = 0
		local bmpAr = #()
		
		for m in matAr do
		(
			local bmpTmpAr = getclassinstances bitmaptexture target: m
			for bmpTmp in bmpTmpAr do append bmpAr bmpTmp
		)
		if bmpAr.count  == 0 then (/*format "no missing bitmaps\n"*/)
		else
		(
			for b in bmpAr do
			(
				if not doesfileexist b.filename then
				(
					format "\nUNFOUND: %\n"  b.filename
					i += 1
				)
			)
		)	
		format "scan done: % s\n" (((timestamp()) - startTime)/1000 as float)
		format "total: %\n" i
	)
	
	on altPathBT pressed do
	(
		local tmpDir = getSavePath caption: "Select alternative bitmap folder" initialDir: libraryPatchET.text

		if tmpDir == undefined then()
		else if doesfileexist tmpDir then
		(	
			libraryPatchET.text = tmpDir
		)
		else()
	)
	
	on testLib2BT pressed do
	(
		format "test2 scan start\n"
-- 		local altDir = @"M:\Textures"
		local altDir = libraryPatchET.text
		local startTime  = timestamp()
		
		-- collete des dossiers à vérifier
		local dirArr = collectDir altDir
		format "collect folders: % s\n" (((timestamp()) - startTime)/1000 as float)

		-- collect des bitmap de la library
		local bmpAr = #()
		for m in matAr do
		(
			local bmpTmpAr = getclassinstances bitmaptexture target: m
			for bmpTmp in bmpTmpAr do append bmpAr bmpTmp
		)
		
		--
		i = 0
		j = 0
		k = 0
		
		n = 0
		
		for b in bmpAr where  not doesfileexist b.filename do
		(
				local altFiles = #()
				local found  = false

				
				format "\nUNFOUND: %\n"  b.filename
				
				-- nom du bitmap recherché
				local onePattern = (filenameFromPath b.filename)
				
				-- 
				for d in dirArr do
				(
					local testBmp = (d + onePattern)
					if doesfileexist  testBmp then
					(
						append altFiles testBmp
						found = true
					)
-- 					if found then exit
				)
				
				if altFiles.count == 0 then 
				(
					format "there is no alternative\n"
					i += 1
					
					if noAltDisplayCB.state then
					(
						refdep = refs.dependents b  -- immediateOnly: true
-- 						format "refdep: %\n" refdep
						for d in refdep do
						(
							if classof d == vraymtl or classof d == standard then 
							(
								format "d: % classof: %\n" d (classof d) 
								if n < 24 then
								(
									meditmaterials[i] = d
									n +=1
								)
							)
						)
					)
				)
				
				else if (altFiles.count == 1) then 
				(
					format "one alternative: %\n" altFiles
					-- 				replace textures
					-- 				if altFiles.count > 0 then b.filename = altFiles[1]
					j += 1
					
					if remapLibCB.state then
					(
						format "b.filename: % >>> altFiles[1]: %\n" b.filename altFiles[1]
						 b.filename = altFiles[1]
					)
				)
				else if (altFiles.count > 1) then 
				(
					format "multiples alternatives: %\n" altFiles
					k += 1
				)
				else()
		)
		format "test2 scan done: % s\n" (((timestamp()) - startTime)/1000 as float)
		format "alt bmp == 0 : %\nalt bmp ==  1: %\nalt bmp > 1: %\n" i j k
	)
	
)

rollout libColBmpRLT "Libray Bmp Collector Tools"
(	
	local params = #("open")
	
	group "Library bitmap collector:"
	(
		edittext libraryRessourceET "Bitmap Collector Folder:" --  text: altDir
		button ressourcePathBT "..."
		
		button  collectBT "Collect Bmp" enabled: true
		-- collecte des bitmap de la library dans un dossier:
			-- options:
				-- update des chemins
				-- un dossier par materiaux
	)
	
	on libColBmpRLT open do
	(
		loadRolloutParams libColBmpRLT Params
	)
	
	on libColBmpRLT close do
	(
		writeRolloutParams libColBmpRLT Params
	)
)
