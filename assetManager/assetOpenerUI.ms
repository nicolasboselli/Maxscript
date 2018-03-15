-- asset opener

-- open in new max instance
-- shellLaunch (GetDir #maxroot + "3dsmax.exe") @"J:\_svn\zz_ressources3D\ELEMENTS_IMMOBILIERS\rc_gc_verre\001\rc_gc_verre.max"

/*
maj:
	/- filter by name
		-- add * add begining and end of search	
		
	x-- filter by status (all, approved, wip, retake, archived)
		-- add ignore achive
	
	-- update wip name after publishing
	
	-- deplace publish method in asset structure
	-- deplace edit method in asset structure
	-- revoir le systeme d enregistrement en passant par un wip

	-- clean wip folder
	-- clean old version (work only with first and last version)
	-- add comments
	/- add history in repository
	
	-- ouvrir l'asset dans une autre instance de 3ds max

debug:
	x- parent hidden object
	-- error when change status on lastselection
	
prob:
	-- when merging list merged objects?
		
*/


filein "assetManagerDef.ms"

rof

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
	
-- 	allAssetsRoot,
-- 	allAssetsFolder,
-- 	relativeFolder,
-- 	relativeFolder2,
	name,
	lastVersion,
	
	root,

	wipFolder,
	
	versionInfo,
	lastVersionFile,
	
	relVersPath,
	
	status,
	
	/*
	fn returnRootPath onePath folderName=
	(
		oneRoot
		count = findString onePath folderName
		subTest = substring onePath 1 (count - 2)
		rootTmp = subTest -- + folderName
		
		if (getDirectories rootTmp).count > 0 then oneRoot = (rootTmp + "\\") else oneRoot = undefined
		oneRoot
	),
	
	fn returnRelativeFolder onePath folderName  =
	(
		count = findString onePath folderName
		subTest = substring onePath count -1
		relPathTmp = substituteString  subTest folderName  ""
		relPathTmp
	),
	
	fn returnRelativeFolder2 onePath folderName oneName =
	(		
		count = findString onePath folderName
		subTest = substring onePath count -1
		relPathTmp = substituteString  subTest folderName  ""
		relPath = cleanFilename(substituteString  relPathTmp oneName  "")
		relPath
	),
	
	fn returnLastVersionFile versionInfoFile =
	(
		oneLastVersionFile = undefined
		if doesfileexist versionInfoFile == true then
		(
			versionFileTmp = (getFilenamePath versionInfo) + name + ".max"
			if doesfileexist versionFileTmp == true then oneLastVersionFile = versionFileTmp
		)
		oneLastVersionFile
	),
	
	fn returnLastVersionRelativeFile =
	(
		tmp = relativeFolder + (returnDigit lastVersion) +"\\" + name + ".max"
		tmp
	),
	*/
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
		
		print ("asset created: " + name)
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
	
	fn mergeAsset ignoreCache: false =
	(
		assetCtrl = undefined
		lastVersionFile
		
		objStrAr = getMAXFileObjectNames lastVersionFile
		res = mergeMAXFile lastVersionFile  #useSceneMtlDups #mergeDups
		
		if res == true then
		(
			-- asset  creation
			LM = layermanager
			assetCtrl = point name: (uniquename( name + "_ctrl")) size: 200
			assetsLayer = LM.getLayerFromName "assets_layer"
			if assetsLayer == undefined do assetsLayer = LM.newLayerFromName "assets_layer"
				
			assetsLayer.addnode assetCtrl
			
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
			
			mergedElts = #()
			
			-- objects merged treatment
			for str in objStrAr do
			(
				o = getnodebyname str
				deletion = false
				
				if classof o == vraysun or classof o == vrayplane or  classof o == targetcamera then deletion = true
				else if o.layer.name == "cache_layer" then deletion = true
					
				if deletion == true then delete o
				else
				(
					if  o.parent == undefined then 	o.parent = assetCtrl
					o.name = name + o.name
				)
			)
		)
		assetCtrl
	),
	
	fn getLastVersionFile =
	(
		lastVersionFile = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) + "\\" + name + ".max")
		lastVersionFile
	)

)

