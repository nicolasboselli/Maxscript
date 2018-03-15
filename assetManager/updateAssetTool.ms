
filein "assetManagerDef.ms"


fn collectAssetInScene =
( 
	assetsAr = #()
	pointsAr = for h in helpers where classof h == point collect h
-- 	print pointsAr
	for o in pointsAr do
	(
		test = getUserProp o "asset"
-- 		print(getUserProp o "asset")
		if test == true do 
		(
			append assetsAr o
		)
	)
-- 	print assetsAr
	assetsAr
)


struct assetInScene
(
	obj,
	name,
	version,
	root,
	versionFile,
	assetFolder,
	assetIni,
	
	lastVersion,
	lastVersionFile,
	isLastVersion,
	
	allAssetsRoot,
	allAssetsFolder,
	relativeFolder,
	relativeFolder2,
	
	
	fn initFromCtrl oneCtrl=
	(
		obj = oneCtrl
		name = getuserprop obj "assetName"
		version = getuserprop obj "assetVersion"
		
		assetFolder = getuserprop obj "assetfolder"
		format "assetFolder: %\n" assetFolder
		
		allAssetsRoot = getuserprop obj "allAssetsRoot"
		
		allAssetsFolder = getuserprop obj "allAssetsFolder"


		
-- 		print allAssetsFolder
		relativeFolder = getuserprop obj "relativeFolder"
		relativeFolder2 = getuserprop obj "relativeFolder2"
		
		-- obsolete root and relativePath
		root = getuserprop obj "root"
-- 		versionFile = root + (getuserprop obj "relativePath")
		versionFile = cleanFilename(assetFolder + "\\" + (returnDigit version) + "\\" + name + ".max")
		
-- 		print versionFile
		if assetFolder.count == 0 then assetFolder = getupperfolder(getFilenamePath  versionFile)
		
		assetIni = assetFolder + "assetInfo.ini"
-- 		print assetIni
		
		lastVersion = (getINISetting assetIni "assetProperties" "version") as integer
-- 		print lastVersion
		lastVersionFile = cleanFilename(assetFolder + "\\" +(returnDigit lastVersion) + "\\" + name + ".max")
		
		isLastVersion = true
		if lastVersion > version and doesfileexist lastVersionFile ==  true then isLastVersion = false
		
		relVersPath = relativeFolder + (returnDigit lastVersion) +"\\" + name + ".max"
	),
	
	fn updateAsset =
	(
		newAsset = assetClass()
		newAsset.initFromIni assetIni allAssetsFolder
		newAssetCtrl = newAsset.mergeAsset ignoreCache: true
		newAssetCtrl.transform = obj.transform
		newAssetCtrl
	)
)


try(destroyDialog updateAssetsToolRLT)catch()

rollout updateAssetsToolRLT "update assets tool"
(
	
-- 	vars
	local allAssetsFolder 
	local root 
	
	local vrMeshesAr = #()
	local assetAr = #()
	local assetClassAr = #()
	local assetClassArToShow = #()
	
-- 	ui
	/*
	edittext allAssetsFolderET "all assets folder:" text: allAssetsFolder readonly: true
	edittext rootET "root:" text: root readonly: true
	button collectAssetBT "collect assets"
	*/
	

	
	group "assets to update:"
	(
		checkbox outOfDateOnlyCB "display out of date assets only"
		multiListBox  assetsLB "assets:"
		edittext assetET "asset version:" readonly: true
		edittext currentVersionET "current version:" readonly: true
		edittext lastVersionET "is last version:" readonly: true
		edittext nextVersionET "next version file:" readonly: true
		button updateAssetBT "update asset" enabled: false
	)
	
	-- ui fonctions relatives
		-- asset collect
	fn updateAssetArray =
	(	
		assetClassAr = #()
		assetAr = collectAssetInScene()
		
		for o in assetAr do
		(
			try
			(
-- 				print "start asset creation"
				newAsset = assetInScene()
				newAsset.initFromCtrl o
				format "asset: %\n" newAsset
				append assetClassAr newAsset
-- 				print "asset creation done"
			)catch(format "*** % ***\n" (getCurrentException()))
		)
	)
	
	fn refreshAssetUI =
	(
		assetClassArToShow = #()
		 
		for o in assetClassAr do
		(
			if outOfDateOnlyCB.state == true then
			(
				if o.isLastVersion == false then
				(
					append assetClassArToShow o
				)
			)
			else
			(
				append assetClassArToShow o
			)
			
		)
		assetsLB.items = for o in assetClassArToShow collect o.name
	)
	
-- 	actions
	on outOfDateOnlyCB changed state do refreshAssetUI()
	
	on updateAssetsToolRLT open do
	(

		
		-- asset collect
		updateAssetArray()
		refreshAssetUI()
	)
	
	
	on assetsLB selectionEnd do
	(
		selIdAr = assetsLB.selection as array
		clearselection()
		
		for id in selIdAr do
		(
			
			
			selectmore assetClassArToShow[id].obj
			
			assetET.text = assetClassArToShow[id].versionFile
			currentVersionET.text =returnDigit (assetClassArToShow[id].version as integer)
			lastVersionET.text = assetClassArToShow[id].islastVersion as string
			
			if assetClassArToShow[id].islastVersion == false then
			(
				updateAssetBT.enabled = true
				nextVersionET.text = assetClassArToShow[id].lastVersionFile
			)
			else 
			(
				updateAssetBT.enabled = false
				nextVersionET.text = "NONE"
			)
		)
		
	)
	
	on updateAssetBT pressed do
	(
		print "start update"
-- 		idAr = #(assetsLB.selection)
		idAr = assetsLB.selection as array
		
		
		for id in idAr do
		(
-- 			print assetClassArToShow[id]
			
			oldCtrl = assetClassArToShow[id].obj
-- 			print ( "oldctrl:" + oldCtrl.name)
-- 			select oldCtrl
			
			
			assetToUp = assetClassArToShow[id]
			
			newAssetCtrl = assetToUp.updateAsset()
			
-- 			print "objToDel"
			objToDel = returnAllHierarchyDown #(oldCtrl)
			
			
-- 			print "check2"
			delete objToDel
		
			select newAssetCtrl
			
		)
		
		updateAssetArray()
		refreshAssetUI()
		print "end update"
	)


)

createdialog updateAssetsToolRLT width: 800