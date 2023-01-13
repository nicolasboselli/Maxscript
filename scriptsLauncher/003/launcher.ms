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
		execScriptBT.pressed()
	)
	
	on execScriptBT pressed do
	(
		format "execute script: %\n" (getroot() + coreScriptArray2[scriptList2MLT.selection])
		try (filein (getroot() + coreScriptArray2[scriptList2MLT.selection])) catch(format "##########ERROR############ERROR#############ERROR: %\n" (getcurrentexception()))
	)

	on openScriptBT pressed do 
	(
		format "open script: %\n" (getroot() + coreScriptArray2[scriptList2MLT.selection])
		edit (getroot() + coreScriptArray2[scriptList2MLT.selection])
	)
	

)
createDialog launcherRLT
