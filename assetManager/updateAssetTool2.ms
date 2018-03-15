/*
maj:
	-- (asset explorer: update tools v2)
	-- fonction de delete
	
	/- rendre optionnel le classement par ordre alphabétique(checkbox)
	
	-- rendre la tache et la version de tache editable pour l'update
	-- proposer directement le bouton pour ouvrir l'asset d'origine dans un autre max
	
	x- forcer l'update pour le debug
	
	/- rename à l'update:
		/- recupérer l'insatnce num de l'asset updater
		/- renomer tout les objets de l'insantce updater en fonction de l'instance num et du basename de l'asset

	/- rename à la duplication:
		/- compter le nombre d'instance deja présents
		/- affecter un nouvreau instance num à la copie
		/- renommer les objects dupliqués en fonction du basename et de la numerotation

	-- proposer la préservation des materiaux des objects à l'update
	-- proposer la préservation des postion des objects à l'update
	-- préserver les noms à l'update
	
	-- retour d'état à la selection dans la scene
	
debug:
	x- à l'update est ce qu'on merge un nouveau soleil?
		-- au merge le parametre "ignore vrset" etait "false"

rebuild:
	--  trier les variables et methodes inutiles
	-- utiliser la structure asset generale pour l'update
*/


filein "assetManagerDef.ms"
-- filein "assetCretorUI7.ms"
/*
fn collectAssetInScene =
( 
	for h in helpers where classof h == point and getUserProp h "asset" collect h
)
*/

/*
-- collectAssetNames()
fn collectAssetNames =
(
	local assetNamesAr = #()
	for h in helpers where getUserProp h "asset" do
	(
		appendifunique assetNamesAr (getUserProp h "assetName")
	)
	assetNamesAr
)
*/


fn returnMaxAssetCount assetName =
(
	local instanceNumAr = #()
	local instanceCount = 0
	local maxNum = 0
	
	for h in helpers where getUserProp h "assetName" == assetName do
	(
		instanceCount +=1
		if instanceCount > maxNum then maxNum = instanceCount
-- 		format "instanceCount: % \n"  instanceCount
		
		numTmp = getUserProp h "instanceNum" --  as integer
		
		if (classof numTmp) == integer then
		(
			if numTmp > maxNum then maxNum = numTmp
		)
		format "h: %, instanceCount: %, numTmp: %, maxNum: % \n" h.name instanceCount numTmp maxNum 
	)
	format "maxNum: %\n" (maxNum + 1)
	maxNum + 1
)
--  "villa2"
-- returnMaxAssetCount(getuserprop $ "assetName")
-- returnMaxAssetCount "teapot"


fn sortAssestbyname2 v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (toLower (v1.name + (v1.instNum as string))) < (toLower (v2.name + (v2.instNum as string))) )then
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


