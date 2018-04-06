-- asset opener

/*
memo:
	-- fonctionnalité	
		-- create asset from sel
		-- create asset from scene
		-- publish asset version
		-- merge asset
		-- edit asset

maj:
	x- filter by name
		x- add * add begining and end of search	
		
	x-- filter by status (all, approved, wip, retake, archived)
		-- add ignore achive
		
	x- fuse "assetCreatorUI" and "assetCreatorFromSelectionUI2"
	
	x- deplace publish method in asset structure
	x- deplace edit method in asset structure
	x- revoir le systeme d enregistrement en passant par un wip
		x- update wip name after publishing

	x- clean wip folder
	-- clean old version (work only with first and last version)
	-- add comments
	x- add history in repository
	-- delete/ rename asset
	
	x- ouvrir l'asset dans une autre instance de 3ds max
	
	x- au merge eviter le cache layer et les sun
		
	-- proposer merge ou xref ou xref object
	
	x- faire apparaitre version de max du fichier: getMaxFileVersionData filename

debug:
	x- parent hidden object
	-- error when change status on lastselection
		
*/

filein "assetCreatorUI4.ms"
filein "assetManagerDef.ms"

rof
/*
fn sortAssestbyname v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then
		d=-1
	else
		d=1
	
--compare les numeros entre eux et les classe	
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)

-- scan asset folder to collect asset
fn walkDir dir pattern =
(
	assetArr = #()
    dirArr = GetDirectories (dir + "\\*")
 
    for d in dirArr do
    (
        join dirArr (getDirectories (d + "\\*"))
    )
 
    append dirArr (dir + "\\") -- Need to include the original top level directory
 
    for f in dirArr do
    (
		fileArr = getFiles (f + pattern)
		if fileArr.count> 0 do
		(
			for f in fileArr do
			(
				 append assetArr f
			)
		)
       
    )
	assetArr
)


struct assetClass  
(
	assetInfo,
	assetFolder, 

	name,
	lastVersion,
	
	root,

	wipFolder,
	
	versionInfo,
	lastVersionFile,
	
	relVersPath,
	
	status,
	
	maxVers,
	
	fn getWipFile =wipFolder + "\\" + name +"_" + (returnDigit lastVersion) + "_" + "wip" + "_" + (localTimeStr()) + "_v00.max", 
	
	fn initFromIni iniFile assetsTank =
	(
-- 		print "start init"
		
		assetInfo = iniFile
		assetFolder =cleanFilename(getFilenamePath assetInfo)
		--
		name = getINISetting iniFile "assetProperties" "name"
		lastVersion = (getINISetting iniFile "assetProperties" "version") as integer
		--
		versionInfo = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) + "\\" + "versionInfo.ini" )
		--
		statusTmp = getINISetting versionInfo "assetProperties" "status"
		if statusTmp.count > 0 then status = statusTmp else status = "none" 
		--
		lastVersionFile = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) +"\\" + name + ".max")
		wipFolder = cleanFilename(assetFolder +"\\"+  "wip" + "\\")
		
		root = cleanFilename(assetsTank + "\\")
		
		format  "Asset Init: %\n" name
	),
	
	
	fn updateAssetFileInfo =
	(
		setINIsetting assetInfo "assetProperties" "version" (lastVersion as string)
	),
	
	fn createVersionFileInfo =
	(
		versionInfoIniFile = assetFolder + "\\" +(returnDigit lastVersion ) +"\\" + "versionInfo.ini"
		versionInfoFileStream = createFile versionInfoIniFile
		close versionInfoFileStream
				
		setINISetting versionInfoIniFile "assetProperties" "name" name
-- 		setINISetting versionInfoIniFile "assetProperties" "versionFile" lastVersionFile
-- 		setINISetting versionInfoIniFile "assetProperties" "relativeVersionFile" relVersPath
		setINISetting versionInfoIniFile "assetProperties" "lastVersion" (lastVersion as string)
		setINISetting versionInfoIniFile "assetProperties" "status" status
	),
	
	
	fn mergeAsset3 mergeAsAsset: true ignoreVrSet: false ignoreCacheLay: false =
	(
		local assetCtrl
		-- create asset point
		if mergeAsAsset then 
		(
			LM = layermanager
			assetCtrl = point name: (uniquename( name + "_ctrl")) size: 200
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
			
			setUserProp assetCtrl "assetName"  name
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
			else if mergeAsAsset and  o.parent == undefined and not isGroupMember o then o.parent = assetCtrl
			
			
			format "obj: %, deletion:% \n" o.name deletion
			
			if deletion == true then delete o
		)
		assetCtrl
	),
	
	
	fn getLastVersionFile =
	(
		lastVersionFile = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) + "\\" + name + ".max")
		lastVersionFile
	),
	
	fn createWipFile  =
	(
		lastVersionFile = getLastVersionFile()
		wipFile = getWipFile()
		copyFile lastVersionFile wipFile
-- 		saveMaxFile wipFile useNewFile: useWipAsset
		format "Wip Created: %\n"	wipFile	
		wipFile
	),
	
	fn getMaxFileVersion = 
	(
		maxVers
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
	
	fn publishNewVersion =
	(
		-- create new version folder
		newFolder =  assetFolder +"\\" +  (returnDigit( lastVersion + 1))
		folderCreated = makedir newFolder all: true
		
		-- save new version file
		local newFile
			
		if folderCreated == true then
		(
			newFile =  newFolder + "\\" +  name + ".max" 
			newfileCreated = saveMaxFile newFile useNewFile: false
			if newfileCreated then (format "Asset Publishing Done: % ; New Version Published: % \n" name newFile) else (format "Asset Publishing Fail: % \n" name)
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
		newFile
	)
)
*/

