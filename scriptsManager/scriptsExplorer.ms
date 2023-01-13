/*
todo:

	-- enregister les preferences et la position du script
	-- toggle pour backupper/ debakkuper les fichiers
	-- memoriser le dernier dossier ouvert
	/- proposer le classement alphabatique ou par date des cripts et dossier
	
	x- ecrire les favoris dans le core; créé un fichier à part pour le core
	
	-- prendre en compte des script du meme nom au copy/pastee et au rename pour numeroter les version
	
	/- creer de nouveaux dossier
		-- proposer un rename a l acreation
		-- prendre en compte les doublons pour numéroter les copies
	/- delete dossier: verifier que le dossier existe, verifier que le dossier est vide, supprimer le contenu du dossier
		-- alerter si le dossier est vide
		-- proposer de delete le dossier avec sont contenu
	/- renommer des dossiers:
		-- alerter si le nom existe deja
	-- copier/coller ou déplacer les dossiers
	
	-- faire fonctionner le copy/paste sur selection multiple
	
debug:
	-- le copy/paste crée toujours une version *_copy. Comparer l'ancien et le nouveau chemin pour faire la copie
	-- pourquoi charger le favAr au demarrage?
	
 rebuild:
	 -- revoir la fonction pour trouver le dossier parent
	 x- revoir les fonction copy/paste/duplicate pour que duplicate execute un copy/paste
	 x- faire fonctionner le rename de dossier avec le meme rollout que pour les scripts
	 -- revoir le tri des fchiers: bakuper changer le onlyMxs en ignoreBak
	 x- passer la selection folder ou script mode à l ouverture du rollout rename ET PAS pas des methodes init: dans les methodes init à cause du modal
*/


-- sort #("Z", "...", "A")

struct returnClass
(
	name = "[...]"
)	

struct folderClass 
(
	tmppath,
	path = substituteString tmppath "\\" "/",
	nameAr = filterString  path "/",
	name = "[ " + (/*toUpper*/ nameAr[nameAr.count]) + " ]"
)

struct fileClass
(
	tmppath ,
	path = substituteString tmppath "\\" "/",
	name = filenameFromPath path,
	typ = getFilenameType tmppath
)


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



try(destroydialog renameRLT)catch()
rollout renameRLT "rename" width: 400
(
	-- vars

	
	local o 
	
	local oldPath 
	local oldFilename 
	local Typ 
	
	local oldFoldPath
	local oldFoldName
	
	local folderMode = false
	local scriptMode = false
	
	local newName
	local oldname
	
	-- ui
	edittext nameET "name:"
-- 	edittext typeET "type:"
	button okBT "ok"
	
	-- functions
	fn initForScript =
	(
		renameRLT.title = "rename script"
		
		o = scriptExplorerRLT.toDisplay[scriptExplorerRLT.scriptsListLB.selection]
		
		oldPath = getFilenamePath o.path
		oldFilename = getFilenameFile o.path
		Typ = getFilenameType o.path
		
		nameET.text = oldFilename + typ
	)
	
	fn initforFolder =
	(
		renameRLT.title = "rename folder"
		
		o = scriptExplorerRLT.toDisplay[scriptExplorerRLT.scriptsListLB.selection]
		
		oldFoldPath = scriptExplorerRLT.returnParentFolder o.path
		oldFoldName = o.nameAr[o.nameAr.count]

		nameET.text = oldFoldName
	)
	
	-- actions
	on renameRLT open do
	(
		o = scriptExplorerRLT.toDisplay[scriptExplorerRLT.scriptsListLB.selection]
		
		if classof o == folderClass then folderMode = true
		else if classof o == fileClass then scriptMode = true
		else()
		
		if scriptMode then initForScript()
		else if folderMode then initForFolder()
		else()
	)
	
	on nameET entered val do okBT.pressed()
	
	on okBT pressed do
	(
		if scriptMode then
		(
			oldname =  oldPath + oldFilename + Typ
			newName = oldPath + nameET.text
		)
		else if folderMode then
		(
			oldname = oldFoldPath + oldFoldName
			newName = nameET.text
		)
		else
		(
		)
		destroyDialog renameRLT
	)
)


