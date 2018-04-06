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
/*
getScriptVersion (getThisScriptFilename())
*/

-- load le callback pour tagger si les fichiers ont du railclone à l interieur
filein  ((getRoot ()) + "sceneManagement/tag_fileProperties.ms")

-- load function pour parenter comme dans maya
filein ((getRoot ()) + "Rig/lastParent_def.ms")

-- load function pour enregistrer et loader les préferences
filein ((getRoot ()) + "rollout_pref/rollout_pref.ms")

-- load de la fonction pour isoler la selection sans faire de focus dessus
filein ((getRoot ()) + "sceneManagement/isolateSlectionCustom.ms")


-- ########## UPDATE DES MACROS
-- copy les icones des macros dans le dossier user
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
		local res = copyFile  ic (iconsRoot + "\\"+ (filenameFromPath ic))	
		if res == true then format "copy in \"\UI\Icons\" done : %\n" ic
		else format "copy in \"\UI\Icons\" fail: %\n" ic
		
		local res2 = copyFile  ic (iconsRoot2 + "\\"+ (filenameFromPath ic))
		if res2 == true then format "copy in \"usericons\" done : %\n" ic
		else format "copy in \"usericons\" fail: %\n" ic
		
	-- 	copyFile  icon iconsRoot 
	)
)
copyBmpIcons()

-- nettoyage des macroscripts existant
useMacrosPath =  (getdir #maxdata) + "\usermacros"
armadasMacroAr = #()

if doesfileexist useMacrosPath then
(
	armadasMacroAr = getfiles ((getdir #maxdata) + "\usermacros\ArmadasScripts*")
)
for macro in armadasMacroAr do format "%\n" macro
	
-- load du fichier de macros
-- filein ((getRoot ()) + "scriptInstaller/armadasMacrosList.ms")



