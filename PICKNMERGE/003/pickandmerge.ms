-- pickandmerge
/*
maj:
	-- asset set
		-- faire fonctionner la selection de set multiple
		-- eviter les doublons de set
	
	-- créer un historique des dossier ouvert précedemment
	-- ajouter un champs de recherche dans les noms
	-- ajouter un explorateur de dossier
	-- faire apparaitre le thumbnail du fichier max

dev:
	-- dans l'extracteur d'asset placer les assets au centre de la scene et créer une interface pour les asset à créer

*/

fn sortByFilename v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (getFilenameFile  v1) < (getFilenameFile  v2)) then
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

fn walkDir2 dir pattern =
(
	local maxFiles = 2000
	local dirArr = #(dir)
	local fileArr = #()
	
	-- collecte des fichiers dans le premier dossier
	local ff = getFiles (dir + pattern)
	for f in ff do append fileArr f
	
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
					append dirArr dt 
					-- collect files
					local fTmp = getFiles (dt + pattern)
					for f in fTmp do append fileArr f
					if fileArr.count > maxFiles then exit
				)
			)
		)
		if fileArr.count > maxFiles then exit
	)
	sort fileArr
)

-- dir = @"M:\Elements_batiments\Boites aux lettres"
-- pattern = "\\*.max"
-- test = walkDir2 dir pattern
-- test.count

filein ((getRoot()) + "Rig/lastParent_def.ms")

-- classof PickNMergeRLT.mergeObjFolder

-- p = getProperty  PickNMergeRLT "mergeObjFolder"

rollout assetPreviewRLT "Preview"
(
	bitmap assetBMP "asset thumbnail" width: 256 height: 256
)


