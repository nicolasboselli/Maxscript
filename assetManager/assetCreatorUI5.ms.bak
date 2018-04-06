filein "assetManagerDef.ms"

/*
maj:
	-- fuse  "fn checkCreationSanity" et "fn refreshPublishRlt"
		-- move asset sanity check in the structure
		-- distinguer le sanity check de l'update de l'ui
		
	-- trier les methodes de découpage et de reconstruction des pathname et les variables inutiles
	-- re rendre le status editable
		
	-- dev init for display and init for publishing
	
	-- proposer un clean des calques et des materiaux
	-- porposer un rename des calques et des materiaux
	
	-- blinder le choix de la version d'enregistrement:
		-- prendre en compte la verion de max utiliser
		-- proposer des version d'enregistremnt possible(précédente)
		-- prendre en compte l'exception de max 2017 qui ne supporte pas la saveasversion: 2017
	
debug:
	-- au fail de creation d'asset, supprimer le dossier créé
	x- fail à l'enregistrement en 2017
	-- la variable assetop n'arrive pas depuis l' asset opener à la première ouverture
		
*/ 
 
-- 	structure
struct assetCreationClass 
(
	objs,
	basefolder,
	assetName,
	version,
	
	assetInfo,
	assetFolder, 

	lastVersion,
	
	root,

	wipFolder,
	
	versionInfo,
	lastVersionFile,
	
	relVersPath,
	
	status = "wip",
	
	maxVers,
	
	fn initFromScene assetRepo =
	(
		basefolder = assetRepo
		assetName = getFilenameFile maxFileName
		version = 0
	),
	
	fn initFromSel sel assetRepo =
	(
		objs = sel
		basefolder = assetRepo
		assetName = sel[1].name
		version = 0
	),
	
	fn initFromIni iniFile assetRepo =
	(
		basefolder = assetRepo + "\\"

		assetInfo = iniFile
		assetFolder = cleanFilename (getFilenamePath assetInfo)
		
-- 		basefolder = assetFolder + "\\"
		
		--
		assetName = getINISetting iniFile "assetProperties" "name"
-- 		format "assetName: %, count: %\n" assetName assetName.count
		if assetName.count == 0 then assetName = getINISetting iniFile "assetProperties" "assetName"
		
		lastVersion = (getINISetting iniFile "assetProperties" "version") as integer
		version = lastVersion
		--
		versionInfo = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) + "\\" + "versionInfo.ini" )
		--
		statusTmp = getINISetting versionInfo "assetProperties" "status"
		if statusTmp.count > 0 then status = statusTmp else status = "none" 
		--
		lastVersionFile = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) +"\\" + assetName + ".max")
		wipFolder = cleanFilename(assetFolder +"\\"+  "wip" + "\\")
				
		format  "Asset Init Done: %\n" assetName
	),
	
	fn getAssetFolder = basefolder +  assetName,
	
	fn getWipFolder = getAssetFolder() + "\\" + "wip",
	fn getVersionFolder = getAssetFolder() + "\\" + (returnDigit version), 
	
	fn getVersionFile = getVersionFolder() + "\\" + assetName + ".max",
	
	fn getWipFile = getWipFolder() + "\\" + assetName +"_" + (returnDigit version) + "_" + "wip" + "_" + (localTimeStr()) + "_v00.max",
	
	fn createFolders =
	(
		versionFolder = makedir (getVersionFolder()) all: true
		format "version folder: %\n " versionFolder
			
		folderCreated = makedir (getWipFolder())
		format "wip folder: %\n" folderCreated
			
		folderCreated
	),
	
	fn createAssetFileInfo =
	(
		assetInfoIniFile = getAssetFolder() + "\\assetInfo.ini"
		assetInfoFileStream = createFile assetInfoIniFile
		close assetInfoFileStream
		
		setINISetting assetInfoIniFile "assetProperties" "assetName" assetName
-- 			setINISetting assetInfoIniFile "assetProperties" "path" (getAssetFolder())
-- 			setINISetting assetInfoIniFile "assetProperties" "lastVersion" (version as string)
		setINISetting assetInfoIniFile "assetProperties" "version" (version as string)
		
	),
	
	fn createVersionFileInfo =
	(
		versionInfoIniFile =  basefolder +  assetName + "\\" + (returnDigit version) + "\\versionInfo.ini"

		versionInfoFileStream = createFile versionInfoIniFile
		close versionInfoFileStream
		
		setINISetting versionInfoIniFile "assetProperties" "name" assetName
-- 			setINISetting versionInfoIniFile "assetProperties" "versionFile" (getVersionFile())
		setINISetting versionInfoIniFile "assetProperties" "lastVersion" (version as string)
		setINISetting versionInfoIniFile "assetProperties" "status" status
	),
	
	fn updateAssetFileInfo =
	(
		setINIsetting assetInfo "assetProperties" "version" (lastVersion as string)
	),
	
	fn createAssetFromScene  =
	(
		res = createFolders()
		if res == true then
		(
			newFile = getVersionFile()
-- 			print newFile
			saveMaxFile newFile useNewFile: false
			if doesfileexist newFile then
			(
				createAssetFileInfo()
				createVersionFileInfo()
				format "New Asset Created: %\n"	newFile	
			)
		)
		else format "folders are not existing\n"
	),
	
	fn createAssetFromSel =
	(
		res = createFolders()
		if res == true then
		(
			newFile = getVersionFile()
-- 			print newFile
			saveNodes objs newFile
			if doesfileexist newFile then
			(
				createAssetFileInfo()
				createVersionFileInfo()
				format "New Asset Created: %\n"	newFile	
			)
		)
		else format "folders are not existing\n"
	),
	
	fn createWipFile  =
	(
		format "base folder: %\n"	basefolder	
		lastVersionFile = getVersionFile()
		format "last file: %\n"	lastVersionFile	
		wipFile = getWipFile()
		format "Wip file: %\n"	wipFile	
		copyFile lastVersionFile wipFile
-- 		saveMaxFile wipFile useNewFile: useWipAsset
		format "Wip Created: %\n"	wipFile	
		wipFile
	),
	
	fn publishNewVersion maxVers =
	(
		-- create new version folder
		newFolder =  assetFolder +"\\" +  (returnDigit( lastVersion + 1))
		folderCreated = makedir newFolder all: true
		
		if maxVers == 2017 then maxVers = 0
			
		-- save new version file
		local newFile
		
		format "maxvers: %\n" maxVers
		
		if folderCreated == true then
		(
-- 			maxVers = 2015
			newFile =  newFolder + "\\" +  assetName + ".max" 
			newfileCreated = saveMaxFile newFile useNewFile: false saveAsVersion: maxVers
			
			if newfileCreated then
			(
				format "Asset Publishing Done: % ; New Version Published: % \n" assetName newFile
			)
			else
			(
				format "Asset Publishing Fail: % \n" assetName
				
			)
		)
		
		if newfileCreated == true then
		(
			 lastVersion =  lastVersion + 1
			 lastVersionFile = newFile
			-- update asset info file
			 updateAssetFileInfo()
			
			-- create version info file
			 createVersionFileInfo()
		)
		else
		(
-- 			delete folder
		)
		format "publishing method end: %\n" newFile
		newFile
	),
	
	fn getLastVersionFile =
	(
		lastVersionFile = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) + "\\" + assetName + ".max")
		lastVersionFile
	),
	
	fn getMaxFileVersion = 
	(
		local maxVers
		res = getMaxFileVersionData lastVersionFile 
		if res[1] == 14000 then maxVers = "2012"
		else if res[1] == 15000 then maxVers = "2013"
		else if res[1] == 16000 then maxVers = "2014"
		else if res[1] == 17000 then maxVers = "2015"
		else if res[1] == 18000 then maxVers = "2016"
		else if res[1] == 19000 then maxVers = "2017"
		else maxVers = "unknow"
		
		maxVers
	),
	
	fn mergeAsset3 mergeAsAsset: true ignoreVrSet: false ignoreCacheLay: false =
	(
		local assetCtrl
		-- create asset point
		if mergeAsAsset then 
		(
			LM = layermanager
			assetCtrl = point name: (uniquename( assetName + "_ctrl")) size: 200
			assetsLayer = LM.getLayerFromName "assets_layer"
			if assetsLayer == undefined do assetsLayer = LM.newLayerFromName "assets_layer"
				
			assetsLayer.addnode assetCtrl
			
			-- tag de l'asset point
			setUserProp assetCtrl "asset" true
			
			setUserProp assetCtrl "root" root
			setUserProp assetCtrl "relativePath" relVersPath
			setUserProp assetCtrl "assetfolder" assetFolder
			
			setUserProp assetCtrl "allAssetsRoot" allAssetsRoot
			setUserProp assetCtrl "allAssetsFolder" allAssetsFolder
			setUserProp assetCtrl "relativeFolder" relativeFolder
			setUserProp assetCtrl "relativeFolder2" relativeFolder2
			
			setUserProp assetCtrl "assetName"  assetName
			setUserProp assetCtrl "assetVersion" lastVersion
		)
		
		local objsCountBef = objects.count
		--import
		mergeMAXFile lastVersionFile  #useSceneMtlDups #AutoRenameDups  -- #AutoRenameDups  -- #mergeDups -- #select
		
	--	collect objects import
		objsImpAr = #()
		if objects.count > objsCountBef do
		(
			objsImpAr = for i = (objsCountBef + 1) to objects.count collect objects[i]
		)
		
		for o in objsImpAr do
		(
			if not isValidNode o do continue
				
	-- 		o = getnodebyname str
			deletion = false
			
			-- suppresion des elemets vray
			local belongToVrSet = false
			if classof o == vraysun or classof o == vrayplane or  classof o == targetcamera then belongToVrSet = true
			if ignoreVrSet and belongToVrSet  then deletion = true

			-- suppression des elements caches
			belongToCachLay = matchpattern o.layer.name pattern: "*cache_layer*"	
			if ignoreCacheLay and belongToCachLay then deletion = true
			
			-- parenter au ctrl asset
			if mergeAsAsset and  o.parent == undefined and not isGroupMember o then o.parent = assetCtrl
			else if mergeAsAsset and o.parent == undefined and isGroupHead o then o.parent = assetCtrl
			
			
			format "obj: %, deletion:%, parent:%\n" o.name deletion o.parent
			
			if deletion == true then delete o
		)
		assetCtrl
	)
	
)


