filein "assetManagerDef.ms"

/*
maj:
	-- add button for init root base path folder and choose base path folder in parameters base path
	-- create info files and check it
	-- check version
	-- move asset sanity check in the structure

bug:
	-- confond filename with folder name
*/ 

-- 	structure 
struct assetFromSelClass 
(
	objs,
	basefolder,
	name,
	version,
	
	fn initFromSel sel assetRepo =
	(
		objs = sel
		basefolder = assetRepo
		name = sel[1].name
		version = 0
	),
	
	fn getAssetFolder = basefolder +  name,
	
	fn getVersionFolder = getAssetFolder() + "\\" + (returnDigit version),
	
	fn getWipFolder = getAssetFolder() + "\\" + "wip",
	
	fn getVersionFile = getVersionFolder() + "\\" + name + ".max",
	
-- 		fn getWipFile = getWipFolder() + "\\" + name + "_wip_" + ".max",

	fn getWipFile = getWipFolder() + "\\" + name +"_" + (returnDigit version) + "_" + "wip" + "_" + (localTimeStr()) + "_v00.max",
		
	fn createFolders =
	(
		versionFolder = makedir (getVersionFolder()) all: true
		format "version folder: %\n" (getVersionFolder())
			
		folderCreated = makedir (getWipFolder())
		format "wip folder: %\n " (getWipFolder())
			
		folderCreated
	),
	
	fn createAssetFileInfo =
	(
		assetInfoIniFile = getAssetFolder() + "\\assetInfo.ini"
		assetInfoFileStream = createFile assetInfoIniFile
		close assetInfoFileStream
		
		setINISetting assetInfoIniFile "assetProperties" "name" name
-- 			setINISetting assetInfoIniFile "assetProperties" "path" (getAssetFolder())
-- 			setINISetting assetInfoIniFile "assetProperties" "lastVersion" (version as string)
		setINISetting assetInfoIniFile "assetProperties" "version" (version as string)
		
	),
	
	fn createVersionFileInfo =
	(
		versionInfoIniFile = getVersionFolder() + "\\versionInfo.ini"
		versionInfoFileStream = createFile versionInfoIniFile
		close versionInfoFileStream
		
		setINISetting versionInfoIniFile "assetProperties" "name" name
-- 			setINISetting versionInfoIniFile "assetProperties" "versionFile" (getVersionFile())
		setINISetting versionInfoIniFile "assetProperties" "lastVersion" (version as string)
		
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
		lastVersionFile = getVersionFile()
		wipFile = getWipFile()
		copyFile lastVersionFile wipFile
-- 		saveMaxFile wipFile useNewFile: useWipAsset
		format "Wip Created: %\n"	wipFile	
		wipFile
	)
	
)

try(destroyDialog createAssetFromSelRLT)catch()

rollout createAssetFromSelRLT "create asset from selection"
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
-- 	vars
	local allAssetsFolder
	local root 
	
	local newAsset
	
	
	group "parameters"
	(
-- 		button autocompleteBT "Auto-Complete"
		edittext pathET "base path:" readonly: true
-- 		button initPathBT "init path" across: 2
-- 		button openDialogBT "..."
		
		edittext nameET "name:" enabled: false across: 2
		edittext versionET "version:" enabled: false readonly: true
		
		edittext statusET "status:" enabled: false
		edittext superclassET "superclass:" enabled: false
		edittext classET "class:"  enabled: false
		edittext commentET "comment:"  enabled: false
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
	
	group "asset creation from scene :"
	(
		checkbox useWipCB "use wip asset created" state: false across: 3 enabled: false
-- 		button createAssetBT "create asset with scene" enabled: false 
		button createAssetFromSelBT "create asset from selection" enabled: false
		button createAssetFromSelBT2 "create asset from selection v2" enabled: false
	)
	
	-- functions ui dependant 
	fn checkCreationSanity newAsset =
	(
		creationSanity = false
		-- check name
		if newAsset.name.count > 0 then correctName = true else correctName = false
			
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
			createAssetFromSelBT.enabled = true
			createAssetFromSelBT2.enabled = true
			useWipCB.enabled = true
		)
		else
		(
			createAssetFromSelBT.enabled = false
			createAssetFromSelBT2.enabled = false
-- 			createAssetBT.enabled = false
			useWipCB.enabled = false
		)
		
		creationSanity
	)
	
	
	fn completeParam asset =
	(
		pathET.text = root
		pathET.enabled = true
		
		nameET.text = asset.name
		nameET.enabled = true

		versionET.text = returnDigit asset.version
		versionET.enabled = true
	)
	
		
-- 	actions

	on createAssetFromSelRLT open do 
	( 
		sel = selection as array
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		
		if rootIni.count > 0 and sel.count > 0 then
		(
-- 			print "youpi!"
			if doesfileexist rootIni == true then root = rootIni + "\\"
			
			newAsset = assetFromSelClass()
			newAsset.initFromSel sel root
-- 			print newAsset
			
			completeParam newAsset		
			checkCreationSanity newAsset
			format "newAsset: % \n" newAsset
		)
		else
		(		
			destroydialog createAssetFromSelRLT
			print "make selection first"
		)
	)
	
	on nameET entered str do
	(
		if newAsset != undefined then
		(
			newAsset.name =  str
			
			completeParam newAsset
			checkCreationSanity newAsset
		)
	)
	
	on checkCreationBT pressed do
	(
		
		if newAsset != undefined then
		(
			checkCreationSanity newAsset
		)
		else
		(
			print "complete fields"
		)
		
	)
	
	on createAssetFromSelBT2 pressed do
	(
		newAsset.createAssetFromSel()
		
		if useWipCB.state then
		(
			wipFile = newAsset.createWipFile()
			if checkForSave() do loadMaxFile wipFile useFileUnits: true
		)
		
		format "asset creation done: %\n" newAsset.name
		try rof.rollouts[2].refreshFromOutside() catch(format "*** % ***\n" (getCurrentException()))
		destroydialog createAssetRLT
	)
	 
)
createdialog createAssetFromSelRLT width: 800
