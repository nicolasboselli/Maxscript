/*
maj:
	-- debug:
		-- open max file crash
	
	-- maj: 
		/- save matlib after addition or deletion
		x- sort material by name
		x- proposer un replace lorsqu'on veut enregistrer un materiau avec un nom deja existant
				
		-- fonction search
		x- add autosave toggle
		
		-- gestion de bitmaps de libray
			/- proposer en option le relinks des fichiers manquants sur un dossier donné
				x- relink forcé quand il y a une alternative
				-- dialog box quand il y a plusieurs alternatives
				-- faire apparaitre le materiaux dans l'editeur de materiaux quand il n y a pas d alternatives
			-- proposer un ressource collector sur un dossier donné
				-- crer un dossier de bmp collecte pas materiau
				-- remapper les bmp collectés
	
		-- fonction de merge d'une bibliothèque dans une autre 
					
		-- versioning material library file
		-- enregistrer les library en fonction de la verions de max, un dossier par version de max
			-- enregistrer des fichiers materials library en version précedentes de max( est ce que c'est possible)
		-- add thumbnail
	
*/

fn collectDir dir subfolder: true =
(
	local dirArr = #(dir)
	
	for d in dirArr do
	(
		local dirTmp = GetDirectories  (d + "\\*")
		
		if dirTmp == undefined then ()
		else if dirTmp.count == 0 then ()
		else
		(
			for dt in dirTmp do
			(
				-- ajout des dossier à l'array, clé de la  recursivité
				append dirArr dt
			)
		)

-- 		if found then exit
-- 		if maxFileCount > maxMaxFiles then exit
	)
	dirArr
)
-- oneDir = @"M:\Textures"
-- dirArr = collectDir oneDir

fn searchBitmap dir pattern =
(
	local altFilename

	local found = false
	local dirArr = #(dir)
	local fileArr = #()
	
	local maxMaxFiles = 2000
	local maxFileCount = 0
	
	-- pour chaque dossier
	for d in dirArr do
	(
		local dirTmp = GetDirectories  (d + "\\*")
		
		if dirTmp != undefined then 
		(
			if dirTmp.count > 0 then
			(
				for dt in dirTmp do
				(
					-- ajout des dossier à l'array, clé de la  recursivité
					append dirArr dt
					
					-- collect files
					found = doesfileexist (dt + pattern)
					
					maxFileCount += 1
					if found then
					(
-- 						format "REMAP: %\n" (dt + pattern) 
						append  fileArr (dt + pattern) 
					)
				)
			)
		)
		if found then exit
-- 		if maxFileCount > maxMaxFiles then exit
	)
	sort fileArr
)

fn sortbyname v1 v2 =
(
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then d=-1
	else d=1
	
--compare les numeros entre eux et les classe	
	if 	(d < 0.) then -1
	else if (d > 0.) then 1
	else 0
)


fn addUVWCube uvSize =
(
	local UvwSquare = Uvwmap  maptype: 4 length: uvSize width: uvSize  height: uvSize  axis: 2
	modPanel.addModToSelection (UvwSquare) ui:on
)


struct matStruct 
(
	mat,
	name = mat.name
)

try(closeRolloutFloater matLibRF)catch()
matLibRF = newRolloutFloater "Mat Lib Tools" 350 1050 -- 80 200