rollout publishVersionRLT "publish asset" width: 400
(
	local currentAsset
	local statusAr = #("none","approved","wip","retake", "archive" )
	
	edittext assetNameET "asset name:" readonly: true
	editText nextVersionET "next version:" readonly: true
	dropdownlist statusDL "status:" 
	button publishBT "publish version"
	
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
			publishBT.enabled = true
		)
		else
		(
			publishBT.enabled = false
		)
	)
	
	on publishVersionRLT open do
	(
		-- init rollout
		currentAsset = rof.rollouts[1].currentAsset
		statusDL.items = statusAr
		
		-- set rollout
		if currentAsset != undefined do refreshPublishRlt currentAsset
	)
	
	on statusDL selected arg do
	(
		currentAsset.status = statusAr[arg]
	)
	
	on publishBT pressed do
	(
		print "publishing started"
		
		-- create new version folder
		newFolder = currentAsset.assetFolder +"\\" +  (returnDigit(currentAsset.lastVersion + 1))
		folderCreated = makedir newFolder all: true
		
		-- save new version file
		local newFile
			
		if folderCreated == true then
		(
			newFile =  newFolder + "\\" + currentAsset.name + ".max" 
			newfileCreated = saveMaxFile newFile useNewFile: false
			print newfileCreated
		)
		
		if newfileCreated == true then
		(
			currentAsset.lastVersion = currentAsset.lastVersion + 1
			currentAsset.lastVersionFile = newFile
			
			-- update asset info file
			currentAsset.updateAssetFileInfo()
			
			-- create version info file
			currentAsset.createVersionFileInfo()
		)
		else
		(
-- 			delete folder
		)

		-- collect assets list
		rof.rollouts[2].refreshFromOutside()
		
		print "publishing done"
		
		destroyDialog publishVersionRLT
	)
)


rollout externalToolsRLT "asset tools"
(
	local currentAsset
	
	group "create asset:"
	(
		button createAssetBT "from scene..." across:2
		button createAssetFromSelBT "from selection..." 
	)
	group "publishing:"
	(
		button publishRolloutBT "publish asset..."
	)
	
	button assetToolsBT "asset tools..." across:2
	button updateToolsBT "update tools..."
	
	on createAssetBT pressed do filein "assetPublisherUI.ms"
	on createAssetFromSelBT pressed do 
	(
		sel = selection as array
		if sel.count > 0 then filein "assetCreatorFromSelectionUI.ms"
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
			root = rof.rollouts[2].root
			currentAsset = assetClass()
			currentAsset.initFromIni infoTest root
			createdialog publishVersionRLT
		)
		else (print "this is not an asset")
	)
	
	on assetToolsBT pressed do filein "assetManagerTools.ms"
	on  updateToolsBT pressed do filein "updateAssetTool.ms"
)


rollout assetEditorRLT "assets editor"
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
-- 	UI
-- 	edittext allAssetsFolderET "the \"all assets\" folder name:" text: allAssetsFolder readonly: true
	group "Assets Repository:"
	(
		edittext rootET "Path:" readonly: true
		button findFolderBT "..."
		dropdownlist pathListDL "Paths: " readonly: true height: 11
	)
	
	group "filters:"
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
		checkbox ignoreCacheCB "ignore cache_layer" across: 3
		checkbox ignoreVrCB "ignore sun, camera and vrayplane" enabled: false
		checkbox createAsAssetCB "create as asset" enabled: false
		button mergeBT "merge"
	)
	
	group "Asset selected infos:"
	(
		
		
-- 		edittext curAssetRootET "assets root: " readonly: true
-- 		edittext curAllAssetsFolderET "all assets folder: " readonly: true
-- 		edittext assetRelativePathET "asset relative path: " readonly: true
		edittext curAssetNameET "asset name:" readonly: true
		edittext versionET "last version:" readonly: true
		
		edittext absPathET "absolute path" readonly: true
-- 		edittext relVersionET "relative version" readonly: true
		
		edittext statusET "status" readonly: true
		edittext editableET "asset editable" readonly: true
 		
-- 		edittext openStatusET "status:"  readonly: true
-- 		edittext  openTagsET "tags:" readonly: true
		
-- 		checkbox instanceCB "new max instance"
		button openBT "open folder" across:3
		button editBT "edit" 
		button newMaxBT "edit in new max instance" 
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
			print "no thumbnail"
			assetBMP.bitmap = bitmap 256 256 color:(color 125 125 125)
		)
		
