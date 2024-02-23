/*
donner un dossier d'origine
donner un dossier texture d'origine
donner un dossier destination pour les .max

-- ouverture
-- enregistrement du fichier dans le dossier de destination
-- relink des textures
-- copie des textures 
-- mise en place des layers
-- traitement maxtree
-- création du proxy
-- fermeture


*/


-- ouverture
format "################### loading GLOBALS\n"
sourceMaxFolder = @"M:\Archmodels\Maxtree\ARCHIVE_MT_V077\MT_PM_V077_3Dsmax_VRay\MT_PM_V077_3Dsmax_VRay"
sourceMapsFolder = @"M:\Archmodels\Maxtree\ARCHIVE_MT_V077\MT_PM_V077_Maps\MT_PM_V077_Maps"
assetFolder = @"M:\Biblio\VISIOLAB\2-Assets3D\Pers-Films\Objets\Vegetation\Arbres\MT_077"

filesAr = getfiles (sourceMaxFolder + "\\*.max")


daddyName = "HAB" 
daddyCoolName = "BUISSONS"
-- daddyCoolName = "ARBRES"

-- apply values for trees
maxtree = false


-- chargement des fonctions asset_tools.ms
try(DestroyDialog assetToolsRLT)catch()
filein "asset_tools.ms"
DestroyDialog assetToolsRLT


-- maxCount = filesAr.count
startCount = 1
maxCount = 1
-- maxCount = filesAr.count

format "################### GLOBALS loaded\n"