-- rollout
rollout vrMatRlt "Material LIbrary Tools"
(
	local pos = [0,0]
	local RFPos = [80,80]
	local RFSIze = [350,800]
	
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	
	local params = #("vrLibPath", "autosaveCB", "open", "RFPos", "RFSIze")
	
	local vrLibPath = ""
	local openFileName
	
	local matColAr = #()
	local matDispAr = #()
	
	local	vrLib = materiallibrary()
-- 	local matAr = #()
	global matAr = #()
	
	local altDir = @"M:\Textures"
		
-- 	UI
	group "library file:"
	(
-- 		button loadCoreBT "load core"
		edittext libPthBT "lib :" readonly: true
		button openLibBT "..." across: 2
		button loadLibBT "load"
		button saveLibBT "save" across: 2
		button saveAsLibBT "save as"
		checkbox autosaveCB "save on close"
	)
	
	group "scene materials:"
	(
		button collectSceneMatBT "collect scene material"
	)
	
	group "manage library:"
	(
		button addMatBT "add mat" across: 2
		button delMatBT "delete mat" enabled: true
-- 		button upLibBT "refresh lib"
		listbox matLB "materials list:" height: 30
	)
	
	group "scene actions"
	(
		button applyMatToObjectsBT "apply material to objects" -- across: 2

	)
		
	group "medit material actions"
	(
		button editMatBT "copy material" across: 2
		button instMatBT "instance material"
		button createVrMtlBT "create vray material"
	)
	
	group "slate materaial editor actions"
	(
		button applyMatBT "apply material selected"
	)
	

	
	
	/*
	group "uvw mapping box:"
	(
		button uv100 "100" across: 3
		button uv250 "250"
		button uv500 "500"
	)
	*/
	/*
	group "scene missing bmp Tools"
	(
		button scanBT "scan and patch" across: 2
		button missBmpBT "edit missing bitmap"
		button missBmpBT2 "format missing bitmap"
	)
	*/
	
	-- functions
	fn loadLib vrLibPath =
	(
		if vrLibPath == undefined then()
		else if doesfileexist vrLibPath then
		(
			format "loading start\n"
			vrLib = loadTempMaterialLibrary vrLibPath
			format "vrLib: %\n" vrLib
			
			matAr = for mat in vrLib collect mat
			qsort matAr sortbyname
			format "loading done: %\n" vrLibPath
		)
		else
		(
			vrLib = materialLibrary ()
			format "loading fail\n"
		)
	)	

	fn writeLib vrLibPath =
	(
		vrMatTmp = materiallibrary()
-- 		vrMatTmp.count

		for m in matAr do append vrMatTmp m
			
		if doesfileexist vrLibPath then
		(
			res = saveTempMaterialLibrary  vrMatTmp vrLibPath
			if res then (format "library saved: %, content: %\n" vrLibPath matAr) 
			else (format "library NOT saved: %,  content: %\n" vrLibPath matAr)
		)
		else
		(
			res = saveTempMaterialLibrary  vrMatTmp vrLibPath
			if res then (format "library saved: % , content: %\n" vrLibPath matAr) 
			else (format "library NOT saved: %,  content: %\n" vrLibPath matAr)
		)
	)
	
	fn refreshUI =
	(
		if vrLibPath!= undefined then libPthBT.text = vrLibPath else libPthBT.text = "???"
		qsort matAr sortbyname
		matLB.items = for mat in matAr collect mat.name
	)
	
-- 	actions
	on vrMatRlt open do
	(
-- 		matLibLoaded = false
		loadRolloutParams vrMatRlt Params
		try(matLibRF.pos =  RFPos)catch()
		try(matLibRF.size =  RFSIze)catch()
		
		-- load library
		loadLib vrLibPath
		
		-- refresh ui 2
		refreshUI()
	)
	
	on vrMatRlt close do
	(
		RFPos = matLibRF.pos
		RFSIze = matLibRF.size
		writeRolloutParams vrMatRlt Params
		
		if vrLibPath == undefined then ()
		else if vrLibPath.count > 0 and autosaveCB.state then writeLib vrLibPath
		else()
	)
	
	on openLibBT pressed do
	(
		vrLibPath = getOpenFileName caption: "open material library" types: "mat(*.mat)|*.mat|All Files|*.*"
		
-- 		load library
		loadLib vrLibPath
		
		refreshUI()
	)
	
	on loadLibBT pressed do
	(
		loadLib vrLibPath
		refreshUI()
	)
	
	on saveLibBT pressed do
	( 
		if doesfileexist vrLibPath then 
		(
			writeLib vrLibPath
			loadLib vrLibPath
		
			refreshUI()
		)
		else 	( format "path not valid: %\n" vrLibPath )
	)
	
	on saveAsLibBT pressed do
	(
		tmpPath = getSaveFileName caption: "save material library" types: "mat(*.mat)|*.mat|All Files|*.*"
		if tmpPath != undefined then 
		(
			writeLib tmpPath
			format "MatLib saved: %\n" tmpPath
		)
		else 	( format "path not valid: %\n" tmpPath )
	)
	
	on upLibBT pressed do refreshUI()
	
	on collectSceneMatBT pressed do
	(
			matAr = for mat in scenematerials collect mat
			qsort matAr sortbyname
			
			refreshUI()
	)
	
	on addMatBT pressed do
	(
		local matCand = meditMaterials[activeMeditSlot]
		
-- 		format "matCand: %\n" matCand
		local saving = true
		-- finditem matAr matCand
		
		-- check enregistrer material existant
		for i = matAr.count  to 1 by -1 do
		(
			if matAr[i].name == matCand.name then
			(
				local res = queryBox  "Un materiau avec le même nom existe déja.\n Voulez-vous le remplacer?" title: matAr[i].name 
-- 				format "res: %\n" res
				if res then
				(
					-- erase
					deleteitem matAr i
					exit 
				)
				else
				(
					saving = false
					exit
				)
			)else()
			
		)
		
		-- save
		if saving then
		(
			append matAr matCand
			format "saving done: %\n" matCand
		)
		
		refreshUI()
	)

	on delMatBT pressed do
	(
		id = matLB.selection
		format "matName: %\n" matName
		deleteItem matAr id
		refreshUI()
-- 		matLB.items = for mat in vrLib collect mat.name
	)
	 
	on applyMatToObjectsBT pressed do
	(
		matName = matLB.selected
		id = finditem matLB.items matName
		
		sel = selection as Array
		for s in sel do s.material = matAr[id]
	)
	
	on editMatBT pressed do
	(
		matName = matLB.selected
		id = finditem matLB.items matName
		meditMaterials[activeMeditSlot] =  copy matAr[id]
-- 		meditMaterials[activeMeditSlot] =  matAr[id]
	)
	
	on instMatBT pressed do
	(
		matName = matLB.selected
		id = finditem matLB.items matName
-- 		meditMaterials[activeMeditSlot] =  copy matAr[id]
-- 		meditMaterials[activeMeditSlot] =  matAr[id]
		
		bakname = meditMaterials[activeMeditSlot].name
		replaceInstances  meditMaterials[activeMeditSlot] matAr[id]
		meditMaterials[activeMeditSlot].name = bakname
	)
	
	on applyMatBT pressed do
	(
		matName = matLB.selected
		id = finditem matLB.items matName
	
-- 		format "keepNameCB.checked: %\n" keepNameCB.checked
		
		oneView = sme.GetView (sme.activeView)
		sel = oneView.GetSelectedNodes()
		
		for s in sel do
		(
			replaceInstances  s.reference matAr[id]
			s.reference.name = s.name
		)
-- 		format "s:%\n" s
		oneView.SelectNone()
	)
	
	
	on createVrMtlBT pressed do
	(
		meditMaterials[activeMeditSlot] = vraymtl()
	)
	

)


addRollout vrMatRlt matLibRF --rolledUp:false

