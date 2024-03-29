/*
-- maj:
	x- remove favorite
	x-- catch obsolete path, cleaner at opening 
	x- update on closing
	-- add selection set:
		-- default/all is "armadasScriptsArray=#"
		-- create set, delete set, add script to selected set remove script from selected set
		
-- debug:
	/-- eviter des erreur au load sur les filename contenant des \r \n \t
		
-- rebuild:
	/- creer une methode pour loader les favoris du core depuis un fichier externes(ini)
	/- utiliser les methodes externes pour enregistrer les pr�ferences
	/- enregistrer et loader  la liste de favoris en chemin relatif et plus en chemin absolu, comme dans le core.ini
		-- modifier methode:
			x fav to core 
			x core to fav
			-- write pref au delete
			-- write pref a l' ajout de script depuis l'explorer
			-- write pref au close
			-- load favorite manuel
			-- load favorites � l'ouverture
			
-- bug:
	-- quand on ouvre le launcher, sur le core, qu'on edite le script selectionn�, le launcher crache et efface les favoris. quand on loade les favoris et  qu'on passe ensuite sur le core tout fonctionne correctement
	-- quand on ouvre le launcher sur core et qu'on le ferme imm�diatement les favoris sont supprim�s
	
*/

-- maxFileName 

maxFileName 


-- with printAllElements on propArVal as string

fn sortbyname v1 v2 =
(
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then d=-1
	else d=1
	
--compare les numeros entre eux et les classe	
	if 	(d < 0.) then -1
	else if (d > 0.) then 1
	else 0
)

try(destroyDialog mxsLaunchRLT)catch()

struct favFileClass
(
	path,
	version = getScriptVersion path,
	fn getName =
	(
		if version != undefined then name = (getFilenameFile path) + " v."+ (version as string)
		else name = getFilenameFile path
	),
	
	name = getName(),
	
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
	local posBak
	
	local btnLine1 = 450

	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	
	local root = getRoot()
	
	local RLTvers = getScriptVersion (getThisScriptFilename())
	
	local scriptArray = #()
	
-- 	local favScriptAr = #()
	local favScriptAr2 = #()
	
	local fileClassArray = #()
	
	local fileClassCoreArray = #()
	local displayAr = #()
	
	local rltParams = #("pos", "favScriptAr2", "startupRB")
		
	
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
-- 		iniCoreFileName = root + "/scriptsManager/scriptListCore.ini"
		iniCoreFileName = getroot() + "/scriptsManager/scriptListCore.ini"
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
	group "startup:"
	(
		radiobuttons startupRB  labels: #("core","favorites")
	)
	
	listbox scriptArrayLB "scripts list:"  height: 30
	
	group "scripts actions:"
	(
		button launchBT "launch"  across: 2
		button editBT "edit"  
	)
	
	group "favorites:"
	(
		button loadFavoritesBT "load" across: 2
		button deleteBT "remove"
	)
		
	group "core:"
	(
		button loadHardCoresBT "load core" across: 3
		button favToCoreBT "fav to core" enabled: true
		button coreToFavBT "core to fav"
	)

	
--  ui functions relative
	fn refreshList =
	(
		scriptArrayLB.items = for script in displayAr collect script.name
	)
	
	-- Actions
	fn refreshUI =
	(
		if RLTvers != undefined then mxsLaunchRLT.title = mxsLaunchRLT.title + " v." + (RLTvers as string)
	)
	
	fn writeCoreToFav =
	(
		fileClassArray = loadCore2()
-- 		favScriptAr  = for script in fileClassArray collect script.path
		favScriptAr2  = for script in fileClassArray collect (substitutestring script.path root "")
-- 		format "favScriptAr: %\n" favScriptAr
		format "favScriptAr2: %\n" favScriptAr2

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

-- 		format "favScriptAr: %\n" favScriptAr 
-- 		format "favScriptAr2: %\n" favScriptAr2
		
		-- load des favorites au demarrage pour �viter l'effacement des favoris � la fermeture (ecriture d'un array vide)
		fileClassArray = loadFavorites2()
-- 		format "fileClassArray: %\n" fileClassArray
		
		
		if startupRB.state == 1 then
		(
			loadHardCoresBT.pressed()
		)
		else if startupRB.state == 2 then
		(
			loadFavoritesBT.pressed()
		)
		
-- 		fileClassArray = loadFavorites2()
		
-- 		displayAr = fileClassArray
-- 		refreshList()
		refreshUI()
	)
		
	on mxsLaunchRLT close do
	(
		favScriptAr2  = for script in fileClassArray collect (substituteString script.path (getroot()) "")
		writeRolloutParams mxsLaunchRLT rltParams
-- 		writeFavorite()
	)
	
	on startupRB changed choice do
	(
		format "choice: %\n" choice
		if choice == 1 then 
		(
			loadHardCoresBT.pressed()
			
		)
		else if choice == 2 then
		(
			loadFavoritesBT.pressed()
		)
		else()
	)
	
	on loadFavoritesBT pressed do
	(
		loadRolloutParams mxsLaunchRLT #("favScriptAr2")
		
		fileClassArray = loadFavorites2()
		displayAr = fileClassArray
		refreshList()
	)
	
	on favToCoreBT pressed do 
	(
		
		writeFavToCore ()
		refreshUI()
	)

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
		
		try
		(
			displayAr[scriptArrayLB.selection].launch()
-- 			filein (fileClassArray[scriptArrayLB.selection].path)
		)
		catch(format "##########ERROR############ERROR#############ERROR: %\n" (getcurrentexception()) )
		
	)
	
	on scriptArrayLB doubleClicked  arg do
	(
		displayAr[arg].launch()
	)
	
	on editBT pressed do 
	(
		edit (displayAr[scriptArrayLB.selection].path)
	)
		
	on deleteBT pressed do
	(
		if startupRB.state == 1 then
		(
			format "fonctionne exclusivement en mode Favoris\n"
		)
		else if startupRB.state == 2 then
		(
			id = scriptArrayLB.selection
			-- find selection in original array
			res = finditem fileClassArray displayAr[id] 

			deleteItem fileClassArray res

			favScriptAr2  = for script in fileClassArray collect (substituteString script.path (getroot()) "")
			-- write array list in ini
			writeRolloutParams mxsLaunchRLT rltParams

			-- reload list
			loadRolloutParams mxsLaunchRLT rltParams
				
			fileClassArray = loadFavorites2()
				
			displayAr = fileClassArray
			refreshList()
		)
		else()
	)
)
createdialog mxsLaunchRLT width:300 style: #(#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )


-- setdialogpos mxsLaunchRLT [0,0]