-- for i = 1 to filesAr.count do
for i = startCount to maxCount do
(
	format "%/% traitement started: %\n"  i maxcount filesAr[i]
	resetMaxFile #noPrompt 
	
	res = loadMaxFile filesAr[i] quiet: true
	if res then format "File opened: %\n\n"  filesAr[i] else exit
-- 	format res
	
	-- enregistrement du fichier dans la bibliothèque
-- 	format "loading File\n"
	res2 = saveMaxFile (assetFolder + "\\" + maxFileName) 
	if res2 then format "File saved: %\n\n"  (assetFolder + "\\" + maxFileName)  else exit
	-- maxFilePath 

	-- copie de la miniature si elle existe
	
	
	
	format "Relink textures start\n"
	-- relink des textures
	ATSOps.GetFiles &ATSOP_paths
	ATSOP_paths[1]
	-- ATSOP_paths[1]
	for i = 2 to ATSOP_paths.count do
	(
		
		if  doesFileExist ATSOP_paths[i] then
		(
			format "	ok ATSOP_paths[%]: %\n" i ATSOP_paths[i]
		)
		else
		(
			baseName = filenameFromPath ATSOP_paths[i]
			tryName = sourceMapsFolder + "\\"+  baseName
	-- 		format "tryName: %\n" tryName
			if doesFileExist tryName then
			(
				
				ATSOps.SelectFiles ATSOP_paths[i]
				ATSOps.SetPathOnSelection sourceMapsFolder
				format "	relinked ATSOP_paths[%]: %\n" i tryName
			)
			else
			(
				format "	not found ATSOP_paths[%]: %\n" i ATSOP_paths[i]
			)
		)
	)
	format "Relink textures done\n\n"
		
		
	-- collecte des textures
	format "Collect textures start\n"
	-- collecter tous les chemin de textures
	ATSOps.Refresh() 
	ATSOP_paths_count = ATSOps.NumFiles() 
	ATSOps.GetFiles &ATSOP_paths
	ATSOP_paths

	-- créer le dossier texture
	assetPref = @"M:\Biblio\VISIOLAB\2-Assets3D"
	texturePref = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d"

	-- 	textDir = (substituteString maxFilePath  assetPref texturePref) + (getFilenameFile maxFileName)
	textDir = (substituteString maxFilePath  assetPref texturePref) -- + (getFilenameFile maxFileName)
	makeDir textDir

	-- copier toutes les textures dans un nouveau dossier
	for i = 2 to ATSOP_paths.count where (doesFileExist ATSOP_paths[i]) and not (matchpattern ATSOP_paths[i] pattern: "*.vrmesh") do
	(
		newFile = (textDir + "\\" +(filenameFromPath (ATSOP_paths[i])))
		if not doesFileExist newFile then
		(
			format "	copyFile ATSOP_paths[i]: %  newFile: % \n" ATSOP_paths[i]  newFile
			copyFile ATSOP_paths[i]  newFile
		)
		else(format "	still exist: %\n" newFile)
		
		-- rediriger les textures
		ATSOps.SelectFiles ATSOP_paths[i]
		ATSOps.SetPathOnSelection textDir
	)
	format "Collect textures done\n\n"
	
	
	-- clean du medit material
	format "Clean Material editor\n"
	for i = 1 to  24 do meditMaterials[i] = VRayMtl ()

	-- clean du slate editor
	format "Clean Slate editor\n\n"
	while sme.GetNumViews() > 0 do sme.DeleteView 1 off
	sme.CreateView "View1"	

	-- création du proxy
	format "Create proxy start\n"
	vrmeshRC = for o in geometry where not iskindof o vrayproxy collect o
	format "	Mesh to VrProxies:%\n" vrmeshRC
	local vrayProxies
	
	if vrmeshRC.count > 0 then
	(
		meshFileName = maxFilePath  + (getFilenameFile maxFileName )
		vrayProxies = vrayMeshExport meshFile:meshFileName autoCreateProxies: true exportMultiple: false createMultiMtl: true nodes: vrmeshRC

		vrPoxyMat = materialLibrary  vrayProxies[1].material
		saveTempMaterialLibrary vrPoxyMat (meshFileName + ".vrmesh.mat")
	)


	
	-- check creation proxy
	if doesfileexist  vrayProxies[1].filename then
	(
		format "Create proxy done: %\n\n" vrayProxies[1]
		if maxtree then
		(-- propriété des maxtree
			vrayProxies[1].gbufferchannel = 55
			vrayProxies[1].renderByLayer = true
		)
		else
		(
			vrayProxies[1].renderByLayer = false
		)
	)
	else 
	(		
		format "Create proxy fail!\n\n"
		exit		
	)
	
	-- traitement des matériaux
	format "Convert opacity to clip mode\n\n"
	vrMatAr = getClassInstances VRayMtl 
	for m in vrMatAr do m.option_opacityMode = 1
	
	format "Remove 2sided mat\n"
	-- trouver les VRay2SidedMtl
	sideAr = getClassInstances VRay2SidedMtl 
	for s in sideAr do
	(
		-- trouver le slot du multimaterial où est branché le vray2sided
		deps = refs.dependents s -- immediateOnly: true
		local multiMat


		for d in deps where iskindof d Multimaterial do
		(
			multiMat = d
-- 			format "d:% classof: % \n" d (classof d)
			
			idToReconnect = finditem  multiMat.materialList  s


			-- trouver le slot du vray2sided où est branché le vraymat front
			s.frontMtl

			-- connecter le vraymat dans le slot 2 du multimat
			format "	%[%] = %\n" multiMat.name idToReconnect s.frontMtl.name
		
			multiMat.materialList[idToReconnect] = s.frontMtl
			
		)
	)
	format "Rename 2sided mat done\n\n"
	
	format "Rename layers start\n"
	-- renommage des layers
-- 	renameAsset3 daddyName: "HAB" daddyCoolName: "BUISSONS"
	renameAsset3 daddyName: daddyName daddyCoolName: daddyCoolName
	deleteEmptyLayer()
	format "rename layers done\n\n"

	-- enregistrement
	res = saveMaxFile (assetFolder + "\\" + maxFileName) 
	if res then 
	(
		format "%/% traitement done: %\n\n\n" i maxcount filesAr[i]
	)
	else
	(
		format "%/% traitement fail\n\n\n" i maxcount
		exit
	)

)
resetMaxFile #noPrompt 

format "################### ALL DONE\n"