/*
rollout publishVersionRLT "publish asset" width: 400
(
	local currentAsset
	local statusAr = #("none","approved","wip","retake", "archive" )
	
	edittext assetNameET "asset name:" readonly: true
	editText nextVersionET "next version:" readonly: true
	dropdownlist statusDL "status:" 
-- 	button publishBT "publish version" across: 2
	button publishBT2 "publish version v2"
	
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
		assetName = asset.name
		
		if currentFileName == assetName then
		(
			assetNameET.text = assetName
			nameOk = true
		)
		else
		(
			assetNameET.text = "???"
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
				versionText = returnDigit (lastVersion + 1)
				nextVersionPossible = true
			)
		)
		nextVersionET.text = versionText
		
		-- set status
		id = finditem statusDL.items asset.status
		statusDL.selection = id
		
		-- enable publishing
		if  assetFileInfoExists == true and	nameOk == true  and nextVersionPossible == true then
		(
			publishBT2.enabled = true
		)
		else
		(
			publishBT2.enabled = false
		)
	)
	
	on publishVersionRLT open do
	(
		-- init rollout
		currentAsset = rof.rollouts[2].currentAsset
		statusDL.items = statusAr
		
		-- set rollout
		if currentAsset != undefined do refreshPublishRlt currentAsset
	)
	
	on statusDL selected arg do
	(
		currentAsset.status = statusAr[arg]
	)
	
	on publishBT2 pressed do
	(
		currentAsset.publishNewVersion()
		
		wipFile = currentAsset.createWipFile()
		if checkForSave() do loadMaxFile wipFile useFileUnits: true
		
-- 		try refreshListBox() catch(format "*** % ***\n" (getCurrentException()))
-- 		refreshEditGroup assetsToDisplay[assetsBL.selection]
-- 		format "Asset Published: %\n" currentAsset.getLastVersionFile()
-- 		format "Asset Edited: %\n" wipFile
		
		rof.rollouts[2].refreshFromOutside()
		destroyDialog publishVersionRLT
	)
)
*/

rollout externalToolsRLT "asset tools"
(
	local currentAsset
	
	group "tools:"
	(
		button assetToolsBT "asset tools..." across:2
		button updateToolsBT "update tools..."
	)
	
	on assetToolsBT pressed do filein "assetManagerTools.ms"
	on updateToolsBT pressed do filein "updateAssetTool.ms"
)

rollout assetEditorRLT "assets editor v2"
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
-- 	local allAssetsFolder = "zz_ressources3D"
	local root 
	local rootAr = #()
	
	local assetPathsArr = #()
	local assetsList = #()
	local assetsToDisplay = #()
	
	local statusAr = #("all","none","approved","wip","retake", "archive" )
	local currentAsset
