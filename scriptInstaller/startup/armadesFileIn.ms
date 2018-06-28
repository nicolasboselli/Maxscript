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
	
-- pre Load des fonctions
filein ((getRoot ()) + "scriptInstaller/armadasScriptsPreLoad.ms")

-- load du fichier de macros armadas
filein ((getRoot ()) + "scriptInstaller/armadasMacrosList.ms")

-- load du fichier de macros visiolab
filein ((getRoot ()) + "scriptInstaller/visiolabMacrosList.ms")




