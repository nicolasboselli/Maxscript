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
sourceMaxFolder = @"M:\Biblio\VISIOLAB\2-Assets3D\Elements_batiments\Ouvrants\Fenetres"
-- sourceMapsFolder = @"M:\Archmodels\Maxtree\MT_V063\MT_PM_V063_Maps\MT_PM_V063_Maps"
-- assetFolder = @"M:\Biblio\VISIOLAB\2-Assets3D\Pers-Films\Objets\Vegetation\Massifs_Buissons\MT_063"

filesAr = getfiles (sourceMaxFolder + "\\F_*.max")

-- chargement des fonctions asset_tools.ms
-- try(DestroyDialog assetToolsRLT)catch()
-- filein "asset_tools.ms"
-- DestroyDialog assetToolsRLT


maxCount = filesAr.count
-- maxCount = 3

-- for i = 1 to filesAr.count do
for i = 1 to maxCount do
(
	format "#### traitement started: %\n" filesAr[i]
	resetMaxFile #noPrompt 
	
	res = loadMaxFile filesAr[i] quiet: true
	if res then format "file opened: %\n"  filesAr[i] else exit

	try
	(
	sceneMaterials["vitrage"].refraction_affectAlpha = 1
	sceneMaterials["vitrage"].reflection_glossiness = 1
	sceneMaterials["vitrage"].reflection_IOR = 1.8
	sceneMaterials["vitrage"].brdf_useRoughness = off
	sceneMaterials["vitrage"].brdf_type = 4
	sceneMaterials["vitrage"].refraction_ior = 1.53
	sceneMaterials["vitrage"].selfIllumination_gi = off
	sceneMaterials["vitrage"].option_cutOff = 0.001
	)catch(format "	vitrage fail: %\n" filesAr[i] )
	
	-- enregistrement
	res = saveMaxFile filesAr[i]
	if res then 
	(
		format "#### %/% traitement done: %\n\n\n" i maxcount filesAr[i]
	)
	else
	(
		format "#### %/% traitement fail\n\n\n" i maxcount
		exit
	)

)
resetMaxFile #noPrompt 

format "################### ALL DONE\n"