struct assetInScene
(
	ctrl,
	name,
	version,
	root,
	
	versionFile,
	assetFolder,
	assetIni,
	
	isLastVersion,
	
	instNum,
	task,
	taskVersion,
	
	nextVersionFilename,
	
	maxTask,
	maxTaskVers,

	fn publishInfo =
	(
		format "name:% , version:% , assetFolder:% \n" name version assetFolder
	),
	
	fn initFromCtrl oneCtrl=
	(
		ctrl = oneCtrl
		
		name = getuserprop ctrl "assetName"
		version = getuserprop ctrl "assetVersion"
		assetFolder = getuserprop ctrl "assetfolder"
		
		instNum = getuserprop ctrl "instanceNum"
		task = getuserprop ctrl "task"
		taskVersion = getuserprop ctrl "taskVersion"
		
		nextVersionFilename
-- 		local nextVersionFilename
		if task == "without" then
		(
			versionFile = cleanFilename(assetFolder + "\\" + (returnDigit taskVersion) + "\\" + name + ".max")
		)
		else
		(
			versionFile = cleanFilename(assetFolder + "\\"  + name + "." + task + "."  + (returnDigit taskVersion) +  ".max")
		)

		if doesfileexist versionFile then
		(
			assetIni = assetFolder + "assetInfo.ini"
			newAsset = assetCreationClass()
			newAsset.initFromIni assetIni
			
			local taskVersionList = newAsset.getMaxFilesCount2()
			maxTask
			maxTaskVers
			
			-- get derniere tache et derniere version de tache
			for i = 1  to taskList.count do
			(
				if taskVersionList[i].count > 0 then
				(
					maxTask = taskList[i]
					maxTaskVers = amax taskVersionList[i]
				)
			)
			
			nextVersionFilename = newAsset.getLastVersionFile2 ()
		)
		format "name: % versionfile: % nextVersionFilename: %\n" name versionFile nextVersionFilename
		
			
		if nextVersionFilename != undefined then
		(
			if doesfileexist nextVersionFilename and nextVersionFilename != versionFile  then 
			(
				isLastVersion = false
			)
			else
			(
				nextVersionFilename = undefined
				isLastVersion = true
			)
		)	
				
		oneCtrl
	),
	
	fn updateAsset updateMaterialsChoice: #useSceneMtlDups   =
	(
-- 		newAsset = assetClass()
		newAsset = assetCreationClass()
		newAsset.initFromIni assetIni --allAssetsFolder
		
		local assetVers = newAsset.getMaxFilesCount2
-- 		format "assetVers: %\n" assetVers
		
		
		local instNum = getUserProp ctrl "instanceNum"
		format "instNum:%\n" instNum
		
		newAssetCtrl = newAsset.mergeAsset3 mergeAsAsset: true ignoreVrSet: true ignoreCacheLay: true objsNameConflict: #mergeDups \
		instNum: instNum updateMaterials: updateMaterialsChoice task: maxTask taskversion: maxTaskVers
		
		newAssetCtrl.transform = ctrl.transform
		newAssetCtrl.name = ctrl.name
		newAssetCtrl
	)
)


try(destroyDialog updateAssetsToolRLT)catch()

rollout updateAssetsToolRLT "update assets tool v.2"
(
	
-- 	vars
	local allAssetsFolder 
	local root 
	
-- 	local vrMeshesAr = #()
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
		button refreshBT "refresh"
	)
	
	group "asset selected infos:"
	(
		edittext assetET "current filename:" readonly: true
		edittext taskET "current task:" readonly: true
		edittext taskVersionET "current Task version:" readonly: true
		edittext assetCtrlET "asset ctrl:" readonly: true
		edittext instanceNumET "instance num:" readonly: true
-- 		edittext currentVersionET "current version:" readonly: true
		edittext lastVersionET "is last version:" readonly: true
		edittext nextVersionET "next version file:" readonly: true


		
		
		button duplicateAssetBT "duplicate asset" enabled: true
	)
	
	group "update"
	(
		checkbox preserveMatCB "preserve materials" across: 2
		button updateAssetBT "update asset" enabled: true 
	)
	
	
	-- ui fonctions relatives
		-- asset collect
	fn updateAssetArray =
	(	
		assetClassAr = #()
		assetAr = for h in helpers where classof h == point and getUserProp h "asset" collect h
		
		for o in assetAr do
		(
-- 			try
-- 			(
-- 				print "start asset creation"
				newAsset = assetInScene()
				newAsset.initFromCtrl o
				format "asset updated: %\n" newAsset
				append assetClassAr newAsset
-- 				print "asset creation done"
-- 			)catch(format "*** % ***\n" (getCurrentException()))
		)
	)
	
	fn refreshAssetUI =
	(
		-- refresh liste d'asset
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
		-- classer par odre alphabetique
		qsort assetClassArToShow sortAssestbyname2
		
		assetsLB.items = for o in assetClassArToShow collect (o.name + "_" + (o.instNum as string))
			
		-- refresh champs de la selection
	)
	
	fn refreshAssetSelUI s=
	(
-- 			selectmore assetClassArToShow[id].ctrl
			
		assetET.text = s.versionFile
-- 		currentVersionET.text =returnDigit (s.version as integer)
		lastVersionET.text = s.islastVersion as string
		assetCtrlET.text = s.ctrl.name
		instanceNumET.text = s.instNum as string
		
		taskET.text = s.task
		taskVersionET.text = s.taskVersion as string
		
		if s.islastVersion == false then
		(
			updateAssetBT.enabled = true
			nextVersionET.text = s.nextVersionFilename
		)
		else 
		(
			updateAssetBT.enabled = true
			nextVersionET.text = "NONE"
		)
	)
	
