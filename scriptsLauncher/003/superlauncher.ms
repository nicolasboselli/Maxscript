/*
maj:
x passer les paths en chemin relatifs
x trier par ordre alphabetique
ordonner les cat�gories
x ouvrir le fichier ini

x creer un launher simple(lecteur)
x ajouter un fonction add to core au script manager

debug:
x quand on supprime la derni�re catagorie, �a plante
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

fn sortByPathname v1 v2 =
(
		-- qsort <array> sortbyname
-- 	vars
	local d
	
	if  (filenameFromPath(toLower v1)) < (filenameFromPath (toLower v2)) then
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

-- qsort coreScriptArray sortByPathname

-- filenameFromPath coreScriptArray[1]

try( destroydialog superLauncherRLT )catch()
rollout superLauncherRLT "Super Launcher"
(
	local iniCoreFileName
	
	global coreCatList 
	
	local coreScriptArray
	local coreScriptArrayNames
	
-- 	local coreScriptArray2
-- 	local coreScriptArray2Names
	
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
		button moveUpBT "^" across: 2 -- enabled: false
		button moveDwBT "v" -- enabled: false
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
-- 		button addScriptBT "V add selected scripts V" enabled: false
	)
	
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
-- 			format "core script list: %\n" coreArStrTmp
			
			-- test if file exist
			for onePath in coreArStrTmp do
			(
				if doesFileExist (getroot() + onePath) then
				(
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
		catListLB.items = coreCatList 
		
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
		
		if doesFileExist iniCoreFileName then
		(
			pathINIET.text = iniCoreFileName
		)

	)
	
	-- Actions
	on superLauncherRLT open do
	(
		iniCoreFileName = getroot() + "/scriptsManager/scriptListCoreTest.ini"
		loadCategories()
		
		catListLB.selection = 1
		coreScriptArray = loadCore2 coreCatList[1]
		
		refreshUI()
	)
	
	on selectPathBT pressed do
	(
-- 		format "youhou\n"
		local testINI = getOpenFileName caption: "select file .INI" filename: ((getroot()) + "scriptsManager\\" ) types: "*.INI|*.ini"
		
		if doesFileExist testINI then 
		(
			iniCoreFileName = testINI
			loadCategories()
		
			catListLB.selection = 1
			coreScriptArray = loadCore2 coreCatList[1]
		
			refreshUI()
		)
-- 		local basePathIni = @"M:\Biblio\VISIOLAB\8-Scripts\Production\Maxscript\scriptsManager"
		

	)
	
	on openINIBT pressed do
	(
		edit iniCoreFileName
	)
		
	on catListLB selected val do
	(
-- 		format "coreCatList[val]: %\n" coreCatList[val]
		coreScriptArray = loadCore2 coreCatList[val]
		qsort coreScriptArray sortByPathname
		scriptListMLB.selection = 0
		refreshUI()
	)
	
	on moveUpBT pressed do
	(
	-- d�placer la cat�gorie dans l'ini
-- 		local catList = #()
		local catScriptList = #()
		
		format "cat % down to %: %\n" catListLB.selection  (catListLB.selection - 2) coreCatList[catListLB.selection]
		
-- 		loadCategories()
		for cat in  coreCatList do
		( 
			append catScriptList (getINISetting iniCoreFileName "coreScriptList" cat)
		)
		
		-- backup de la selection
		local id = catListLB.selection
		local bakCat = coreCatList[id]
		local bakCatList = catScriptList[id]
		
		-- supprimer la categorie selectionner
		deleteItem coreCatList id
		deleteItem catScriptList id
		
		-- ins�rer la categorie selectionn�e en i - 2
		insertItem  bakCat coreCatList (id - 1)
		insertItem  bakCatList catScriptList (id - 1)
		
		-- deplacer la selection en i - 1
		catListLB.selection = id - 1
		
		-- supprimer l'ini
		delIniSetting iniCoreFileName  "coreScriptList"
		
		-- 	r��crire toutes les cat�gories dans l'ini
		for i = 1 to coreCatList.count do
		(
			local coreData = with printAllElements on catScriptList[i] as string
			setINISetting iniCoreFileName  "coreScriptList" coreCatList[i] coreData
		)
		
		loadCategories()
		refreshUI()
	)
	
	on moveDwBT pressed do
	(
		
		local catScriptList = #()
		
		format "cat % up to %: %\n" catListLB.selection  (catListLB.selection + 1) coreCatList[catListLB.selection]
		
-- 		loadCategories()
		for cat in  coreCatList do
		( 
			append catScriptList (getINISetting iniCoreFileName "coreScriptList" cat)
		)
		
		-- backup de la selection
		local id = catListLB.selection
		local bakCat = coreCatList[id]
		local bakCatList = catScriptList[id]
		
		-- supprimer la categorie selectionner
		deleteItem coreCatList id
		deleteItem catScriptList id
		
		-- ins�rer la categorie selectionn�e en i - 2
		insertItem  bakCat coreCatList (id + 1)
		insertItem  bakCatList catScriptList (id + 1)
		
		-- deplacer la selection en i - 1
		catListLB.selection = id + 1
		
		-- supprimer l'ini
		delIniSetting iniCoreFileName  "coreScriptList"
		
		-- 	r��crire toutes les cat�gories dans l'ini
		for i = 1 to coreCatList.count do
		(
			local coreData = with printAllElements on catScriptList[i] as string
			setINISetting iniCoreFileName  "coreScriptList" coreCatList[i] coreData
		)
		
		loadCategories()
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
		
		format "del id: %\n" catListLB.selection
		
		delIniSetting iniCoreFileName "coreScriptList"  coreCatList[bakId]
		loadCategories()
		coreScriptArray = loadCore2 coreCatList[coreCatList.count]
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
		qsort coreScriptArray sortByPathname
		refreshUI()
	)
	
	on removeScriptBT pressed do
	(
		
		idstodel = scriptListMLB.selection as array
		for i = idstodel.count to 1 by - 1 do 
		(
			format "i: % idstodel[i]: % script: %\n" i idstodel[i] coreScriptArray[idstodel[i]]
			deleteitem coreScriptArray idstodel[i]
		)

		local coreData = with printAllElements on coreScriptArray as string
		setINISetting iniCoreFileName  "coreScriptList" coreCatList[catListLB.selection] coreData
		
		coreScriptArray = loadCore2 coreCatList[catListLB.selection]
		
		refreshUI()
	)

)
createdialog superLauncherRLT width: 300


