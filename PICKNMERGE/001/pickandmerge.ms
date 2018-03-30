-- pickandmerge
/*
maj:
	x- conserver en memoire le dernier dossier ouvert

	x- mettre en option le scan des sous dossier
	-- mettre en option le picker
	x- classer les object par ordre alphabetique
	x- décompter les objets collectés
	x- editer directement le nom du dossier dans l editeur de texte
	
	-- créer un historique des dossier ouvert précedemment
	-- ajouter un champs de recherche dans les noms
	-- ajouter un explorateur de dossier
	-- faire apparaitre le thumbnail du fichier max

dev:
	-- mettre en place un array objtodisplay
	-- unifier les collecte d'objets

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

try(destroydialog PickNMergeRLT)catch()
rollout PickNMergeRLT "Pick And Merge"
(
-- 	vars
	local sourceObj
	local ctrl
	local mergeObjFolder = ""
	local objList = #()
	local objtodisplay = #()
	local maxToMerge
	local thebox
	local mergedNodes
	
	local Params = #("pos", "mergeObjFolder", "scanSubCB" )
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
		button selPathBT "..."
		
	)
	group "assets:"
	(
		listbox mergeListLB "merge list:" height: 40
		edittext assetCountET "asset count:" readonly: true
		checkbox pickerCB "picker" across: 2
		checkbutton mergeCB "merge"
	)
	
	
-- 	functions
	fn refreshui =
	(
		if mergeObjFolder != undefined then mergeListPathET.text = mergeObjFolder else mergeListPathET.text = "NONE"
		mergeListLB.items = for  o in objtodisplay collect (getFilenameFile o)
		assetCountET.text = objList.count as string
	)
	
-- 	actions
	on PickNMergeRLT open do
	(
		
-- 		mergeObjFolder = @"M:\Elements_batiments"
		loadRolloutParams PickNMergeRLT Params
		
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
		
		refreshUI ()
	)
	
	on mergeListLB select id do
	(
		maxToMerge = objList[id]
	)
	
	on mergeCB changed state do
	(	
		local id = mergeListLB.selection
		maxToMerge = objList[id]
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
	
)
createdialog PickNMergeRLT width: 400