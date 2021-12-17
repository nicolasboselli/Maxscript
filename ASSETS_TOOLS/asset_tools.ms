-- #### file settings cleaning
-- vray
for l in lights where iskindof l vraysun do delete l
environmentMap = undefined
fileOutGamma = 2.2
IDisplayGamma.colorCorrectionMode = #gamma



-- units
units.DisplayType = #metric
units.MetricType  = #Centimeters 
units.SystemType =  #Centimeters 


-- supprimer les xrefs


-- clean du medit material
for i = 1 to  24 do meditMaterials[i] = VRayMtl ()

-- clean du slate editor

-- clean du batch render
batchCount = batchRenderMgr.numViews
for i = batchCount to 1 by - 1 do batchRenderMgr.DeleteView i

-- clean du render Elements
re = maxOps.GetCurRenderElementMgr ()
re.RemoveAllRenderElements()


setRenderType #view
-- setRenderType #region

getRenderType ()
-- clean render path
rendOutputFilename = ""


-- #### materiaux
-- refs.dependents sceneMaterials["BOITES_AUX_LETTRES_002_VRMLT_3"]
-- tout en vray mat

-- tous les bitmaps en vray bitmap
bmpAr = getClassInstances Bitmaptexture

for oneBmp in bmpAr where doesFileExist oneBmp.filename do
(
	test = VRayHDRI HDRIMapName: oneBmp.filename
	replaceInstances oneBmp test
)

-- tous les BRDF en ggx et roughness
fn convertToGGX =
(
	allVr = getClassInstances vraymtl
	for m in allVr do 
	(
		m.brdf_type = 4
		if m.brdf_useRoughness == false then
		(
			m.reflection_IOR = 1.6
			m.brdf_useRoughness = true
-- 			m.Reflection = color 255 255 255
			m.reflection_glossiness = 1.0 - m.reflection_glossiness
			m.reflection_fresnel = true
		)
	)
)
convertToGGX()

-- ##### collecter toutes les textures dans un fichier adjacent

-- collecter tous les chemin de textures
ATSOps.Refresh() 
ATSOP_paths_count = ATSOps.NumFiles() 
ATSOps.GetFiles &ATSOP_paths
ATSOP_paths

-- créer le dossier texture
textDir = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d\Elements_batiments\Maps"
-- textDir = (maxFilePath + (getFilenameFile maxFileName) + "_TEXTURES")
-- makeDir textDir

-- copier toutes les textures dans un nouveau dossier
for i = 2 to ATSOP_paths.count where (doesFileExist ATSOP_paths[i]) do
(
	newFile = (textDir + "\\" +(filenameFromPath (ATSOP_paths[i])))
	if not doesFileExist newFile then
	(
		copyFile ATSOP_paths[i]  newFile
	)
	else(format "still exist: %\n" newFile)
	
	-- rediriger les textures
	ATSOps.SelectFiles ATSOP_paths[i]
	ATSOps.SetPathOnSelection textDir
)

-- ### geometry
-- reset xform sur les objets
-- placer les objets au centre de la scene (mettre le pivot à [0,0,0])
-- supprimer les objets nuls
--#### RENOMMAGE

assetName = getFilenameFile  maxFileName
-- DaddyL
daddyName = "02_BAT"
if not iskindof (layermanager.getlayerfromname daddyName) MixinInterface then layermanager.newlayerfromname daddyName
daddyL = layermanager.getlayerfromname daddyName

-- creation du calque au nom de l'asset
if not iskindof (layermanager.getlayerfromname assetName) MixinInterface then layermanager.newlayerfromname assetName
assetLayer = layermanager.getlayerfromname assetName

assetLayer.setParent daddyL

for o in objects do assetLayer.addnode o
-- renommage des objets
filein @"N:/Ressources_Nico/github/00_wip/Maxscript/LAYERS_TOOLS/000/layers_tools.ms"
renameByLayers assetLayer


-- renommage des materiaux
k = 1
for m in scenematerials do
(
	m.name = uniqueName (assetName + "_MTL_")
	k += 1
)

-- classof $
multiAr = getClassInstances Multimaterial target: sceneMaterials
for m in multiAr where not MatchPattern m.name pattern: (assetName + "_MULTI*") do
(
	m.name = (assetName + "_MULTI_" + (k as string))
	k += 1
)

vrMatAr = getClassInstances VRayMtl target: sceneMaterials
for m in vrMatAr where not MatchPattern m.name pattern: (assetName + "_VRMLT*") do
(
	m.name = (assetName + "_VRMLT_" + (k as string))
	k += 1
)

-- #### sanity check
-- supprimer les calques vides
-- vérifier que tous les objets suivent la nommenclature du nom du fichier
-- vérifier que tous les bitmaps ont été remplacé par des vray bitmap
-- vérifier que les textures pointent bien vers elements batiments
-- vérifier les noms de materiaux