try(destroydialog PickNMergeRLT)catch()
rollout PickNMergeRLT "Loader"
(
-- 	vars
	local sourceObj
	local ctrl
	local mergeObjFolder = ""
-- 	local assetsSetFolder = @"M:\Interieur\Cellules\Modelisation\Library\Objects\assets_sets"
	local assetsSetFolder = ""
		

	local objList = #()
	local objtodisplay = #()

	local assetSetList = #()
	local setsToDisplay = #()
	local selectedSetIni
	
	local maxToMerge
	local maxsToMerge = #()
	local thebox
	local mergedNodes
	
	local Params = #("pos", "mergeObjFolder", "scanSubCB", "pickerCB" )
-- 	tool
	tool placeObjTool
	(
		on mousePoint clickno do
		(
-- 			format "############################### clickno1: %\n"  clickno
			
			local myRay = mapScreenToWorldRay viewPoint
			local arr = intersectRayScene myRay
			
			local viewMatrix =  Inverse(viewport.getTM())
			local viewPos = viewMatrix.pos
			local nearestDist = 1000000
			local goodRes = undefined
			
			if arr.count>0 do	
			(				
				for obj in arr do
				(
					local res = finditem mergedNodes obj[1]

					if obj[1] != sourceObj  and  obj[1].ishidden == false and res == 0 do
					(
					
						tmpDist = distance viewPos obj[2].pos
						
						if tmpDist < nearestDist do
						(
-- 									format "mn: %\n" mn.name
							nearestDist = tmpDist
							goodRes = obj
-- 								format "obj: %\n" obj
						)
					)
				)
			)			
			
			if goodRes != undefined do
			(
				sourceObj.controller.pos.controller.value =  goodRes[2].pos
				sourceObj.dir =  goodRes[2].dir
			)
		)

		on mouseMove clickno do
		(
-- 			format "############################ clickno2: %\n"  clickno
			if lButton == true do
			(
				local myRay = mapScreenToWorldRay viewPoint

				local arr = intersectRayScene myRay
				format "arr: %\n" arr
				
				local viewMatrix =  Inverse(viewport.getTM())
				local viewPos = viewMatrix.pos
				local nearestDist = 1000000
				local goodRes = undefined
				
				if arr.count>0 do	
				(				
					for obj in arr do
					(
						local res = finditem mergedNodes obj[1]

						if obj[1] != sourceObj  and  obj[1].ishidden == false and res == 0 do
						(
						
							tmpDist = distance viewPos obj[2].pos
							
							if tmpDist < nearestDist do
							(
-- 									format "mn: %\n" mn.name
								nearestDist = tmpDist
								goodRes = obj
-- 								format "obj: %\n" obj
							)
						)
					)
				)			
				
				if goodRes != undefined do
				(
					undo on
					(
						sourceObj.controller.pos.controller.value =  goodRes[2].pos
						sourceObj.dir =  goodRes[2].dir
					)
				)
			)
		)
		
		on mouseAbort clickno do
		(
-- 			format "clickno3: %\n"  clickno
-- 			if isvalidnode sourceObj then delete sourceObj
		)
	)
	
-- 	UI
	group "pathName:"
	(
		checkbox scanSubCB "scan sub folders"
		edittext mergeListPathET text: "" readonly: false 
		button selPathBT "..." across: 2
		button openFolderBT "open folder"
	)
	
	group "assets set:"
	(
		listbox assetsSetsLB "assets set"
		edittext setNameET "name:" text: ""
		button addAssetSetBT "create set" across: 4
		button selBT "select set" enabled: true
		button delBT "delete set" enabled: true
		button renameSetBT "rename set" enabled: true

		button addAssetToSetBT "add asset to set"  across: 2 enabled: false
		button remAssetFromSetBT "remove asset from set"  enabled: false
	)
	
	group "assets:"
	(
-- 		listbox mergeListLB "merge list:" height: 40
		multilistbox mergeListLB "merge list:" height: 40
		edittext assetCountET "asset count:" readonly: true
		checkbox pickerCB "picker" across: 3 enabled: true enabled: false
		checkbutton mergeCB "merge and pick"
		button mergeBT "merge" 
		button subBT "substitute" enabled: false across: 2
	)
	
	
-- 	functions
	fn collectAssetsSet =
	(
		if doesfileexist assetsSetFolder then
		(
			assetSetList = walkDir2 assetsSetFolder  "/*.ini"
		)
		else
		(
			assetsetList = #()
		)
		setsToDisplay = for o in assetSetList collect o
		qsort setsToDisplay sortbyFilename
	)
	
	fn refreshui =
	(
		if mergeObjFolder != undefined then mergeListPathET.text = mergeObjFolder else mergeListPathET.text = "NONE"
		mergeListLB.items = for  o in objtodisplay collect (getFilenameFile o)
		assetsSetsLB.items = for o in setsToDisplay collect  (getFilenameFile o)
		assetCountET.text = objList.count as string

		mergeCB.enabled = pickerCB.state  
		mergeBT.enabled = not pickerCB.state  
	)
	

-- 	actions
	on PickNMergeRLT open do
	(
		
--		chargement des préferences
		loadRolloutParams PickNMergeRLT Params
		
-- 		collecte des fichiers max
		if mergeObjFolder.count == 0 then mergeObjFolder = @"M:\Elements_batiments"

		if doesfileexist mergeObjFolder then
		(
			if scanSubCB.state then
			(
				objList = walkDir2 mergeObjFolder  "/*.max"
			)
			else
			(
				objList = getfiles (mergeObjFolder + "/*.max")
			)
			objtodisplay = for o in objList collect o
			qsort objtodisplay sortbyFilename
		)

		assetsSetFolder = mergeObjFolder + "\\" + "assets_sets"
--		collecte des sets d'assets
		collectAssetsSet()

			
		refreshUI ()
		
	)
	
	on PickNMergeRLT close do
	(
		writeRolloutParams PickNMergeRLT Params
	)
	
	
	on scanSubCB changed state do
	(
		if mergeObjFolder != undefined then
		(	
			(
				if doesfileexist mergeObjFolder then
				(
					if scanSubCB.state then
					(
						objList = walkDir2 mergeObjFolder  "/*.max"
					)
					else
					(
						objList = getfiles (mergeObjFolder + "/*.max")
					)
					objtodisplay = for o in objList collect o
					qsort objtodisplay sortbyFilename
				)
			)	
		)
		
		refreshUI ()
	)
	
	on mergeListPathET entered pathFolder do
	(
		local bakPath = mergeObjFolder
		if doesfileexist pathFolder then mergeObjFolder = pathFolder
			
		if mergeObjFolder != undefined then
		(	
			if doesfileexist mergeObjFolder then
			(
				if scanSubCB.state then
				(
					objList = walkDir2 mergeObjFolder  "/*.max"
				)
				else
				(
					objList = getfiles (mergeObjFolder + "/*.max")
				)
				objtodisplay = for o in objList collect o
				qsort objtodisplay sortbyFilename
			)
		)
		
		refreshUI ()
	)
	
	on selPathBT pressed do
	(
		-- collecte du nouveau nom de dossier
		local mergeObjFolderTmp = getSavePath caption: "Select object to merge folder" initialDir: mergeListPathET.text
		
		-- test du nouveau nom de dossier
		if mergeObjFolderTmp != undefined then
		(
			if doesfileexist mergeObjFolderTmp then  mergeObjFolder = mergeObjFolderTmp
		)
		
		-- collecte des objet:
			-- maj ajouter une condition "si le folder a changé"
		if mergeObjFolder != undefined then
		(	
			if doesfileexist mergeObjFolder then
			(
				if scanSubCB.state then
				(
					objList = walkDir2 mergeObjFolder  "/*.max"
				)
				else
				(
					objList = getfiles (mergeObjFolder + "/*.max")
				)
				objtodisplay = for o in objList collect o
				qsort objtodisplay sortbyFilename
			)
		)
		
--		collecte des sets d'assets
		assetsSetFolder = mergeObjFolder + "\\" + "assets_sets"

		collectAssetsSet()
		
		refreshUI ()
	)
	
	on openFolderBT pressed do
	(
		if doesfileexist mergeObjFolder then
		(
				doscommand ("explorer " + mergeObjFolder)
		)
	)
	
	-- ####################################### ASSETS SET ACTION
	on assetsSetsLB selected oneSet do
	(
		selectedSetIni = setsToDisplay[oneSet]
		setNameET.text = getFilenameFile selectedSetIni
		selBT.pressed()
	)
	
	on addAssetSetBT pressed do
	(
		if maxstomerge.count > 0 and setNameET.text.count > 0 then
		(
			local newassetset = setNameET.text
			local maxsArComplete = with printAllElements on maxstomerge as string
		
			-- creation du fichier ini
			local inifile = assetsSetFolder + "\\" + newassetset +".ini"
			local res = setINISetting iniFile "assets sets" "assets" maxsArComplete
			
			if res then format "set name: \"%\" assets:%\n" newassetset maxsArComplete else format "creation fail: %\n" newassetset
					
			collectAssetsSet()
			refreshUI ()
		)
		else(format "selection incorrecte ou nom manquant\n")
	)
	
	on selBT pressed do
	(
		local ojbArId = #()
		local tmpStr = getINISetting selectedSetIni "assets sets" "assets"
		maxsTomerge = execute tmpStr
		format "%\n" tmp
		
-- 		compare la liste du set avec les fichiers max collectés pour récupérer les id et les selectionner dans la liste d'assets 
		for f in maxsTomerge do
		(
			local objid = finditem objtodisplay f
			if objid > 0 then appendifunique ojbArId objid
		)
-- 		format "ojbArId: %\n" ojbArId
		mergeListLB.selection = ojbArId
		maxsToMerge = for id in ojbArId collect objtodisplay[id] 
	)
	
	on delBT pressed do
	(
		deleteFile  selectedSetIni
		collectAssetsSet()
		refreshUI ()
	)
	
	on renameSetBT pressed do
	(
		if setNameET.text.count > 0 then 
		(
			local newname = setNameET.text
			renameFile selectedSetIni (assetsSetFolder + "\\" + newname +".ini")
			collectAssetsSet()
			refreshUI ()
		)
	)
	
	-- ########################################### ASSETS ACTIONS
	on mergeListLB selectionend do
	(
		idAr = mergeListLB.selection as array
		maxsToMerge = for id in idAr collect objtodisplay[id] 
		
		/*
		-- get preview
		for m in maxsToMerge do
		(
-- 			format "m:  %\n" m
			bmpRC = (getFilenamePath m) + (getFilenameFile  m) + ".jpg"
			if doesfileexist bmpRC then 
			(
-- 				format "PREVIEW !\n"
				try (destroydialog assetPreviewRLT)catch()
				createdialog assetPreviewRLT  width: 300 
				if assetPreviewRLT.open then assetPreviewRLT.assetBMP.filename = bmpRC
				assetPreviewRLT.title = "Preview: " + (getFilenameFile  m)
			)				
			else 
			(
-- 				format "NO preview... \n"
				try (destroydialog assetPreviewRLT)catch()
				createdialog assetPreviewRLT width: 300 
				if assetPreviewRLT.open then assetPreviewRLT.assetBMP.bitmap = bitmap 256 256 color:(color 125 125 125)
				assetPreviewRLT.title = "NO Preview"
			)
		)
		*/
	)
	
	
	on pickerCB changed val do 
	(
		mergeCB.enabled = val
		mergeBT.enabled = not val
	)
	
	on mergeCB changed state do
	(	
		local id = mergeListLB.selection
-- 		maxToMerge = objList[id]
		maxToMerge = objtodisplay[id]
		format "maxToMerge: %\n" maxToMerge
		mergeMAXFile maxToMerge #autoRenameDups mergedNodes: &mergedNodes  
		format "format: %\n" mergedNodes
		
		sourceObj = point name: (uniquename((getFilenameFile maxToMerge) + "_CTRL"))
		
		local toParent = for m in  mergedNodes collect m
		append toParent sourceObj
		lastParent toParent
		
		
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool
			)
			mergeCB.state = false
		)
	)
	
	on mergeBT pressed do
	(
-- 		local id = mergeListLB.selection
-- 		maxToMerge = objList[id]
-- 		maxToMerge = objtodisplay[id]
		local jump = 0
		if maxsToMerge.count > 0 then
		(
			clearselection()
			for maxToMerge in maxsToMerge do
			(
			   	local start = timestamp ()
				format "maxToMerge: %\n" maxToMerge
				mergeMAXFile maxToMerge #autoRenameDups mergedNodes: &mergedNodes  
				format "mergedNodes: %\n" mergedNodes
				format "merge done: %ms\n"  ((timestamp ()) - start)
				
		-- 		creation du point parent
				assetCtrl = point name: (uniquename((getFilenameFile maxToMerge) + "_CTRL"))
				
			-- ajouter le point créé dans le calque "assets"
				LM = layermanager
				assetsLayer = LM.getLayerFromName "assets_layer"
				if assetsLayer == undefined do assetsLayer = layermanager.newLayerFromName "assets_layer"
				assetsLayer.addnode assetCtrl
				
				-- ajouter le filename du fichier max dans les objs properties du layer
				setUserProp assetCtrl "asset" true
					
				setUserProp assetCtrl "assetfolder" (getFilenamePath maxToMerge)
					
				setUserProp assetCtrl "assetName"  (getFilenameFile maxToMerge)
				setUserProp assetCtrl "assetVersion" 0
				
				setUserProp assetCtrl "instanceNum" 0
					
				setUserProp assetCtrl "task" undefined
				setUserProp assetCtrl "taskVersion" undefined 
				
				-- parenter les objets mergés au ctrl
				local toParent = for m in  mergedNodes collect m
				append toParent assetCtrl
				lastParent toParent
				
				-- décaler le parent
				
				assetCtrl.position.x = jump
				jump += 200
				
				format "merge + ctrl done: %ms\n"  ((timestamp ()) - start)
				selectmore assetCtrl
			)
			
		)
	)
	
	on subBT pressed do
	(
		-- merged la selection
		--dupliquer et  aligner les nouveaux assets sur les controls selectionnés
	)
	

	
		
)
createdialog PickNMergeRLT width: 400

-- PickNMergeRLT.title = "titi"

-- PickNMergeRLT.mergeListLB.selection