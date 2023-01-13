/*
maj:
x passer les paths en chemin relatifs
trier par ordre alphabetique
ouvrir le fichier ini

creer un launher simple(lecteur)
ajouter un fonction add to core au script manager

debug:
quand on supprime la dernière catagorie, ça plante
*/


rollout renameRLT "rename"
(
	global newCategoryName
	
	edittext newNameET "name:" 
	button okBT "ok"
	
	on okBT pressed do
	(
		destroyDialog renameRLT
	)
	
	on newNameET entered newName do
	(
		destroyDialog renameRLT
	)
	
	on renameRLT close  do
	(
		newCategoryName = newNameET.text
-- 		format "newCategoryName: %\n" newCategoryName
	)
)

try( destroydialog superLauncherRLT )catch()
rollout superLauncherRLT "Super Launcher"
(
	local iniCoreFileName
	
	local coreCatList 
	
	local coreScriptArray
	local coreScriptArrayNames
	
	local coreScriptArray2
	local coreScriptArray2Names
	
	local bufArray
	
	-- UI
	group ".INI file:" --visible: false
	(
		edittext pathINIET "path:" readonly: true
		button selectPathBT "..." across: 2
		button openINIBT "edit .INI" -- enabled: false -- visible: false
	)
	
	group "categories manager:"
	(
-- 		dropdownlist catListDPL "category:" enabled: false
		listbox catListLB "categories:"
		button moveUpBT "^" across: 2 enabled: false
		button moveDwBT "v" enabled: false
		button addCatBT "new" across: 3 
		button renameCatBT "rename" -- enabled: false --across: 2 
		button delCatBT "del"
	)
	
	group "script manager:"
	(
		multilistbox scriptListMLB "scripts list:"
		button copyScriptBT "copy scripts" -- enabled: false
		button pasteScriptBT "paste scripts" -- enabled: false
		button removeScriptBT "remove scripts" -- enabled: false
		button addScriptBT "V add selected scripts V" enabled: false
	)
	
/* 	group "laucher:"
	(
		dropdownlist catListTargetDPL "categories target:"
		
-- 		multilistbox catListMLT "category list:"
		multilistbox scriptList2MLT "scripts list:"
		button execScriptBT "execute script"
		button openScriptBT "open script"
	) */
	
	-- UI functions
	fn loadCategories = 
	(
		coreCatList = getINISetting iniCoreFileName "coreScriptList"
	)
	
	fn loadCore2 oneCat = 
	(		
		local coreScriptArray = #()
	
		-- collect clean list
		if doesfileexist iniCoreFileName then
		(
			coreArStr = getINISetting iniCoreFileName  "coreScriptList" oneCat
			coreArStrTmp = execute coreArStr
			format "core script list: %\n" coreArStrTmp
			
			-- test if file exist
			for onePath in coreArStrTmp do
			(
-- 				format "(getroot() + onePath): %\n" (getroot() + onePath)
				if doesFileExist (getroot() + onePath) then
				(
-- 					format "found: %\n"  (getroot() + onePath)
-- 					appendifunique coreScriptArray (getroot() + onePath)
					appendifunique coreScriptArray onePath
				)
				else format "obsolete path: %\n"  ( getroot() + onePath )
			)
		)
		else (format "ini file doesn't exist: %\n" iniCoreFileName)

		
		format "oneCat: % coreScriptArray: %\n" oneCat coreScriptArray
		coreScriptArray
	)
	
	fn refreshUI =
	(
		-- refresh categories
-- 		catListDPL.items = coreCatList
		catListLB.items = coreCatList 
-- 		catListTargetDPL.items = coreCatList
-- 		format "category selected: %\n" coreCatList[catListDPL.selected]
		
		-- refresh script list
		if catListLB.selection != 0 and coreScriptArray != undefined then 
		(
			coreScriptArrayNames = #()

			for ms in coreScriptArray do
			(
				local oneName
				local version = getScriptVersion ms

				if version != undefined then oneName = (getFilenameFile ms) + " v."+ (version as string)
				else oneName = getFilenameFile ms
				
				append coreScriptArrayNames oneName
			)
			scriptListMLB.items = coreScriptArrayNames 
		)
		else(/* format "catListDPL.selection == 0 or coreScriptArray == undefined\n" */)
		
/* 		if catListTargetDPL.selection != 0 and coreScriptArray2 != undefined then 
		(
			coreScriptArray2Names = #()

			for ms in coreScriptArray2 do
			(
				local oneName
				local version = getScriptVersion ms

				if version != undefined then oneName = (getFilenameFile ms) + " v."+ (version as string)
				else oneName = getFilenameFile ms
				
				append coreScriptArray2Names oneName
			)
			scriptList2MLT.items = coreScriptArray2Names 
		)
		else()
		 */
	)
	
	-- Actions
	on superLauncherRLT open do
	(
		iniCoreFileName = getroot() + "/scriptsManager/scriptListCoreTest.ini"
		loadCategories()
		
		catListLB.selection = 1
		coreScriptArray = loadCore2 coreCatList[1]
/* 		
		catListTargetDPL.selection = 1
		coreScriptArray2 = loadCore2 coreCatList[1] */
		
		refreshUI()
	)
	
	on openINIBT pressed do
	(
		edit iniCoreFileName
	)
		
	on catListLB selected val do
	(
		format "coreCatList[val]: %\n" coreCatList[val]
		coreScriptArray = loadCore2 coreCatList[val]
		scriptListMLB.selection = 0
		refreshUI()
	)
	
	on addCatBT pressed do
	(
		createdialog renameRLT modal: true escapeEnable: true
-- 		format "newCategoryName: %\n" newCategoryName
		
		setINISetting iniCoreFileName "coreScriptList" newCategoryName "#()"
		
		loadCategories()
		refreshUI()
	)
	
	on renameCatBT pressed do
	(
		oldName = coreCatList[catListLB.selection]
		format "oldName: %\n" oldName

		createdialog renameRLT modal: true escapeEnable: true
		
-- 		coreScriptArray = loadCore2 oldName
		tmpArray = getINISetting iniCoreFileName "coreScriptList" oldName
		
		-- supprimer la category dans l ini
		delIniSetting iniCoreFileName "coreScriptList"  oldName
		
		-- ecrire de nouvel array dan l ini
		setINISetting iniCoreFileName  "coreScriptList" newCategoryName tmpArray
		
		loadCategories()
		refreshUI()
	)
	
	on delCatBT pressed do
	(
		bakId = catListLB.selection
		
		delIniSetting iniCoreFileName "coreScriptList"  coreCatList[catListLB.selection]
		loadCategories()
		coreScriptArray = loadCore2 coreCatList[bakId]
		refreshUI()
	)
	
	on copyScriptBT pressed do
	(
		bufArray = #()
		for id2 in scriptListMLB.selection do
		(
			append bufArray coreScriptArray[id2]
		)
		format "copy Array: %\n" bufArray
	)
	
	on pasteScriptBT pressed do
	(
		for ms in bufArray do appendifunique coreScriptArray ms

		local coreData = with printAllElements on coreScriptArray as string
		setINISetting iniCoreFileName  "coreScriptList" coreCatList[catListLB.selection] coreData
		
		loadCategories()
		refreshUI()
	)
	
	on removeScriptBT pressed do
	(
		idstodel = scriptListMLB.selection as array
		for i = idstodel.count to 1 by - 1 do deleteitem coreScriptArray i

		local coreData = with printAllElements on coreScriptArray as string
		setINISetting iniCoreFileName  "coreScriptList" coreCatList[catListLB.selection] coreData
		
		refreshUI()
	)
/* 	
	on addScriptBT pressed do
	(

		id = catListLB.selection
		-- récupérer l'array de la category depuis le INI
		coreScriptArray2 = loadCore2 coreCatList[id]
		
		-- ajouter le script selectionné
		for id2 in scriptListMLB.selection do
		(
			-- passage en chemin relatif
			local pathEnd = substitutestring coreScriptArray[id2] (getRoot()) ""
			appendifunique coreScriptArray2 pathEnd
		)
					
		format "coreScriptArray2: % coreScriptArray: %\n" coreScriptArray2 coreScriptArray
		local coreData = with printAllElements on coreScriptArray2 as string
			
-- 			format "core data: %\n" coreData
		setINISetting iniCoreFileName  "coreScriptList" coreCatList[id] coreData
		
		refreshUI()
	)
	

	
	on catListTargetDPL selected val do
	(
		format "coreCatList[val]: %\n" coreCatList[val]
		coreScriptArray2 = loadCore2 coreCatList[val]
		format "cat: % scripts: %\n" coreCatList[val] coreScriptArray2
		refreshUI()
	)
		
	on scriptListMLB  doubleClicked val do
	(
		format "script: %\n" (getroot() + coreScriptArray[val])
	) */
)
createdialog superLauncherRLT

try( destroydialog launcherRLT )catch()
rollout launcherRLT "launcher"
(
	local iniCoreFileName
	
	local coreCatList
	
	local coreScriptArray2
	local coreScriptArray2Names
	
	-- UI

	dropdownlist catListTargetDPL "categories target:"
	
-- 		multilistbox catListMLT "category list:"
	listbox scriptList2MLT "scripts list:"
	button execScriptBT "execute script"
	button openScriptBT "open script"
	
	fn loadCategories = 
	(
		coreCatList = getINISetting iniCoreFileName "coreScriptList"
	)
	
	fn loadCore2 oneCat = 
	(		
		local coreScriptArray = #()
	
		-- collect clean list
		if doesfileexist iniCoreFileName then
		(
			coreArStr = getINISetting iniCoreFileName  "coreScriptList" oneCat
			coreArStrTmp = execute coreArStr
			format "core script list: %\n" coreArStrTmp
			
			-- test if file exist
			for onePath in coreArStrTmp do
			(
-- 				format "(getroot() + onePath): %\n" (getroot() + onePath)
				if doesFileExist (getroot() + onePath) then
				(
-- 					format "found: %\n"  (getroot() + onePath)
-- 					appendifunique coreScriptArray (getroot() + onePath)
					appendifunique coreScriptArray onePath
				)
				else format "obsolete path: %\n"  ( getroot() + onePath )
			)
		)
		else (format "ini file doesn't exist: %\n" iniCoreFileName)

		
		format "oneCat: % coreScriptArray: %\n" oneCat coreScriptArray
		coreScriptArray
	)
	
	
	fn refreshUI =
	(
		-- refresh categories
-- 		catListDPL.items = coreCatList
-- 		catListLB.items = coreCatList 
		catListTargetDPL.items = coreCatList
-- 		format "category selected: %\n" coreCatList[catListDPL.selected]
				
		if catListTargetDPL.selection != 0 and coreScriptArray2 != undefined then 
		(
			coreScriptArray2Names = #()

			for ms in coreScriptArray2 do
			(
				local oneName
				local version = getScriptVersion ms

				if version != undefined then oneName = (getFilenameFile ms) + " v."+ (version as string)
				else oneName = getFilenameFile ms
				
				append coreScriptArray2Names oneName
			)
			scriptList2MLT.items = coreScriptArray2Names 
		)
		else(/* format "catListDPL.selection == 0 or coreScriptArray == undefined\n" */)
	)
	
	on launcherRLT open do
	(
		iniCoreFileName = getroot() + "/scriptsManager/scriptListCoreTest.ini"
		loadCategories()
				
		catListTargetDPL.selection = 1
		coreScriptArray2 = loadCore2 coreCatList[1]
		
		refreshUI()
	)
	
	on catListTargetDPL selected val do
	(
		format "coreCatList[val]: %\n" coreCatList[val]
		coreScriptArray2 = loadCore2 coreCatList[val]
		format "cat: % scripts: %\n" coreCatList[val] coreScriptArray2
		refreshUI()
	)
		
	on scriptList2MLT  doubleClicked val do
	(
		format "script: %\n" (getroot() + coreScriptArray2[val])
	)
	
	
	

)
createDialog launcherRLT
