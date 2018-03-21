/*
-- maj:
	x- remove favorite
	x-- catch obsolete path, cleaner at opening 
	x- update on closing
	-- add selection set:
		-- default/all is "armadasScriptsArray=#"
		-- create set, delete set, add script to selected set remove script from selected set
		
-- debug:
	-- eviter des erreur au load sur les filename contenant des \r \n \t
		
-- rebuild:
	/- creer une methode pour loader les favoris du core depuis un fichier externes(ini)
	/- utiliser les methodes externes pour enregistrer les préferences
	/- enregistrer et loader  la liste de favoris en chemin relatif et plus en chemin absolu, comme dans le core.ini
		-- modifier methode:
			x fav to core 
			x core to fav
			-- write pref au delete
			-- write pref a l' ajout de script depuis l'explorer
			-- write pref au close
			-- load favorite manuel
			-- load favorites à l'ouverture
	
*/


-- with printAllElements on propArVal as string

fn sortbyname v1 v2 =
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

try(destroyDialog mxsLaunchRLT)catch()

struct favFileClass
(
	path,
	name = getFilenameFile path,
	
	fn launch =
	(
		if doesfileexist path then
		(
			try (filein path) catch(format "##########ERROR############ERROR#############ERROR: %\n" (getcurrentexception()))
		)
		else
		(
			print "no script"
		)
	)
)

