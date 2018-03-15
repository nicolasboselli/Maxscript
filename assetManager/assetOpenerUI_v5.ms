-- asset opener

/*
maj:
	x- filter by name
		x- add * add begining and end of search	
		
	x- avertir quand on veut publier un asset sans avoir selectionner le bon repertoire dans l assetOpener
	
	-- incrementer la prochaine version de wip
		
	-- filter by status (all, approved, wip, retake, archived)
		-- add ignore archive
	
	/- choix de la version de max à l'enregistrement en option
		x- fonctionnel sur le publish de version
		-- rendre fonctionnel à la creation

	-- clean old version (garder seulement la première et la dernière version)
	-- add comments
	-- delete/ rename asset
	
	-- option au merge
		-- mettre le choix de la tache et de la version au merge
		-- proposer merge ou xref scene ou xref object
		-- toggle force use scene material
		-- activer le toggle "create as asset"(rename "merge as asset")
			--  force:
				-- un rename en respectant le bsename et l'instance num
				-- la creation d'un point ctrl
				-- la parenté au point ctrl
	
	/- ouvrir le dernier wip 
		
	-- publier un version "merge ready" à coté du dossier d'asset
		-- supprimer les sun, cam et cache_layer
	
	/- tester le fichier le plus recent entre le dernier wip et le dernier publish
		x- prob: il y a toujours ou souvent un wip aprés le publish
		/- proposer d'ouvrir la version la plus recente
			-- distinguer les versions wip des version publish pour publier la bonne version
		
	-- ajouter une fonction "substitute"
	-- ajouter une fonction "merge picker"
	-- ajouter créer un asset vide
	
	x- faire apparaitre la prévue dans une fenetre separée
		-- afficher le nom de l'asset dans la barre de titre
		
debug:
	x- parent hidden object
	-- error when change status on lastselection
	x- error quand enregistre asset et que le path selectionner ne correspond pas
	-- error: "rollouts"
	x- merge impossible quand on ne choisi pas comme repository le dossier parent des asset
	x- crash au publish en version 2017
	x- voir si le parametre assetOp passe bien
	
rebuild:
	x- tester la fenetre de publish des asset comme modal
	-- selection de la tache et de la version a editer:
		/- créer une methode qui retoune le fichier selectionner à editer en passant à parametre les selections dans l ui
			-- faire fonctionner avec les version "without"
			-- mettre à jour le fichier selectionne au changement de version selectionnée
			-- prendre en compte les wip existant pour proposer un nouveau wip
			
		
*/

global assetEditorRLT

filein "assetCreatorUI7.ms"
filein "assetManagerDef.ms"

-- rof

fn sortAssestbyname v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (toLower v1.assetName) < (toLower v2.assetName)) then
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
	local assetArr = #()
    local dirArr = GetDirectories (dir + "\\*")
 
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


rollout externalToolsRLT "asset tools"
(
	local currentAsset
	
	group "tools:"
	(
		button assetToolsBT "asset tools..." across:2
		button updateToolsBT "update tools..."
	)
	
	on assetToolsBT pressed do filein "assetManagerTools.ms"
	on updateToolsBT pressed do filein "updateAssetTool2.ms"
)


rollout openThumbRLT "Thumb"
(
	bitmap assetBMP "asset thumbnail" width: 256 height: 256
)


rollout assetEditorRLT "assets editor v2"
(
	local tooltip = "ldfijdlifh"
	
	local assetOp = 0
	
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	
-- 	local allAssetsFolder = "zz_ressources3D"
	local root 
	local rootAr = #()
	
	local assetPathsArr = #()
	local assetsList = #()
	local assetsToDisplay = #()
	
	local statusAr = #("all","none","approved","wip","retake", "archive" )
	local currentAsset
	
	local changeAsset = false
	local changeTask = false
	local changeMergeTask = false
	
-- 	local bmpOpened = false
	
-- 	UI
-- 	edittext allAssetsFolderET "the \"all assets\" folder name:" text: allAssetsFolder readonly: true
	group "Assets Repository:"
	(
		dropdownlist pathListDL "History Paths: " readonly: true height: 11
		edittext rootET "Path:" readonly: true
		button findFolderBT "..."
	)
	/*
	group "Asset Creation:"
	(
		button createAssetBT "from scene..." across:3
		button createAssetFromSelBT "from selection..." 
		button publishRolloutBT "publish..."
	)
	*/
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
		button collectAssetBT "refresh" across: 2
		button openThumbBT "Thumbnail"
	)
-- 	rof.rollouts[2].assetsList[1].name
	group "Merge:"
	(
		dropdownlist  mergetaskListDL "task:"  across: 2
		dropdownlist mergetaskVersListDL "last published version:"
		checkbox ignoreCacheCB "ignore cache_layer" checked: true across: 4
		checkbox ignoreVrCB "ignore vray set" checked: true -- enabled: false 
		checkbox createAsAssetCB "create as asset" enabled: false
-- 		button mergeBT "merge"
		button mergeBT3 "merge v3"
	)
	
	group "Edit:"
	(
		edittext lastestFilenameET "latest asset selected filename:" readonly: true
		button openLatestBT "open latest"
		edittext wipSelLastFileET "last asset selected wip filename:" readonly: true
		button openWip2BT "open last wip"
		dropdownlist  taskListDL "task:"  across: 2
		dropdownlist versionDL "last published version:"
		edittext editSelFileET "asset selected version filename:" readonly: true
		edittext wipSelFileET "next asset selected version wip filename:" readonly: true
		button editAssetBT "edit v3" across: 2
		button editAssetInNewMaxBT "edit in new max instance v3"
	)
	
	
	group "Asset selected infos:"
	(
		
		
-- 		edittext curAssetRootET "assets root: " readonly: true
-- 		edittext curAllAssetsFolderET "all assets folder: " readonly: true
-- 		edittext assetRelativePathET "asset relative path: " readonly: true
		edittext curAssetNameET "asset name:" readonly: true
		
		edittext taskET "task:" readonly: true -- across: 2
		
		edittext versionET "last published version:" readonly: true -- across: 2
		
		edittext mostRecentVersionET "last file version:" readonly: true tooltip: tooltip
		
		edittext absPathET "last editable file version:" readonly: true

-- 		edittext relVersionET "relative version" readonly: true
		
		edittext statusET "status:" readonly: true
		edittext editableET "asset editable:" readonly: true
		edittext wipFilesCountET "wip files count:" readonly: true
		edittext maxFileVersET "max version:" readonly: true
 		
-- 		edittext openStatusET "status:"  readonly: true
-- 		edittext  openTagsET "tags:" readonly: true
		
-- 		checkbox instanceCB "new max instance"
		button openBT "open folder" width: 160 across:3
		button openWipBT "open wip folder" width: 160
		button saveInWipBT "save in wip"  width: 160
-- 		button editBT "edit" 
		button editBT2 "edit v2" width: 160 across: 3
-- 		button newMaxBT "edit in new max instance" across:3
		button newMaxBT2 "edit in new max instance v2" width: 160
		button cleanWipFolderBT  "clean wip folder" width: 160
-- 		button openLatestBT "open latest" width: 160 --across:3 tooltip: tooltip
		
-- 		bitmap assetBMP "asset thumbnail" width: 256 height: 256 visible: true
		
-- 		button updateBT "update"
	)
	
	
	
	fn refreshEditGroup asset =
	(	
-- 		refresh name
		if asset.assetName != undefined then curAssetNameET.text = asset.assetName else curAssetNameET.text = "UNDEFINED"
		
-- 		refresh task listbox
		local bakSel = taskListDL.selection
		local mergeBakSel  = mergetaskListDL.selection
				
		local taskVersionList = asset.getMaxFilesCount2()
		
		local lastTask
		
		local taskListRC = #()
		for i = 1 to taskVersionList.count do
		(
			if taskVersionList[i].count > 0 then
			(
				lastTask = taskList[i]
				append taskListRC taskList[i]
			)
		)
		
		taskET.text = lastTask
		
		taskListDL.items = for t in taskListRC collect t
		mergetaskListDL.items =  for t in taskListRC collect t
-- 		taskListDL.selection = taskListDL.items.count
		
		if baksel > 0 and baksel < taskListDL.items.count and not changeAsset then taskListDL.selection = bakSel else taskListDL.selection = taskListDL.items.count
		if mergeBakSel > 0 and mergeBakSel < mergetaskListDL.items.count and not changeAsset then mergetaskListDL.selection = mergeBakSel else mergetaskListDL.selection = mergetaskListDL.items.count
-- 		format "baksel: % taskListDL.selection: % taskListDL.items.count: %\n" bakSel taskListDL.selection taskListDL.items.count
		
-- 		refresh version number
		local versBakSel = versionDL.selection
		local mergeVersBakSel = mergetaskVersListDL.selection
		
		local id = finditem taskList taskListDL.selected
		local mergeId = finditem taskList mergetaskListDL.selected
-- 		format "id: %   taskListDL.selection: % taskVersionList[id]: %\n" id   taskListDL.selected taskVersionList[id]
		versionDL.items = for n in taskVersionList[id] collect (n as string)
		mergetaskVersListDL.items = for n in taskVersionList[mergeId] collect (n as string)
		
		if versBakSel > 0 and versBakSel < versionDL.items.count and not changeAsset and not changetask then versionDL.selection = versBakSel else versionDL.selection = versionDL.items.count
		if mergeVersBakSel > 0 and mergeVersBakSel < mergetaskVersListDL.items.count and not changeAsset and not changeMergeTask then mergetaskVersListDL.selection = mergeVersBakSel else mergetaskVersListDL.selection = mergetaskVersListDL.items.count
		
		if asset.lastVersion != undefined then versionET.text = returnDigit asset.lastVersion
		else versionET.text = "???"
		
-- 		refresh absolute version filename
		absPathET.text = asset.getLastVersionFile()
		
-- 		refresh du fichier le plus recent
		mostRecentVersionET.text =  asset.getLatestFile()
		mostRecentVersionET.tooltip = asset.getLatestFile()
		
-- 		asset editable
		if doesfileexist (asset.getLastVersionFile()) == true then editableET.text = "true"
		else editableET.text = "false"
		
-- 		refresh status
		if asset.status != undefined then statusET.text = asset.status
			
-- 		wip files
		files = getFiles (asset.getWipFolder() + "*")
		wipFilesCountET.text = files.count as string

	-- max version
		try
		(
			maxFileVersET.text = asset.getMaxFileVersion()
		)catch()
		
		
	--	refresh thumbnail
		thumbFile =  asset.assetFolder + "\\" + "assetThumb.jpg"
		
		if doesfileexist thumbFile == true then
		(
			if openThumbRLT.open then openThumbRLT.assetBMP.filename = thumbFile
		)
		else 
		(
			if openThumbRLT.open  then openThumbRLT.assetBMP.bitmap = bitmap 256 256 color:(color 125 125 125)
		)
		
	/*MERGE INFOS
		
	/* EDIT INFOS */
--		 asset selected version
		local assetSelFilename = asset.getEditableFileSelected taskListDL.selected (versionDL.selected as integer)
		if assetSelFilename != undefined then
		(
			editSelFileET.text = assetSelFilename
			editSelFileET.tooltip = assetSelFilename
		)
		else  
		(
			editSelFileET.text = "NONE"
			editSelFileET.tooltip = "NONE"
		)
		
-- 		asset selected wip filename
		wipSelFileET.text = asset.getNextWipFilename taskListDL.selected (versionDL.selected as integer)
		wipSelFileET.tooltip = asset.getNextWipFilename taskListDL.selected (versionDL.selected as integer)
		
-- 		last asset wip selection
		local assetLastWipFilename = asset.getLastWipFilename()
		if assetLastWipFilename != undefined then 
		(
			wipSelLastFileET.text = assetLastWipFilename
			wipSelLastFileET.tooltip = assetLastWipFilename
		)	
		else  
		(
			wipSelLastFileET.text = "NONE"
			wipSelLastFileET.tooltip = "NONE"
		)
		
			
-- 		latest asset filename
		local assetLastestFilename = asset.getLatestFile()
		if assetLastestFilename != undefined then 
		(
			lastestFilenameET.text = assetLastestFilename
			lastestFilenameET.tooltip = assetLastestFilename
		)	
		else  
		(
			lastestFilenameET.text = "NONE"
			lastestFilenameET.tooltip = "NONE"
		)
	)
	
	fn collectAssets root =
	(
		format "######Refresh Assets List#####\n"
		assetPathsArr = walkDir  root "assetInfo.ini"
		-- for a in assetPathsArr do format "assetPath: %\n" a
		tmpAssetsList = #()
		for a in assetPathsArr do
		(
			try
			(
-- 				newAsset = assetClass()
				newAsset = assetCreationClass()
				newAsset.initFromIni a --root
-- 				allAssetsFolder
				append tmpAssetsList newAsset
			)catch()
		)
		-- for a in tmpAssetsList do format "asset: %\n" a
		tmpAssetsList
	)
	
	fn refreshListBoxNew assetsAr =
	(
		local bakSel = assetsBL.selection
-- 		format "bakSel: %\n" bakSel
		rootET.text = root
		pathListDL.items = rootAr
		assetsBL.items = for o in assetsAr collect o.assetName	
-- 		pathListDL.items = for p in rootAr collect p
		
		if  bakSel > 0 and assetsAr.count >= bakSel then
		(
			refreshEditGroup assetsAr[bakSel]
-- 			refreshPublishGroup assetsAr[1]
		)
		/*
		else
		(
			refreshEditGroup assetsAr[1]
		)
		*/
	)
	
	fn filterAssetsList assetsAr nameSearch:"" statusSearch: 1 =
	(
		tmpAsset = #()
		
		-- filter by name
		if nameSearch.count> 0 then
		(
			for a in assetsAr do
			(
				
				res = matchpattern a.assetName pattern: nameSearch
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
		format "root: %, rootAr: %\n" root rootAr
		if root != undefined then setINISetting armadasScriptsIni "assetManager" "repositoryPath" root
		setINISetting armadasScriptsIni "assetManager" "repositoryPathAr" (rootAr as string)
	)
	/*
	fn refreshFromOutside =
	(
		assetsList = collectAssets root
		-- collect list to display
		assetsToDisplay = filterAssetsList assetsList nameSearch: nameSearchET.text statusSearch: statusDL.selection
		-- display list
		refreshListBoxNew assetsToDisplay
		
		if assetsToDisplay.count > 0 do	refreshEditGroup assetsToDisplay[assetsBL.selection]
	)
	*/
	
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
			if doesfileexist rootIni then
			(
				root = rootIni
				append rootAr rootIni
			)
			else
			(
				root = ""
			)
		)
		else
		(
			root = ""
		)
		
		

		format "rootini: % root:%\n" rootini root --to: logStr

		-- nettoyage de l'array de chemin
		rootAr = for r in rootAr where doesfileexist r collect r
		rootAr = makeuniquearray rootAr
		
		-- collect assets list
		assetsList = collectAssets root
		-- collect list to display
		assetsToDisplay = filterAssetsList assetsList
		-- display list
		refreshListBoxNew assetsToDisplay
	)
	
	on assetEditorRLT close do 
	(
		updateIni()
		if openThumbRLT.open then destroydialog openThumbRLT
-- 		try(destroydialog openThumbRLT)catch()
	)
	
	on findFolderBT pressed do
	(
		if root != undefined then res = getSavePath caption: "chose folder"  initialDir: root
		else res = getSavePath caption: "chose folder" 

		if res != undefined then
		(
			format "root selected: %\n" res
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
	
	on createAssetBT3 pressed do
	(
		assetOp = 1
		createdialog createAssetRLT width: 800 modal: true
		
		-- collect assets list
		assetsList = collectAssets root
		-- collect list to display
		assetsToDisplay = filterAssetsList assetsList
		-- display list
		refreshListBoxNew assetsToDisplay
		
	)
	
	on createAssetFromSelBT3 pressed do
	(
		assetOp = 2
		sel = selection as array
		if sel.count > 0 then createdialog createAssetRLT width: 800 modal: true
-- 		createAssetRLT.initForSelection()
-- 		refreshFromOutside()
		
		-- mettre optionel le refresh à 'update de publish
		-- collect assets list
		assetsList = collectAssets root
		-- collect list to display
		assetsToDisplay = filterAssetsList assetsList
		-- display list
		refreshListBoxNew assetsToDisplay
	)
	
	on publishRolloutBT3 pressed do
	(
		assetOp = 3
		format "assetop: %\n" assetEditorRLT.assetOp
		createdialog createAssetRLT width: 800 modal: true
-- 		refreshFromOutside()
		
		-- collect assets list
		assetsList = collectAssets root
		-- collect list to display
		assetsToDisplay = filterAssetsList assetsList
		-- display list
		refreshListBoxNew assetsToDisplay
		
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
	
	on openThumbBT pressed do
	(
		try(destroydialog openThumbRLT)catch()
-- 		bmpOpened = true
		createdialog openThumbRLT width: 300
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
		changeAsset = true
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
	
	on openWipBT pressed do
	(
		if assetsBL.selection > 0 then
		(
			asset = assetsToDisplay[assetsBL.selection]
-- 			print asset.assetFolder
			res = getOpenFileName caption: "open wip file" filename:(asset.getWipFile()) types:"Max(*.max)|*.max|All|*.*|"
			if res != undefined then loadMaxFile res
		)
	)
	
	on saveInWipBT pressed do
	(
		if assetsBL.selection > 0 then
		(
			local asset = assetsToDisplay[assetsBL.selection]
-- 			print asset.assetFolder
			format "asset.getWipFile(): %\n" (asset.getWipFile())
			res = getSaveFileName  caption: "save in wip folder" filename:(asset.getWipFile()) types:"Max(*.max)|*.max|All|*.*|"
-- 			res = getSaveFileName  caption: "save in wip folder" filename:(asset.getWipFolder()) types:"Max(*.max)|*.max|All|*.*|"
				
-- 				getWipFolder
			if res != undefined then saveMaxFile res useNewFile: true
		)
	)
		
	on editBT2 pressed do
	(
		local asset = assetsToDisplay[assetsBL.selection]
		local taskVersionList = asset.getMaxFilesCount2 ()
-- 		for t in taskVersionList do sort t
		
-- 		local wipFile = asset.createWipFile()
		local wipFile = asset.createWipFile2 "without" taskVersionList[1][taskVersionList[1].count]
		
		if checkForSave() do loadMaxFile wipFile useFileUnits: true
		
-- 		try refreshListBox() catch(format "*** % ***\n" (getCurrentException()))
		refreshEditGroup assetsToDisplay[assetsBL.selection]
		format "Asset Edited: %\n" wipFile
	)
	
	on newMaxBT2 pressed do
	(
		local asset = assetsToDisplay[assetsBL.selection]
		local taskVersionList = asset.getMaxFilesCount2 ()
		
-- 		wipFile = asset.createWipFile()
		local wipFile = asset.createWipFile2 "without" taskVersionList[1][taskVersionList[1].count]
		if doesFileExist wipFile do shellLaunch (GetDir #maxroot + "3dsmax.exe") wipFile
	)
	

	on mergeBT3 pressed do
	(
		asset = assetsToDisplay[assetsBL.selection]
		local count = asset.countInstNumInScene()
		
		local ctrl = asset.mergeAsset3 ignoreVrSet: ignoreVrCB.state \
		ignoreCacheLay: ignoreCacheCB.state \
		instNum: (count + 1) \
		task: mergetaskListDL.selected \
		taskversion: (mergetaskVersListDL.selected as integer)
-- 		print ctrl
		select ctrl
	)
	
	on taskListDL selected val do
	(
		changeAsset = false
		changeTask = true
		refreshEditGroup assetsToDisplay[assetsBL.selection]
	)
	
	on versionDL selected val do
	(
		changeAsset = false
		changeTask = false
		refreshEditGroup assetsToDisplay[assetsBL.selection]
	)
	
	on mergetaskListDL selected val do
	(
		changeAsset = false
		changeMergeTask = true
		
		refreshEditGroup assetsToDisplay[assetsBL.selection]
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
	
	on openLatestBT pressed do
	(
		-- si la derneière version est un wip alors ouvrir le fichier
		-- si la dernière version est un publish alors créer une version wip
	)
	
	on editAssetBT pressed do
	(
		local asset = assetsToDisplay[assetsBL.selection]
		local taskVersionList = asset.getMaxFilesCount2 ()
		
		local wipFile = asset.createWipFile2 taskListDL.selected (versionDL.selected as integer)
		
		if checkForSave() do loadMaxFile wipFile useFileUnits: true
		
-- 		try refreshListBox() catch(format "*** % ***\n" (getCurrentException()))
		refreshEditGroup assetsToDisplay[assetsBL.selection]
		format "Asset Edited: %\n" wipFile
	)
	
	on editAssetInNewMaxBT pressed do
	(
		local asset = assetsToDisplay[assetsBL.selection]
		local taskVersionList = asset.getMaxFilesCount2 ()
		
		local wipFile = asset.createWipFile2 taskListDL.selected (versionDL.selected as integer)
		
		if doesFileExist wipFile do shellLaunch (GetDir #maxroot + "3dsmax.exe") wipFile
		
		-- 		try refreshListBox() catch(format "*** % ***\n" (getCurrentException()))
		refreshEditGroup assetsToDisplay[assetsBL.selection]
		format "Asset Edited: %\n" wipFile
	)
)



-- try(destroyDialog assetEditorRLT)catch()
try(closeRolloutFloater  rof)catch()
rof= newrolloutfloater "Asset Editor" 600 900

addrollout externalToolsRLT rof
addrollout assetEditorRLT rof