-- 		refresh status
		if asset.status != undefined then statusET.text = asset.status
	)
	
	fn collectAssets root =
	(
		assetPathsArr = walkDir  root "assetInfo.ini"
		tmpAssetsList = #()
		for a in assetPathsArr do
		(
			try
			(
				newAsset = assetClass()
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
				res = findString a.name nameSearch
				if res != undefined then appendifunique tmpAsset a
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
		asset = assetsToDisplay[assetsBL.selection]
		print asset.assetFolder
		doscommand ("explorer " + asset.assetFolder)
	)
	
	on editBT pressed do
	(
		asset = assetsToDisplay[assetsBL.selection]

		assetFile =  asset.getLastVersionFile()
		
		print ("assetfile: " + assetFile)
		
		if assetFile.count>0 then
		(
			if doesFileExist assetFile == true then
			(
				vers = asset.lastVersion
				assetName = asset.name
				wipFolder = asset.wipFolder
				print wipFolder
				
				wipFile = wipFolder + "\\" + assetName +"_" + returnDigit vers + "_" + "wip" + "_" + (localTimeStr()) + "_v00.max"

				test = copyFile assetFile wipFile
				if test == true then
				(
					if checkForSave()  == true do loadMaxFile wipFile useFileUnits: true
				)
				else print "wip copy fail"
			)
			else print "can't find file"
		)
		else print "uncorrect filename"

		
		refreshEditGroup assetsToDisplay[assetsBL.selection]
-- 		refreshPublishGroup assetsToDisplay[assetsBL.selection]
	)
	
	on newMaxBT pressed do
	(
				asset = assetsToDisplay[assetsBL.selection]

		assetFile =  asset.getLastVersionFile()
		
		print ("assetfile: " + assetFile)
		
		if assetFile.count>0 then
		(
			if doesFileExist assetFile == true then
			(
				vers = asset.lastVersion
				assetName = asset.name
				wipFolder = asset.wipFolder
				print wipFolder
				
				wipFile = wipFolder + "\\" + assetName +"_" + returnDigit vers + "_" + "wip" + "_" + (localTimeStr()) + "_v00.max"

				test = copyFile assetFile wipFile
				if test == true then
				(
						shellLaunch (GetDir #maxroot + "3dsmax.exe") wipFile
				)
				else print "wip copy fail"
			)
			else print "can't find file"
		)
		else print "uncorrect filename"

		
		refreshEditGroup assetsToDisplay[assetsBL.selection]
-- 		refreshPublishGroup assetsToDisplay[assetsBL.selection]
	)
	
	on mergeBT pressed do
	(
		asset = assetsToDisplay[assetsBL.selection]
		ctrl = asset.mergeAsset ignoreCache: ignoreCacheCB.state
-- 		print ctrl
		select ctrl
	)
)


-- try(destroyDialog assetEditorRLT)catch()
try(closeRolloutFloater  rof)catch()
rof= newrolloutfloater "Asset Editor" 600 900

addrollout externalToolsRLT rof
addrollout assetEditorRLT rof

-- rof.rollouts[2].assetslist
-- createdialog assetEditorRLT width: 200