-- 	UI
-- 	edittext allAssetsFolderET "the \"all assets\" folder name:" text: allAssetsFolder readonly: true
	group "Assets Repository:"
	(
		dropdownlist pathListDL "History Paths: " readonly: true height: 11
		edittext rootET "Path:" readonly: true
		button findFolderBT "..."
	)
	
	group "Asset Creation:"
	(
		button createAssetBT "from scene..." across:3
		button createAssetFromSelBT "from selection..." 
		button publishRolloutBT "publish..."
	)
	
	group "Asset Creation v 3 :"
	(
		button createAssetBT3 "from scene... v3" across:3
		button createAssetFromSelBT3 "from selection...v3" 
		button publishRolloutBT3 "publish...v3"
	)
	
	group "Filters:"
	(
		edittext nameSearchET "search by name:"
		dropdownlist  statusDL "status:"  items: statusAr
	)
	
	
	group "Assets List:"
	(
		listbox assetsBL "Assets:"
		button collectAssetBT "refresh"
	)
-- 	rof.rollouts[2].assetsList[1].name
	group "Merging:"
	(
		checkbox ignoreCacheCB "ignore cache_layer" checked: true across: 4
		checkbox ignoreVrCB "ignore vray set" checked: true -- enabled: false 
		checkbox createAsAssetCB "create as asset" enabled: false
-- 		button mergeBT "merge"
		button mergeBT3 "merge v3"
	)
	
	group "Asset selected infos:"
	(
		
		
-- 		edittext curAssetRootET "assets root: " readonly: true
-- 		edittext curAllAssetsFolderET "all assets folder: " readonly: true
-- 		edittext assetRelativePathET "asset relative path: " readonly: true
		edittext curAssetNameET "asset name:" readonly: true
		edittext versionET "last version:" readonly: true
		
		edittext absPathET "absolute path:" readonly: true
-- 		edittext relVersionET "relative version" readonly: true
		
		edittext statusET "status:" readonly: true
		edittext editableET "asset editable:" readonly: true
		edittext wipFilesCountET "wip files count:" readonly: true
		edittext maxFileVersET "max version:" readonly: true
 		
-- 		edittext openStatusET "status:"  readonly: true
-- 		edittext  openTagsET "tags:" readonly: true
		
-- 		checkbox instanceCB "new max instance"
		button openBT "open folder" across:4
-- 		button editBT "edit" 
		button editBT2 "edit v2" 
-- 		button newMaxBT "edit in new max instance" across:3
		button newMaxBT2 "edit in new max instance v2" 
		button cleanWipFolderBT  "clean wip folder" 
		
		bitmap assetBMP "asset thumbnail" width: 256 height: 256
		
-- 		button updateBT "update"
	)
	


	fn refreshEditGroup asset =
	(
-- 		refresh root
-- 		curAssetRootET.text = asset.allAssetsRoot

-- 		refresh assets folder
-- 		curAllAssetsFolderET.text = asset.allAssetsFolder

-- 		refresh relative path
-- 		assetRelativePathET.text = asset.relativeFolder
		
-- 		refresh name
		if asset.name != undefined then curAssetNameET.text = asset.name else curAssetNameET.text = "UNDEFINED"

-- 		refresh version number
		if asset.lastVersion != undefined then versionET.text = returnDigit asset.lastVersion
		else versionET.text = "???"
		
-- 		refresh absolute version filename
		absPathET.text = asset.getLastVersionFile()
		
-- 		asset editable
		if doesfileexist (asset.getLastVersionFile()) == true then editableET.text = "true"
		else editableET.text = "false"
		
-- 		refresh thumbnail
		thumbFile =  asset.assetFolder + "\\" + "assetThumb.jpg"
		
		if doesfileexist thumbFile == true then assetBMP.filename = thumbFile
		else 
		(
-- 			print "no thumbnail"
			assetBMP.bitmap = bitmap 256 256 color:(color 125 125 125)
		)
		
-- 		refresh status
		if asset.status != undefined then statusET.text = asset.status
			
-- 		wip files
		files = getFiles (asset.wipfolder + "*")
		wipFilesCountET.text = files.count as string

	-- max version
		try
		(
		maxFileVersET.text = asset.getMaxFileVersion()
		)catch()
	)
	
	fn collectAssets root =
	(
		format "######Refresh Assets List#####\n"
		assetPathsArr = walkDir  root "assetInfo.ini"
		tmpAssetsList = #()
		for a in assetPathsArr do
		(
			try
			(
-- 				newAsset = assetClass()
				newAsset = assetCreationClass()
				newAsset.initFromIni a root
-- 				allAssetsFolder
				append tmpAssetsList newAsset
			)catch()
		)
		tmpAssetsList
	)
	
	fn refreshListBoxNew assetsAr =
	(
		
		rootET.text = root
		pathListDL.items = rootAr
		assetsBL.items = for o in assetsAr collect o.name	
-- 		pathListDL.items = for p in rootAr collect p
		
		if assetsAr.count >0 then
		(
			refreshEditGroup assetsAr[1]
-- 			refreshPublishGroup assetsAr[1]
		)
	)
	
	fn filterAssetsList assetsAr nameSearch:"" statusSearch: 1 =
	(
		tmpAsset = #()
		
		-- filter by name
		if nameSearch.count> 0 then
		(
			for a in assetsAr do
			(
				
				res = matchpattern a.name pattern: nameSearch
-- 				format "a.name: %, search: %, res: % \n" a.name nameSearch res
				if res then appendifunique tmpAsset a
				
-- 				res = findString a.name nameSearch
-- 				if res != undefined then appendifunique tmpAsset a
			)
		)
		else
		(
			tmpAsset = assetsAr
		)
		
		-- filter by status
		assetsToFilter = tmpAsset
		assetFilterred = #()
		if statusSearch>1 then
		(
			statusName = statusAr[statusDL.selection]
			
			for a in assetsToFilter where a.status == statusName do
			(
				append assetFilterred a
			)
		)
		else
		(
			assetFilterred = tmpAsset 
		)
		tmpAsset = assetFilterred
		
		-- sort by name
		qsort tmpAsset sortAssestbyname
		
		tmpAsset
	)
	
	/*
	fn sortMergedElts elts =
	(
		mergedElts = #()
		for o in elts do
		(
			if classof o == vraysun then delete o
			else if classof o == vrayplane then delete o
			else append mergedElts o
		)
		mergedElts
	)
	*/

	fn updateIni = 
	(
		setINISetting armadasScriptsIni "assetManager" "repositoryPath" root
		setINISetting armadasScriptsIni "assetManager" "repositoryPathAr" (rootAr as string)
	)
	
	fn refreshFromOutside =
	(
		assetsList = collectAssets root
		-- collect list to display
		assetsToDisplay = filterAssetsList assetsList nameSearch: nameSearchET.text statusSearch: statusDL.selection
		-- display list
		refreshListBoxNew assetsToDisplay
		
		if assetsToDisplay.count > 0 do	refreshEditGroup assetsToDisplay[assetsBL.selection]
	)
	
	