try(destroyDialog scriptExplorerRLT)catch()
rollout scriptExplorerRLT "Scripts Explorer"
(
	
-- 	vars
-- 	local maxIni = getMAXIniFile()
-- 	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	
	local params = #("pos")
	
	/*
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local tmpRroot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	local	root = substituteString tmpRroot "\\" "/"
	*/
	
	local root = getRoot()
	
	local favAr = #()
	local favAr2 = #()

	local menuRC
	
	local fileToCopy
	local otoCopy
	
	local newName
	
-- 	local root = getFilenamePath  (getThisScriptFilename() )
	local folderContent
-- 	local folderAr = #()
	
-- 	local filesAr = #()
	local allAr = #()
	local toDisplay = #()
	
	global currentFolder
	
-- 	UI
	edittext pathET "current folder:" readonly: true 
	button openFoldBT "open folder" across: 3
	
	button accessIniBT "access ini"
	button accessIniFolderBT "access ini folder"
	
	checkbox onlyMs "ignore .bak" checked: true
	 
	listbox scriptsListLB "Scripts:" tooltip: "script list" height: 30 -- across: 2
-- 	dotNetControl tv "TreeView"  height:450 visible: false
	
	group "actions:"
	(
		button enterFolderBT "enter folder" tooltip: "enter folder" across: 3
		button backFolderBT "parent folder"
		button copyPathBT "copy path"
		
		button editScriptBT "edit script" across: 2
		button launchScriptBT "launch script" 

	)
	
	group "favorites:"
	(
		button printPathBT "add to favorites" across: 2
		button addToCoreBT "add to core"
	)
		
-- 	functions
	
	fn copyPath =
	(
		pathTmp =  try(toDisplay[scriptsListLB.selection].path) catch()
		setclipboardText pathTmp
	)
		
	fn deleteFolder folderPath: =
	(
		local sioDir = dotNetClass "System.IO.Directory"
		if (SIODir.Exists folderPath) do SIODir.Delete (folderPath) true
	)

	
	fn scanFolder onePath =
	(
		-- init de l'array
-- 		allAr = #(returnClass ())
		
		-- collecte des dossiers
		folderContent = getDirectories (onePath + "*")
		folderAr = for fo in folderContent collect folderClass fo
		
		-- collecte des fichiers
		filesContent = getFiles (onePath + "*")
		filesAr = for f in filesContent  collect fileClass f
		
		format "scan done: %\n" onePath
-- 		#(returnClass ()) + folderAr +filesAr
		folderAr +filesAr
	)
	
	fn returnParentFolder folderPath =
	(
		splitFolder = filterString folderPath "/"
		
		sum = ""
		for i = 1 to (splitFolder.count - 1) do
		(
			sum = sum + splitFolder[i] + "/"
		)
		sum
	)
	
	-- Vars dependant
	
	fn collectValues maxscriptOnly: false =
	(
		allAr = scanFolder currentFolder
		
		toDisplay =#()
		for o in allAr do
		(
			if classof o == fileclass and maxscriptOnly then
			(
				if o.typ == ".ms" or o.typ == ".mse" then
				(
					append toDisplay o
				)
			)
			else append toDisplay o
		)
		
		-- classe toDisplay par ordre alphabetique
		qsort toDisplay sortbyname
		insertitem  (returnClass ()) toDisplay 1
		toDisplay
	)
	
		
	fn collectValues2 ignoreBak: false =
	(
		allAr = scanFolder currentFolder
		
		toDisplay =#()
		for o in allAr do
		(
			if classof o == fileclass and matchpattern o.path  then
			(
				if o.typ == ".ms" or o.typ == ".mse" then
				(
					append toDisplay o
				)
			)
			else append toDisplay o
		)
	)
	
	fn duplicateFile =
	(
		o = toDisplay[scriptsListLB.selection]
		PathOne = getFilenamePath o.path
		FilenameOne = getFilenameFile o.path
		Typ = getFilenameType o.path
		
		copyFile o.path (PathOne + FilenameOne + "_copy" + Typ)
	)

	-- UI dependant
	fn refreshUI =
	(
		format "currentFolder: %\n" currentFolder
		pathET.text = currentFolder
		scriptsListLB.items = for elt in toDisplay collect  elt.name
	)

	
	fn createRCMenu =
	(
		rcmenu menuRC
		(
			menuItem editIT "edit script" enabled: true
			menuItem launchIT "launch script" enabled: true
			separator sep3
			menuItem copyIT "copy" enabled: true
			menuItem pasteIT "paste"  enabled: true
			menuItem dupIT "duplicate"  enabled: true
			menuItem delIT "delete"  enabled: true
			separator sep2
			menuItem renameIT "rename script" enabled: true
			menuItem bakIT "backup script toggle" enabled: true
			menuItem createFolderIT "create folder" enabled: true
-- 			menuItem addToFavIT "add to favorites" enabled: false
			separator sep1
			menuItem foldIT "open folder" enabled: false
			menuItem pathIT "copy Path" 
			
			on editIT picked do editScriptBT.pressed()
			on launchIT picked do launchScriptBT.pressed()
			
			on copyIT picked do
			(
				otoCopy = toDisplay[scriptsListLB.selection]
				o = toDisplay[scriptsListLB.selection]
-- 				if classof o == filecla
				fileToCopy = o.path
			)
			
			on pasteIT picked do
			(
				if classof otoCopy == fileclass then
				(
					local res 
					
					PathOne = getFilenamePath otoCopy.path
					FilenameOne = getFilenameFile otoCopy.path
					Typ = getFilenameType otoCopy.path
					
					-- tester le doublon avant la copy
					-- créer une numerotation plutot que copy
					if doesfileexist otoCopy.path then
					(
						res = copyFile otoCopy.path (currentFolder + FilenameOne + "_copy" + Typ)
					)
					else
					(
						res = copyFile otoCopy.path (currentFolder + FilenameOne + Typ)
					)
					
					format "copy done: %, %\n" res otoCopy.path
				)
				else if otoCopy == folderClass then
				(
					format "pas de copie de dossier pour le moment\n"
				)
				else()
				
				collectValues maxscriptOnly: onlyMs.state
				refreshUI()
			)
			
			on dupIT picked do
			(
				copyIT.picked()
				pasteIT.picked()
			)
			
			on delIT picked do
			(
				o = toDisplay[scriptsListLB.selection]
				if classof o == fileClass then
				(
					deleteFile o.path
				)
				else if classof o == folderClass then
				(
					local str = stringstream ""
					format "rd \"%\" \npause\n" o.path to: str
					order = str as string
					DOSCommand order
					
					format "order: % \n" order
				)
				else()
				
				collectValues maxscriptOnly: onlyMs.state
				refreshUI()
			)
			
			on renameIT picked do
			(
				createdialog renameRLT modal: true escapeEnable: true
				
				if renameRLT.scriptMode then
				(
					local res = renameFile renameRLT.oldname renameRLT.newName
					format "rename done: % : % >>> %\n" res renameRLT.oldname renameRLT.newName
-- 					format "order: % \n" order
				)
				else if renameRLT.folderMode then
				(
					local str = stringstream ""
					format "rename \"%\" \"%\" \npause\n" renameRLT.oldname renameRLT.newName to: str
					order = str as string

					format "order: % \n" order
					DOSCommand order
				)
				else()
				
				collectValues maxscriptOnly: onlyMs.state
				refreshUI()
			)
			
			on bakIT picked do
			(
				o = toDisplay[scriptsListLB.selection]
				if classof o == fileClass then
				(
					if getFilenameType o.path == ".bak" then local newFilename = substitutestring o.path ".bak" ""
					else	local newFilename =  o.path + ".bak"
				)
				local res = renameFile o.path newFilename
				collectValues maxscriptOnly: onlyMs.state
				refreshUI()
			)
			
			on createFolderIT picked do
			(	
				-- prendre en compte le doublan

				makeDir (currentFolder + "new_folder")
				
				collectValues maxscriptOnly: onlyMs.state
				refreshUI()
				
				-- proposer un rename
-- 				createdialog renameRLT modal: true escapeEnable: true
-- 				renameRLT.initforFolder ()
			)
			
			-- 			on foldIT picked do 
			on pathIT picked do copyPath ()
		)
	)
	
-- 	actions
	
	on accessIniBT pressed do
	(
		doscommand ("explorer " + armadasScriptsIni)
	)
	
	on accessIniFolderBT pressed do
	(
		doscommand ("explorer " + (getdir #maxdata))
	
	)
		
	on openFoldBT pressed do 
	(
		foldToOpen = substituteString currentFolder "/" "\\"
		doscommand ("explorer " +  foldToOpen)
	)

	on scriptExplorerRLT open do
	(
		
		loadRolloutParams scriptExplorerRLT Params
		-- scan des dossiers
		
		if currentFolder == undefined then currentFolder = root
		else if not doesfileexist currentFolder then currentFolder = root
			
		collectValues maxscriptOnly: onlyMs.state
		
		-- creation du rcMenu
		menuRC = createRCMenu()
		
		refreshUI()
	)
	
	on scriptExplorerRLT close do
	(
		writeRolloutParams scriptExplorerRLT Params
	)
	
	on onlyMs changed val do
	(
		collectValues maxscriptOnly: val
		refreshUI()
	)
	
	on scriptsListLB doubleClicked arg do enterFolderBT.pressed()
	
	on scriptsListLB rightClick do
	(
		popUpMenu menuRC rollout: scriptExplorerRLT
	)
	
	on enterFolderBT pressed do
	(
-- 		format "selection: %, selected: %\n" scriptsListLB.selection scriptsListLB.selected
		num = scriptsListLB.selection
		if num > 0 do
		(
			obj = toDisplay[num]
-- 			format "classof: %\n"  obj
			
			if classof obj == returnClass then
			(
				currentFolder = returnParentFolder currentFolder
-- 				allAr = scanFolder currentFolder
				collectValues maxscriptOnly: onlyMs.state
			)
			else if classof obj == folderClass then
			(
				currentFolder = obj.path
				collectValues maxscriptOnly: onlyMs.state
-- 				allAr = scanFolder currentFolder
			)
			else if classof obj == fileClass then
			(
-- 				edit obj.path
			)
			else(print "damned!")
		)
		refreshUI()
	)
	
	on backFolderBT pressed do
	(
		currentFolder = returnParentFolder currentFolder
		collectValues maxscriptOnly: onlyMs.state
-- 		allAr = scanFolder currentFolder
		refreshUI()
	)
	
	on printPathBT pressed do
	(
		-- chargement des scripts favoris
		if (hasINISetting armadasScriptsIni "mxsLaunchRLT" "favScriptAr") == true then
		(
			favArStr = getINISetting  armadasScriptsIni "mxsLaunchRLT" "favScriptAr"
			favArTmp = execute favArStr
			
			-- test if file exist
			for onePath in favArTmp do
			(
				if doesFileExist onePath do
				(
					appendifunique favAr onePath
				)
			)
		)
		else
		(
			favAr = #()
		)
		format "favorites array: %\n" favAr
		
		-- ajout d'un script aux favoris
		if classof toDisplay[scriptsListLB.selection] != folderClass then
		(
			appendifunique  favAr toDisplay[scriptsListLB.selection].path 

			format "favorites script: %\n" favAr
			setINISetting armadasScriptsIni "mxsLaunchRLT" "favScriptAr" (with printAllElements on favAr as string)
			
		)
		else
		(
			format "un dossier ne peut pas être ajouter aux favoris"
		)	
		
		
		-- chargement des scripts favoris 2
		if (hasINISetting armadasScriptsIni "mxsLaunchRLT" "favScriptAr2") == true then
		(
			favArStr2 = getINISetting  armadasScriptsIni "mxsLaunchRLT" "favScriptAr2"
			favArTmp2 = execute favArStr2
			
			-- test if file exist
			for onePath in favArTmp2 do
			(
				local tmpPath = (getRoot() + onePath)
				if doesFileExist tmpPath do
				(
					appendifunique favAr2 tmpPath
				)
			)
		)
		else
		(
			favAr2 = #()
		)
		format "favorites array: %\n" favAr2
		
		-- ajout d'un script aux favoris
		if classof toDisplay[scriptsListLB.selection] != folderClass then
		(
			-- ajout du favori
			appendifunique  favAr2 toDisplay[scriptsListLB.selection].path 
			
			-- ecriture de la liste
			local favAr22  = for script in favAr2 collect (substituteString script (getroot()) "")
			setINISetting armadasScriptsIni "mxsLaunchRLT" "favScriptAr2" (with printAllElements on favAr22 as string)
			format "favorites script 2: %\n" favAr22
		)
		else
		(
			format "un dossier ne peut pas être ajouter aux favoris\n"
		)	
		
		
	)
	
	on launchScriptBT pressed do
	(
		sel = toDisplay[scriptsListLB.selection]
		if classof sel == fileClass do
		(
			 filein (sel.path)
		)
	)
	
	on editScriptBT pressed do
	(
		sel = toDisplay[scriptsListLB.selection]
		if classof sel == fileClass do
		(
			 edit (sel.path)
		)
	)
			
	on copyPathBT pressed do copyPath ()	
	
	on addToCoreBT pressed do
	(
		
		local iniCoreFileName = getroot() + "/scriptsManager/scriptListCoreTest.ini"
		local favAr = #()
		
		-- récupérer l'array de scripts du core
		if hasINISetting iniCoreFileName "coreScriptList" "favScriptAr" then 
		(
			favArStr = getINISetting  iniCoreFileName "coreScriptList" "favScriptAr"
			favAr = execute favArStr 
		)
		else favAr = #()
		
		-- récupérer les chemins des scripts à écrire
		if not iskindof toDisplay[scriptsListLB.selection] folderClass then
		(
			-- ajout du favori
			newMs =  substituteString toDisplay[scriptsListLB.selection].path (getroot()) ""  		
			appendIfUnique favAr newMs
		)
		else
		(
			format "un dossier ne peut pas être ajouter aux favoris\n"
		)
		
		-- ecrire le nouvel array
		setINISetting iniCoreFileName "coreScriptList" "favScriptAr" (with printAllElements on favAr as string)
	)
	
)
createdialog scriptExplorerRLT width: 400


