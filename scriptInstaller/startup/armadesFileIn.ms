/*
doc:
	-- ce fichier 
		- 1 - preload les fonctions necessaire à faire fonctionner les macros
		- 2 -  supprime les macros existantes
		- 3 -  installe le macros et les icones
	
	Le fichier est utilisé à la première installation et à chaque ouverture de max

maj:
	x- loader une methode au startup qui retourne le root plutot que rappeler l'ini à chaque fois (getRoot)
	/- créer deux méthodes générales pour enregistrer et charger les favoris
	/- créer un fichier dans le startup de max qui load les methodes souhaité (filein "lasparent.ms")
	x- pre load des script avant macro script:
		x- soit dans le fichier plugin soit ajouter une adresse dans les fichier user "pluginpaths": ajouter le chemin au plugin path

	/- déplacer ce script dans le dossier startup pour créer un update à chaque démarrage:
		-- nettoyer les macroscripts existants dans le #maxdata
		-- nettoyer le dossier startup de "armadasfilein.ms"

		-- updater le root dans l'armadas script.ini
		-- updater les icons
		-- updater le pluginpath.ini

	-- mettre en place un systeme de versionning des script et ouvrir la dernière version valide
	
	-- créer une table pour lister les versions de script à loader dans les macroscript
		-- permet de porposer une table wip/debug/published
		-- s'appuie sur le versionnement dans des dossiers
		-- propose de faire la bascule entre wip/debup/published
		--permet d'accorder des autorisations
		
	x- créer un script de reload (comment une reinstallation)
	-- sur le mode du reload proposé un switch entre wip/debug / publish
		-- est ce que la separation wip/debug/publish est necessaire? est ce que deux list de macros distintes (armadascript(wip) et visiolab(publish)) n'est pas plus pertinente (pas besoin de switch)?
	
	-- créer un menu visiolab automatiquement avec menuMan.getMainMenuBar
*/




fn getRoot =
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)

-- clean des macros_script
format "########### visiolab macros cleaning:\n"
allMacrosAr = getFiles ((GetDir #maxData) + "usermacros\\*")
for m in allMacrosAr do
(
	if MatchPattern (filenameFromPath m) pattern: "*Visiolab*" ignoreCase: false then
	(
		if (deleteFile m) then 	format "deleted: %\n" m
	)
	
	else if MatchPattern (filenameFromPath m) pattern: "*ArmadasScripts*" ignoreCase: false then
	(
		if (deleteFile m) then 	format "deleted: %\n" m
	)
)
format "########### visiolab macros cleaning done!:\n\n"

-- pre Load des fonctions
format "########### armadasScripts preload started:\n"
filein ((getRoot ()) + "scriptInstaller/armadasScriptsPreLoad.ms")
format "########### armadasScripts preload done!\n\n"

-- load des modules pythons
format "########### load python modules started:\n"
python.ExecuteFile ((getRoot ()) + "scriptInstaller/load_py_module.py")
format "########### load python modules done!\n\n"

-- load du fichier de macros armadas
format "########### load armadas macros started:\n"
filein ((getRoot ()) + "scriptInstaller/armadasMacrosList.ms")
allMacrosAr = getFiles ((GetDir #maxData) + "usermacros\\*")
for m in allMacrosAr where MatchPattern (filenameFromPath m) pattern: "*ArmadasScripts*" ignoreCase: false do format "installed: %\n" m
format "########### load armadas macros done!\n\n"

-- load du fichier de macros visiolab
format "########### load visiolab macros started:\n"
filein ((getRoot ()) + "scriptInstaller/visiolabMacrosList.ms")
allMacrosAr = getFiles ((GetDir #maxData) + "usermacros\\*")
for m in allMacrosAr where MatchPattern (filenameFromPath m) pattern: "*Visiolab*" ignoreCase: false do format "installed: %\n" m
format "########### load visiolab macros!\n\n"


-- load du tracker de dossier
(
	format "########### load visiolab folders tracker:%\n" folderTracker
	local folderTrackerStart = false
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local testBool = hasINISetting armadasScriptsIni "folderOpenRLT" "startCB"
	if testBool then  folderTrackerStart = getINISetting  armadasScriptsIni "folderOpenRLT" "startCB"
	try(folderTrackerStart = folderTrackerStart as booleanclass)catch() 
	
	if folderTrackerStart then filein ((getRoot ()) + "sceneManagement/folders_trackers_sb.ms")
)