try(destroyDialog createAssetRLT)catch()
rollout createAssetRLT "create asset v3" 
(
-- 	local maxIni = getMAXIniFile()
-- 	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
-- 	vars
	local allAssetsFolder
	local root
	
-- 	local assetPath = @"\\ELVIS\_svn\zz_ressources3D"
	local newAsset
	
	local mode
	
	
	group "parameters"
	(
-- 		button autocompleteBT "Auto-Complete"
		edittext pathET "base path:" readonly: true
-- 		button initPathBT "init path" across: 2
-- 		button openDialogBT "..."
		
		edittext nameET "name:" enabled: false across: 2
		edittext versionET "version:" enabled: false readonly: true
		
		edittext statusET "status:" enabled: false across: 3
-- 		edittext superclassET "superclass:" enabled: false
-- 		edittext classET "class:"  enabled: false
		edittext commentET "comment:"  enabled: false
		dropdownlist maxVersDL "max vers:" items: #( "2015", "2017") selection: 1 width: 60
	)
	
	group "asset sanity checking from scene:"
	(
		button checkCreationBT "sanity check" 
		
		edittext correctNameET "correct name:" readonly: true across: 3
		edittext assetFolderCheckET "asset folder exists:" readonly: true
		edittext versionFolderCheckET "version folder exists:" readonly: true 
		edittext wipFolderCheckET "wip folder exists:" readonly: true across: 3
		edittext fileCheckET "file exists:" readonly: true 
		edittext assetFileInfoCheckET "asset info exists:" readonly: true
		edittext versionFileInfoCheckET "version info exists:" readonly: true
		
	)
	
	group "sanity diagnostic:"
	(
		edittext versResET"version file result:" readonly: true
		edittext wipResET"wip file result:" readonly: true
		edittext creationSanityET "creation ready" readonly: true across: 2
		edittext publishingSanity "publishing ready" readonly: true
	)
	
	group "asset creation :"
	(
		checkbox useWipCB "use wip asset created" state: false across: 3 enabled: false
-- 		button createAssetBT "create asset with scene" enabled: false 
		button createAssetBT2 "create version" enabled: false 
-- 		button createAssetFromSelBT2 "from selection" enabled: false
-- 		button createAssetFromSelBT "create asset from selection" enabled: false
	)
	
	-- functions ui dependant 
	fn checkCreationSanity newAsset =
	(
		creationSanity = false
		-- check name
		if newAsset.assetName.count > 0 then correctName = true else correctName = false
			
		-- check asset folder exists
		res = getDirectories (newAsset.getAssetFolder())
		if res.count != 1 then assetFolderExists = false else assetFolderExists = true
			
		-- check version folder exists
		res = getDirectories (newAsset.getVersionFolder())
		if res.count != 1 then versionFolderExists = false else versionFolderExists = true
		
		-- check wip folder exists
		
		-- check version file exists
		res = getfiles (newAsset.getVersionFile())
		if res.count != 1 then versionFileExists = false else versionFileExists = true
			
		-- check asset info file exists
		res = getfiles (newAsset.basefolder + "\\assetInfo.ini" )
		if res.count != 1 then assetFileInfoExists = false else assetFileInfoExists = true
		-- check version info file exists
		
		
		-- checking ui result
		correctNameET.text = correctName as string
		assetFolderCheckET.text = assetFolderExists as string
		versionFolderCheckET.text = versionFolderExists as string
		assetFileInfoCheckET.text = assetFileInfoExists as string
		fileCheckET.text = versionFileExists as string
		
		
		if correctName == true and assetFolderExists == false and versionFolderExists == false and assetFileInfoExists == false then
		(
			creationSanity = true
		)
		
		-- diagnostic ui result
		versResET.text = newAsset.getVersionFile()
		wipResET.text = newAsset.getWipFile()
		
		creationSanityET.text = creationSanity as string
		
		if creationSanity == true then
		(
-- 			createAssetBT.enabled = true
			createAssetBT2.enabled = true
-- 			createAssetFromSelBT2.enabled = true
			useWipCB.enabled = true
		)
		else
		(
-- 			createAssetBT.enabled = false
			createAssetBT2.enabled = false
-- 			createAssetFromSelBT2.enabled = false
			useWipCB.enabled = false
		)
		
		creationSanity
	)
	
	fn refreshPublishRlt asset =
	(
		-- test if asset folder ready
		nameOk = False
		nextVersionPossible = False
		
		-- check asset info file exists
		assetFileInfoExists = doesfileexist (asset.assetInfo)
		
		-- find asset name from folder name
		currentFile = maxFilePath
		currentFileName = undefined
		
		if currentFile.count >0 then
		(
			basefolder = getUpperFolder currentFile
			pathAr = filterString  basefolder "\\"
			currentFileName = pathAr[pathAr.count]
		)
		
		-- compare name with asset info
		assetName = asset.assetName
		
		if currentFileName == assetName then
		(
-- 			assetNameET.text = assetName
			nameOk = true
		)
		else
		(
-- 			assetNameET.text = "???"
		)
		
		-- find next version by count folders
		lastVersion = 0
		folderVersion = False
		assetFolders = getDirectories (asset.assetFolder + "\*")
		
		for f in assetFolders do
		(
			pathAr = filterString  f "\\"
			version = (pathAr[pathAr.count] as integer)
			if  version != undefined  then 
			(
				folderVersion = True
				if version> lastVersion then lastVersion = version
			)
		)

		-- compare with asset info
		assetVersion = asset.lastVersion
		
		versionText = "???"
		
		if folderVersion == true do
		(
			if assetVersion == lastVersion then
			(
-- 				versionText = returnDigit (lastVersion + 1)
				nextVersionPossible = true
			)
		)
-- 		nextVersionET.text = versionText
		
		-- set status
-- 		id = finditem statusDL.items asset.status
-- 		statusDL.selection = id
		
		-- diagnostic ui result
		versResET.text = newAsset.getVersionFile()
		wipResET.text = newAsset.getWipFile()
		
		-- enable publishing
		if  assetFileInfoExists == true and	nameOk == true  and nextVersionPossible == true then
		(
			createAssetBT2.enabled = true
			useWipCB.enabled = true
		)
		else
		(
			createAssetBT2.enabled = false
			useWipCB.enabled = false
		)
	)
	
	fn completeParam asset =
	(
		pathET.text = asset.basefolder
		pathET.enabled = true
		
		nameET.text = asset.assetName
		nameET.enabled = true

		versionET.text = returnDigit asset.version
		versionET.enabled = true
	)
	
	fn initForScene =
	(
		mode = 1
		createAssetBT2.caption = "create asset from scene"
		createAssetRLT.title = "create asset from scene"
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		
		if rootIni.count > 0 then
		(
			if doesfileexist rootIni == true then root = rootIni + "\\"
				
			newAsset = assetCreationClass()
			newAsset.initFromScene root
-- 			print newAsset
			
-- 			newAsset.basefolder = root
-- 			print newAsset
			
			completeParam newAsset		
			checkCreationSanity newAsset
			format "newAsset: % \n" newAsset
		)
	)
	
	fn initForSelection =
	(
		mode = 2
		sel = selection as array
		createAssetBT2.caption = "create asset from selection"
		createAssetRLT.title = "create asset from selection"
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		
		if rootIni.count > 0 and sel.count > 0 then
		(
-- 			print "youpi!"
			if doesfileexist rootIni == true then root = rootIni + "\\"
			
			newAsset = assetCreationClass()
			newAsset.initFromSel sel root
-- 			print newAsset
			
			completeParam newAsset		
			checkCreationSanity newAsset
			format "newAsset: % \n" newAsset
		)
	)
	
	fn initForPublishing =
	(
		mode = 3
		createAssetBT2.caption = "publish new asset version"
		createAssetRLT.title = "publish new asset version"
		
		-- check if we are in asset
		infoTest = getUpperFolder maxFilePath + "assetInfo.ini"
			-- find assetInfo.ini file
		local res = doesfileexist infoTest 
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		
		if rootIni.count > 0 and res then
		(
			if doesfileexist rootIni == true then root = rootIni + "\\"
				
			newAsset = assetCreationClass()
			newAsset.initFromIni infoTest root
			newAsset.version += 1
			
			completeParam newAsset		
			refreshPublishRlt newAsset
		)
		else (print "this is not an asset")
	)
	-- Actions
	
	on createAssetRLT open do
	(
		if not assetEditorRLT.assetOp == undefined then
		(
			format "asset op: %\n" assetEditorRLT.assetOp
			if assetEditorRLT.assetOp == 1 then
			(
				initForScene()
			)
			else if assetEditorRLT.assetOp == 2 then
			(
				initForSelection ()
			)
			else if assetEditorRLT.assetOp == 3 then
			(
				initForPublishing ()
			)
			else()
		)
		else
		(
			format "assetOp error\n"
			try(destroyDialog createAssetRLT)catch()
		)
	)
	
	on nameET entered str do
	(
		if newAsset != undefined then
		(
			newAsset.assetName =  str
			
			completeParam newAsset
			checkCreationSanity newAsset
		)
	)
	/*
	on checkCreationBT pressed do
	(
		if newAsset != undefined then checkCreationSanity newAsset
		else	print "complete fields"
	)
	*/
	on createAssetBT2 pressed do
	(
		if mode == 1 then newAsset.createAssetFromScene()
		else if mode == 2 then newAsset.createAssetFromSel()
		else if mode == 3 then 
		(
			local maxVers
-- 			if maxVersDL.selection == 1 then maxVers = 2015 else if  maxVersDL.selection == 2 then maxVers = 2017
			maxVers = maxVersDL.selected  as integer
			format "max version: %\n" maxVers
			newAsset.publishNewVersion maxVers
		)
			
		if useWipCB.state then
		(
			wipFile = newAsset.createWipFile()
			if checkForSave() do loadMaxFile wipFile useFileUnits: true
		)
		
		format "asset creation done: %\n" newAsset.assetName
-- 		try rof.rollouts[2].refreshFromOutside() catch(format "*** % ***\n" (getCurrentException()))
		destroydialog createAssetRLT
	)
)
-- createdialog createAssetRLT width: 800

