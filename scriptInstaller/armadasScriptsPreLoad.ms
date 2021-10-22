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

-- ########## PRELOAD DES FONCTIONS
fn getRoot =
(
	local armadasScriptsIni =  (GetDir #maxData) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)
format "loaded getroot() function: %\n" getroot


fn getScriptVersion oneScript =
(
	-- retourner le dossier au dessus du script
	local folderTmp = (getFilenamePath oneScript)
	-- 
	local splitFolder = filterString folderTmp "\\"
		
	try
	(
		splitFolder[splitFolder.count]	as integer
	)
	catch
	(
		undefined
	)
)
format "loaded getScriptVersion() function: %\n" getScriptVersion

/*
getScriptVersion (getThisScriptFilename())
*/

-- load le callback pour tagger si les fichiers ont du railclone à l interieur
-- filein  ((getRoot ()) + "sceneManagement/tag_fileProperties.ms")

-- load function pour parenter comme dans maya
filein ((getRoot ()) + "Rig/lastParent_def.ms")
format "loaded lastParent() function:\n"

-- load function pour enregistrer et loader les préferences
filein ((getRoot ()) + "rollout_pref/rollout_pref.ms")
format "loaded: rollout_pref() function\n"

-- load de la fonction pour isoler la selection sans faire de focus dessus
filein ((getRoot ()) + "sceneManagement/isolateSlectionCustom.ms")
format "loaded: isolateSlectionCustom() function\n"

-- ########## UPDATE DES MACROS
-- copy les icones des macros dans le dossier user
-- maj: tester si la copie est nécessaire avant de le faire

fn copyBmpIcons =
(
	local iconsArray = getfiles ((getRoot()) + "icons\*.bmp")
	
	-- determine les dossiers de destination
	iconsRoot = (getdir #maxdata) + "\UI\Icons"
	if not doesfileexist iconsRoot  then makedir iconsRoot all: true
	
	iconsRoot2 = (getdir #maxdata) + "usericons"
	if not doesfileexist iconsRoot2  then makedir iconsRoot2 all: true	
	
	-- make copy
	for ic in iconsArray do
	(	
		local copyIC = iconsRoot + "\\"+ (filenameFromPath ic)
		if (deleteFile copyIC) then () -- format "deleted icon: %\n" copyIC 
		if (copyFile  ic copyIC) then format "copied icon: %\n" copyIC else format "copy fail: %\n" ic

		
		local copyIC2 = iconsRoot2 + "\\"+ (filenameFromPath ic)
		if (deleteFile copyIC2) then () -- format "deleted icon 2: %\n" copyIC2
		if (copyFile  ic copyIC2) then format "copied icon 2: %\n" copyIC2 else format "copy fail: %\n" ic
		
	-- 	copyFile  icon iconsRoot 
	)
)

format "### copy icons started\n"
copyBmpIcons()
format "### copy icons done!\n"