-- 	Actions
	on assetEditorRLT open do
	(
-- 		root = @"J:\_svn\zz_ressources3D"
		
		-- collect root
		rootArStr =  (getINISetting armadasScriptsIni "assetManager" "repositoryPathAr")
		if rootArStr.count > 0 then  rootAr = execute rootArStr else rootAr = #()
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		if rootIni.count > 0 then
		(
			if doesfileexist rootIni == true then
			(
				root = rootIni
				append rootAr rootIni
			)
		)
		else
		(
			root = ""
		)
		
		rootAr = makeuniquearray rootAr
		
		-- collect assets list
		assetsList = collectAssets root
		-- collect list to display
		assetsToDisplay = filterAssetsList assetsList
		-- display list
		refreshListBoxNew assetsToDisplay
	)
	
	on assetEditorRLT close do updateIni()
	
	on findFolderBT pressed do
	(
		if root != undefined then res = getSavePath caption: "chose folder"  initialDir: root
		else res = getSavePath caption: "chose folder" 

		if res != undefined then
		(
			print res
			root = res
			
			-- collect assets list
			assetsList = collectAssets root
			-- collect list to display
			assetsToDisplay = filterAssetsList assetsList
			
			-- update path array
			insertItem res rootAr 1
			rootAr = makeuniqueArray rootAr
			if rootAr.count > 10 then deleteItem rootAr 11
			 
			-- display list
			refreshListBoxNew assetsToDisplay
			
			updateIni()
		)
		else
		(
			print "fail!"
		)
	)
	
	on pathListDL selected  val do
	(
		
		if rootAr[val] != undefined then
		(
			local res = rootAr[val]
			
			root = res
			
			-- collect assets list
			assetsList = collectAssets root
			-- collect list to display
			assetsToDisplay = filterAssetsList assetsList
			
			-- update path array
			insertItem res rootAr 1
			rootAr = makeuniqueArray rootAr
			if rootAr.count > 10 then deleteItem rootAr 11
			 
			-- display list
			refreshListBoxNew assetsToDisplay
			
			updateIni()
			
			pathListDL.selection = 1
		)
	)
	
		
	on createAssetBT pressed do filein "assetCreatorUI3.ms"
		
	on createAssetFromSelBT pressed do 
	(
		sel = selection as array
		if sel.count > 0 then filein "assetCreatorFromSelectionUI2.ms"
		else print "make selection first"
	)
	
	on publishRolloutBT pressed do
	(
		-- check if we are in asset
		infoTest = getUpperFolder maxFilePath + "assetInfo.ini"
			-- find assetInfo.ini file
		res = doesfileexist infoTest 
		
		if res then
		(
-- 			root = rof.rollouts[2].root
			currentAsset = assetClass()
			currentAsset.initFromIni infoTest root
			createdialog publishVersionRLT
-- 			publishVersionRLT.currentAsset = currentAsset
		)
		else (print "this is not an asset")
	)
	
	on createAssetBT3 pressed do
	(
		createdialog createAssetRLT width: 800
		createAssetRLT.initForScene()
	)
	
	on createAssetFromSelBT3 pressed do
	(
		sel = selection as array
		if sel.count > 0 then createdialog createAssetRLT width: 800
		createAssetRLT.initForSelection()
	)
	
	on publishRolloutBT3 pressed do
	(
		createdialog createAssetRLT width: 800
		createAssetRLT.initForPublishing()
	)
	
	on collectAssetBT pressed do
	(
		-- collect assets list
		assetsList = collectAssets root
		-- collect list to display
		assetsToDisplay = filterAssetsList assetsList
		-- display list
		refreshListBoxNew assetsToDisplay
	)
	
	on nameSearchET changed val do
	(
		assetsToDisplay = filterAssetsList assetsList nameSearch: val
		-- display list
		refreshListBoxNew assetsToDisplay
	)
	
	on statusDL selected val do
	(
		assetsToDisplay = filterAssetsList assetsList statusSearch: val
		refreshListBoxNew assetsToDisplay
	)
	
	on assetsBL selected obj do
	(
		refreshEditGroup assetsToDisplay[obj]
-- 		refreshPublishGroup assetsToDisplay[obj]
	)
	
	on openBT pressed do
	(
		if assetsBL.selection > 0 then
		(
			asset = assetsToDisplay[assetsBL.selection]
-- 			print asset.assetFolder
			doscommand ("explorer " + asset.assetFolder)
		)
	)
		
	on editBT2 pressed do
	(
		asset = assetsToDisplay[assetsBL.selection]
		
		wipFile = asset.createWipFile()
		if checkForSave() do loadMaxFile wipFile useFileUnits: true
		
-- 		try refreshListBox() catch(format "*** % ***\n" (getCurrentException()))
		refreshEditGroup assetsToDisplay[assetsBL.selection]
		format "Asset Edited: %\n" wipFile
	)
	
	on newMaxBT2 pressed do
	(
		asset = assetsToDisplay[assetsBL.selection]
		wipFile = asset.createWipFile()
		if doesFileExist wipFile do shellLaunch (GetDir #maxroot + "3dsmax.exe") wipFile
	)
	

	on mergeBT3 pressed do
	(
		asset = assetsToDisplay[assetsBL.selection]
		ctrl = asset.mergeAsset3 ignoreVrSet: ignoreVrCB.state ignoreCacheLay: ignoreCacheCB.state
-- 		print ctrl
		select ctrl
	)
	
	on cleanWipFolderBT pressed do
	(
-- 		print "youhou"
		asset = assetsToDisplay[assetsBL.selection]
-- 		print asset.wipfolder
		files = getFiles (asset.wipfolder + "*")
		for f in files do deletefile f
			
		refreshEditGroup asset
	)
)

-- try(destroyDialog assetEditorRLT)catch()
try(closeRolloutFloater  rof)catch()
rof= newrolloutfloater "Asset Editor" 600 900

addrollout externalToolsRLT rof
addrollout assetEditorRLT rof


-- rof.rollouts[2].assetslist
-- createdialog assetEditorRLT width: 200