-- 	actions
	on outOfDateOnlyCB changed state do refreshAssetUI()
	
	on updateAssetsToolRLT open do
	(
		-- asset collect
		updateAssetArray()
		refreshAssetUI()
-- 		for id in selIdAr refreshAssetSelUI do refreshAssetSelUI assetClassArToShow[id]
		assetsLB.selectionEnd()
	)
	
	
	on assetsLB selectionEnd do
	(
		selIdAr = assetsLB.selection as array
		clearselection()
		
		for id in selIdAr do
		(
			refreshAssetSelUI assetClassArToShow[id]
			selectmore assetClassArToShow[id].ctrl
		)
	)
	
	on refreshBT pressed do
	(
		updateAssetArray()
		refreshAssetUI()
-- 		for id in selIdAr refreshAssetSelUI do refreshAssetSelUI assetClassArToShow[id]
		assetsLB.selectionEnd()
	)
	
	on updateAssetBT pressed do
	(
		idAr = assetsLB.selection as array
		
		for id in idAr do
		(

			oldCtrl = assetClassArToShow[id].ctrl
			
			assetToUp = assetClassArToShow[id]
			
			local updateMaterialsChoice
			if preserveMatCB.state then updateMaterialsChoice = #useSceneMtlDups  else updateMaterialsChoice =  #useMergedMtlDups
				
			newAssetCtrl = assetToUp.updateAsset updateMaterialsChoice: updateMaterialsChoice
			
			-- prendre l'ancien instance num
			objToDel = returnAllHierarchyDown #(oldCtrl)
			
			-- rename
			local objToRename = returnAllHierarchyDown #(newAssetCtrl)

			delete objToDel
		
			select newAssetCtrl
			
		)
		
		updateAssetArray()
		refreshAssetUI()
		assetsLB.selectionEnd()
	)
	
	on duplicateAssetBT pressed do
	(
		-- collecte asset id
		local newAssetAr = #()
		local newAsset =#()
		local selIds = assetsLB.selection
		
		clearselection()
		for id in selIds do
		(			
			
			local refNum = getUserProp assetClassArToShow[id].ctrl  "instanceNum"
			local refNumStr = refNum as string
			
			local objsToDup = returnAllHierarchyDown #(assetClassArToShow[id].ctrl)
			
			-- decompte des instance dans la scene
			local basename = getUserProp assetClassArToShow[id].ctrl "assetName"
			local newAssetNumber = returnMaxAssetCount basename
			local strNum = newAssetNumber as string
			format "asset: %, newAssetNumber: %\n" assetClassArToShow[id].ctrl.name newAssetNumber
			
			-- copie
			maxOps.CloneNodes objsToDup actualNodeList: &refNodeList newNodes: &newAssetObjs
-- 			format "newAsset: %\n" newAsset
			
			-- rename des copies
			for i = 1 to newAssetObjs.count do
			(
				newAssetObjs[i].name = refNodeList[i].name
				newAssetObjs[i].name = substitutestring newAssetObjs[i].name (basename + "_") ""
				newAssetObjs[i].name = substitutestring newAssetObjs[i].name (refNumStr + "_") ""
				
				newAssetObjs[i].name = basename + "_" + strNum + "_" + newAssetObjs[i].name
			)
			
			-- recupération du nouveau contrl
			for o in newAssetObjs where classof o == point and getUserProp o "asset" do
			(
-- 				format "o.name: %\n" o.name
				setUserProp o "instanceNum" newAssetNumber
				selectmore o
			)
				
			-- rename avec basename + instancenum
			-- 	for o in newAssetObjs where classof o == point and getUserProp o "asset" do selectmore o
		)
-- 		select newAssetAr
		
		updateAssetArray()
		refreshAssetUI()
		assetsLB.selectionEnd()
	)
)

createdialog updateAssetsToolRLT width: 1200



-- maxOps.CloneNodes $ newNodes:&newAsset
-- select newAsset