rollout mxsLaunchRLT "maxscript launcher"
(
-- 	local var = checkIniFileFn()
	local posBak
	
	local btnLine1 = 450

	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	
	local root = getRoot()
	
-- 	local favAr = #()
	
-- 	local root = modeArchiScriptRoot
	local scriptArray = #()
	
	local favScriptAr = #()
	local favScriptAr2 = #()
-- 	local favScriptAr2Complete = #()
	
	local fileClassArray = #()
	
	local fileClassCoreArray = #()
	local displayAr = #()
	
	local rltParams = #("pos", "favScriptAr", "favScriptAr2")
		
	-- functions
	/*
	fn loadFavorites =
	(
		local favScriptArray = #()
		local favAr = #()
		favScriptAr =#()
		
		-- load favorite list from ini file
		if (hasINISetting armadasScriptsIni mxsLaunchRLT.name  "favScriptAr") == true then
		(
			format "ini key found\n"
			favArStr = getINISetting armadasScriptsIni  mxsLaunchRLT.name "favScriptAr"
			favArTmp = execute favArStr
			
-- 			print favArTmp
			-- test if file exist
			for onePath in favArTmp do
			(
				local cleanPath = substituteString onePath "\\" "/"
				if doesFileExist cleanPath == true then
				(
					format "filename found: %\n" cleanPath
					appendifunique favScriptAr cleanPath
				)
				else
				(
					format "filename not found: %\n" cleanPath
				)
			)
			
			-- collect good scripts as favFileClass instance
			if favScriptAr.count >= 1 then
			(
				favScriptArray = for script in favScriptAr collect (favFileClass script)
			)
			else 
			(
				format "no favorites to load\n"
			)
			
			-- correct file string
			format "favorites scripts loaded: %\n" favScriptAr
			
			qsort favScriptArray sortbyname
			favScriptArray
		)
		else
		(
			favScriptAr = #()
			format "favorites array init\n"
		)
	)
*/
		
		
	fn loadFavorites =
	(
		local favScriptArray = #()
-- 		local favAr = #()
		local tmpfavScriptAr =#()
		
		-- collect filenames
		for p in favScriptAr do
		(
			local cleanPath = substituteString p "\\" "/"
			format "cleanPath: %\n" cleanPath
			if doesfileexist cleanPath then
			(
					appendifunique tmpfavScriptAr cleanPath
			)
		)
		format "tmpfavScriptAr: %\n" tmpfavScriptAr
		
		-- collect good scripts as favFileClass instance
		if tmpfavScriptAr.count >= 1 then
		(
			favScriptArray = for script in favScriptAr collect (favFileClass script)
		)
		else 
		(
			format "no favorites to load\n"
		)

		qsort favScriptArray sortbyname
		favScriptArray
	)
	
	
	fn loadfavorites2 =
	(
		local favScriptArray = #()
-- 		local favAr = #()
		local tmpfavScriptAr =#()
		
		-- collect filenames
		for p in favScriptAr2 do
		(
			local tmpPath = (getRoot() + p)
			local cleanPath = substituteString tmpPath "\\" "/"
			format "cleanPath: %\n" cleanPath
			
			if doesfileexist cleanPath then
			(
					appendifunique tmpfavScriptAr cleanPath
			)
		)
		
		-- collect structure
		if tmpfavScriptAr.count >= 1 then
		(
			favScriptArray = for script in tmpfavScriptAr collect (favFileClass script)
		)
		else 
		(
			format "no favorites to load\n"
		)
		
		qsort favScriptArray sortbyname
		favScriptArray
	)
	
	
	fn loadCore2 = 
	(
		local coreScriptArrayStr = #()
		local coreScriptArray = #()
		
		-- recuperer le fichier ini
		iniCoreFileName = root + "/scriptsManager/scriptListCore.ini"
		format "core ini file: %\n" iniCoreFileName
		
		-- collect clean list
		if doesfileexist iniCoreFileName then
		(
			coreArStr = getINISetting iniCoreFileName  "coreScriptList" "scriptArray"
			coreArStrTmp = execute coreArStr
			format "core script list: %\n" coreArStrTmp
			
			-- test if file exist
			for onePath in coreArStrTmp do
			(
				if doesFileExist (root + onePath) then
				(
					appendifunique coreScriptArrayStr (root + onePath)
				)else(format "obsolete path: %\n" (root + onePath))
			)
		)
		else 	(format "ini file doesn't exist: %\n" iniCoreFileName)
		format "core scripts loaded: % \n" coreScriptArrayStr
		
		-- collecte des structures
		coreScriptArray = for script in coreScriptArrayStr collect (favFileClass script)
		
-- 		format "script list: %\n" coreScriptArray
		-- recuperer la liste de script du fichier ini
		coreScriptArray
	)
	
	fn writeFavToCore =
	(
		iniCoreFileName = (getRoot()) + "/scriptsManager/scriptListCore.ini"
		
		if doesfileexist iniCoreFileName then
		(
			format "fileClassArray: %\n" fileClassArray
			local scriptsPathesAr = #()
			for script in fileClassArray do
			(
				local pathEnd = substitutestring script.path root ""
				format "pathEnd: %\n" pathEnd
				append scriptsPathesAr pathEnd
			)			
			
			local coreData = with printAllElements on scriptsPathesAr as string
			format "core data: %\n" coreData
			coreArStr = setINISetting iniCoreFileName  "coreScriptList" "scriptArray" coreData
		)
		else 	(format "ini file doesn't exist: %\n" iniCoreFileName)
	)
		
-- 	UI
	group "favorites:"
	(
		button loadFavoritesBT "load" across: 2
		button deleteBT "remove"
	)
	
	group "scripts actions:"
	(
		button launchBT "launch"  across: 2
		button editBT "edit"  
	)

-- 	button sortListBT  "sort by name"
		
	listbox scriptArrayLB "scripts list:"  height: 30

-- 	button openFolder "open scripts folder" 
	
		
	group "core:"
	(
		button loadHardCoresBT "load core" across: 3
		button favToCoreBT "fav to core" 
		button coreToFavBT "core to fav"
	)

	
--  ui functions relative
	fn refreshList =
	(
		scriptArrayLB.items = for script in displayAr collect script.name
	)
	
	fn writeCoreToFav =
	(
		fileClassArray = loadCore2()
		favScriptAr  = for script in fileClassArray collect script.path
		favScriptAr2  = for script in fileClassArray collect script.path
-- 		writeFavorite()
		writeRolloutParams mxsLaunchRLT rltParams
		
		loadRolloutParams mxsLaunchRLT rltParams
		fileClassArray = loadFavorites2()
		displayAr = fileClassArray
		refreshList()
	)
	
-- 	actions

	on mxsLaunchRLT open do
	(
		loadRolloutParams mxsLaunchRLT rltParams

		format "favScriptAr: %\n" favScriptAr 
		format "favScriptAr2: %\n" favScriptAr2
		
		fileClassArray = loadFavorites2()
		
		displayAr = fileClassArray
		refreshList()
	)
		
	on mxsLaunchRLT close do
	(
		favScriptAr2  = for script in fileClassArray collect (substituteString script.path (getroot()) "")
		writeRolloutParams mxsLaunchRLT rltParams
-- 		writeFavorite()
	)
	
	on loadFavoritesBT pressed do
	(
		loadRolloutParams mxsLaunchRLT rltParams
		
		fileClassArray = loadFavorites2()
		displayAr = fileClassArray
		refreshList()
	)
	
	on favToCoreBT pressed do writeFavToCore ()

	on coreToFavBT pressed do writeCoreToFav ()
	
	on loadHardCoresBT pressed do
	(
-- 		loadCore2 ()
		fileClassCoreArray = loadCore2()
		displayAr = fileClassCoreArray
-- 		format "displayAr:%\n" displayAr
		refreshList()
	)
		
	on launchBT pressed do
	(
-- 		format "sel: %\n" scriptArrayLB.selection
		displayAr[scriptArrayLB.selection].launch()
		/*
		try
		(
			filein (fileClassArray[scriptArrayLB.selection].path)
		)catch(format "##########ERROR############ERROR#############ERROR: %\n" (getcurrentexception()) )
		*/
	)
	
	on scriptArrayLB doubleClicked  arg do
	(
		displayAr[arg].launch()
	)
	
	on editBT pressed do edit (fileClassArray[scriptArrayLB.selection].path)
		
	on deleteBT pressed do
	(
		id = scriptArrayLB.selection
		-- find selection in original array
		res = finditem fileClassArray displayAr[id] 
-- 		format "remove: %\n" displayAr[id] 
		-- delete selection
-- 		format "fileClassArrayCount: % \n"  fileClassArray.count
		deleteItem fileClassArray res
-- 		format "fileClassArrayCount: % \n"  fileClassArray.count
-- 		format "count1: % count2:%\n" test.count fileClassArray.count
		favScriptAr  = for script in fileClassArray collect script.path
		favScriptAr2  = for script in fileClassArray collect (substituteString script.path (getroot()) "")
		-- write array list in ini
		writeRolloutParams mxsLaunchRLT rltParams

		-- reload list
		loadRolloutParams mxsLaunchRLT rltParams
			
		fileClassArray = loadFavorites2()
			
		displayAr = fileClassArray
		refreshList()
	)
)
createdialog mxsLaunchRLT width:300 style: #(#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )



