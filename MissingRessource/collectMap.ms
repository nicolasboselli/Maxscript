fn copyTextures =
(
	-- collecter tous les chemin de textures
	ATSOps.Refresh() 
	ATSOP_paths_count = ATSOps.NumFiles() 
	ATSOps.GetFiles &ATSOP_paths
	ATSOP_paths

	-- créer le dossier texture
-- 	textDir = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d\Elements_batiments\Maps"
	-- textDir = (maxFilePath + (getFilenameFile maxFileName) + "_TEXTURES")
	-- makeDir textDir
	
	assetPref = @"M:\Biblio\VISIOLAB\2-Assets3D"
	texturePref = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d"

	textDir = (substituteString maxFilePath  assetPref texturePref) + (getFilenameFile maxFileName)
	makeDir textDir

	-- copier toutes les textures dans un nouveau dossier
	for i = 2 to ATSOP_paths.count where (doesFileExist ATSOP_paths[i]) do
	(
		newFile = (textDir + "\\" +(filenameFromPath (ATSOP_paths[i])))
		if not doesFileExist newFile then
		(
			format "copyFile ATSOP_paths[i]: %  newFile: % \n" ATSOP_paths[i]  newFile
			copyFile ATSOP_paths[i]  newFile
		)
		else(format "still exist: %\n" newFile)
		
		-- rediriger les textures
		ATSOps.SelectFiles ATSOP_paths[i]
		ATSOps.SetPathOnSelection textDir
	)
)


ATSOps.Refresh() 
ATSOP_paths_count = ATSOps.NumFiles() 
ATSOps.GetFiles &ATSOP_paths
ATSOP_paths
basePath = @"C:\Users\nicolas\Documents\3ds Max 2024\sceneassets\images"
targetPath = @"X:\Sporting\Concours_Bordeblanche_0623\Perspective\Textures"

for i = 2 to ATSOP_paths.count where (doesFileExist ATSOP_paths[i]) do
(
-- 	format "p: % \nbasepath: %\n" p basepath
	if MatchPattern  ATSOP_paths[i] pattern: (basePath + "*") then
	(
		newFile = (targetPath + "\\" +(filenameFromPath (ATSOP_paths[i])))
		if not doesFileExist newFile then
		(
			newFile = (targetPath + "\\" +(filenameFromPath ( ATSOP_paths[i])))
			format "copyFile ATSOP_paths[i]: %  newFile: % \n" ATSOP_paths[i]  newFile
			copyFile  ATSOP_paths[i]  newFile
		)
		else(format "still exist: %\n" newFile)
		
		ATSOps.SelectFiles ATSOP_paths[i]
		ATSOps.SetPathOnSelection textDir
	)
)