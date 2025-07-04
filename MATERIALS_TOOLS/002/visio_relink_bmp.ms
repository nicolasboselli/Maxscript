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
		-- fix des textures trouv� mais pas bien dirig�
			-- parser le dossier et les sous dossiers du fichier max pour re linker les textures 
		-- textures manquantes
		-- textures trouv�es su c

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

fn visioRelink =
(
	-- ATSOps.GetFiles &ATSOP_paths
	-- autodeskPaths = getDirectories @"C:\Program Files (x86)\Common Files\Autodesk Shared\Materials\textures\*" recurse: true
	-- for o in autodeskPaths do format "%\n" o
	ATSOP_paths
	-- ATSOps.GetDependentFiles (maxfilepath + maxFileName) false &ATSOP_paths IncludeOutputFiles: false
	ATSOps.GetDependentFiles (maxfilepath + maxFileName) false &ATSOP_paths
	-- ATSOps.GetFiles &ATSOP_paths

	-- collecte des chemins � tester
	-- chemin du fichier max
	basePaths = #(maxfilepath)
	maxPathsAr = getDirectories (maxfilepath + "*") recurse: true
	for o in maxPathsAr do append basePaths o

	-- chemin autodesk
	autodeskPaths = getDirectories @"C:\Program Files (x86)\Common Files\Autodesk Shared\Materials\textures\*" recurse: true
	for o in autodeskPaths do append basePaths o
		
	-- collecte des chemins sur le dossier skp
	-- collecte des chemins sur M

	-- ATSOP_paths[1]
	for op in ATSOP_paths do
	-- for i = 2 to ATSOP_paths.count do
	(
		local goodBmpFile = undefined 

		if (doesFileExist  op) then
		(
			goodBmpFile = op
			format "i: % goodBmpFile: %\n" i goodBmpFile
		)	
		-- si le chemin du fichier n'existe pas, tester la pr�sense du fichier sur une liste de dossier
		else if not  (doesFileExist  op) then
		(
			format "not found : %\n" op

			-- test des chemins pour le relink
			for p in basePaths do
			(
				local f = filenameFromPath  op
	-- 			format "p+f: %\n" (p+f)
				local tryName = p + f
				format "	tryName: %\n" tryName
				if doesFileExist tryName then
				(
					ATSOps.SelectFiles op
					ATSOps.SetPathOnSelection p
					format "		reLinked: %\n" tryName
					exit
				)
				else
				(
					format "		not reLinked: %\n" tryName
				)
				
			)
		)
		else
		(
			format "not goodBmpFile: %\n" p
		)	
	)
)
-- visioRelink()
-- textPath = @"W:\Eclisse\Rodez_Rue Beteille_0424\Perspective\Perspective\Textures"

fn visioCollect textPath =
(
	collectMaps = true

	if collectMaps then
	(

		

		
		ATSOps.GetDependentFiles (maxfilepath + maxFileName) false &ATSOP_paths IncludeOutputFiles: false

		for op in ATSOP_paths do
		(
	-- 		format "op: %\n" op
			if doesFileExist op then
			(
				if matchpattern op pattern: "M:*" or matchpattern op pattern: "X:*" or matchpattern op pattern: "W:*" then
				(
					format "ok filename: %\n" op
				)
				else
				(
					format "copy: % to % \n" op (textPath + "\\" + (filenameFromPath op))
					
					res = copyfile op (textPath + "\\" + (filenameFromPath op))
					
					format "res: %\n" res
	/* 				if res then
					(
						format "copy done: % to % \n" op (textPath + (filenameFromPath op))
						ATSOps.SelectFiles op
						ATSOps.SetPathOnSelection textPath	
					) */
					
	-- 				format "(textPath + (filenameFromPath op)): %\n" (textPath + "\\"+(filenameFromPath op))
	-- 				format "doesFileExist (textPath + (filenameFromPath op)): %\n" (doesFileExist (textPath + (filenameFromPath op)))
					if doesFileExist (textPath + "\\"+(filenameFromPath op)) then
					(
						ATSOps.SelectFiles op
						ATSOps.SetPathOnSelection textPath	
					)
				)
			)
			else
			(
				format "file does not exist:%\n" op
			)
		)
	)



)

try(destroydialog visioRelinkRLT)catch()

rollout visioRelinkRLT "Visio Relink and collect"
(
	button relinkBT "try to relink"
	
	group "collect"
	(
		edittext pathET
		button collectBT "collect and relink"
	)
	
	on relinkBT pressed do
	(
		visioRelink()
	)
	
	on collectbt pressed do
	(
		format "path: %\n" pathET.text
		visioCollect pathET.text
	)

)
-- createdialog visioRelinkRLT
