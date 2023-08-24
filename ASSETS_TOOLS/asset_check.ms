/*
asset checker
-- check pre save
	-- clean du fichier. cf fonction
		-- editeur de materiaux vide
		-- slate material vide
		-- scale des objets
		-- ggx
		-- check des id de materiaux et d'objet

	-- check des textures 
		-- fix des textures trouvé mais pas bien dirigé
			-- parser le dossier et les sous dossiers du fichier max pour re linker les textures 
		-- textures manquantes
		-- textures trouvées su c

-- enregistrer asset

-- chemin d'enregistrement du fichier


-- check post save
	-- chemin d'enregistrement des textures
	-- rename des objets
	-- rename des materiaux
	-- vrbmp
*/


/*
basePath = getFiles  ((getFilenamepath ATSOP_paths[1]) + "*") recurse: true
for p in basePath do print p

basePath = getDirectories  ((getFilenamepath ATSOP_paths[1])+ "*") recurse: true
*/

ATSOps.GetFiles &ATSOP_paths
-- ATSOP_paths[1]
for i = 2 to ATSOP_paths.count do
(
	local goodBmpFile = undefined 

	if (doesFileExist  ATSOP_paths[i]) then
	(
		goodBmpFile =  ATSOP_paths[i]
		format "goodBmpFile: %\n" goodBmpFile
	)
	-- si le chemin de dossier n'existe pas, tester la présense du fichier dans le dossier du fichier max
/* 	else if (getFilenamepath ATSOP_paths[i]).count == 0 then 
	(
		if doesFileExist ((getFilenamepath ATSOP_paths[1])  +  ATSOP_paths[i]) then 
		(
			goodBmpFile = ((getFilenamepath ATSOP_paths[1])  +  ATSOP_paths[i])
			format "goodBmpFile mais non fixé: %\n" goodBmpFile
		
			-- fixation de la texture
			ATSOps.SelectFiles ATSOP_paths[i]
			ATSOps.SetPathOnSelection (getFilenamepath ATSOP_paths[1])
		)
		else(format "not goodBmpFile et toujours non fixé\n")
	) */
	-- si le chemin du fichier n'existe pas, tester la présense du fichier dans le dossier du fichier max et ses sous dossiers
	else if not  (doesFileExist  ATSOP_paths[i]) then
	(
		
		-- tentative pour rlinker sur le dossier de tavail
			-- collecte des sous dossiers du dossier de travail
				local basePaths = getDirectories  ((getFilenamepath ATSOP_paths[1])+ "*") recurse: true
				appendIfUnique basePaths (getFilenamepath ATSOP_paths[1])
		-- 		format "basePaths: %\n" basePaths
				for p in basePaths do
				(
					local f = filenameFromPath  ATSOP_paths[i]
		-- 			format "p+f: %\n" (p+f)
					local tryName = p + f
					format "tryName: %\n" tryName
					if doesFileExist tryName then
					(
						ATSOps.SelectFiles ATSOP_paths[i]
						ATSOps.SetPathOnSelection p
						format "reLinked: %\n " tryName
					)
					else
					(
						format "not reLinked: %\n " tryName
					)
					
				)
		
		-- tentative pour relinker dans shared Autodesk
		-- tentative de relink sur le dossier skp
		-- tentative pour relinker sur M

	)
	-- si le fichier ne commence pas par M ou X 
	-- si le chemin commence par c, collecter les textures
	
	-- si le chemin commence par C:\Program Files (x86)\Common Files\Autodesk Shared\Materials
		-- tester si le fichier existe sur C
		-- tester le fcihier sur M

	
		-- si le fichier existe sur C et M
			-- relinker sur M
		-- si le fichier existe sur C et pas sur M
			-- copier fichier et linker sur M
		-- si le fichier existe pas sur C mais sur M
			-- relinker sur M
		-- si le fichier existe ni sur C, ni sur M
			-- pas de solutions


	else
	(
		format "not goodBmpFile: %\n" ATSOP_paths[i]
	)	
)




