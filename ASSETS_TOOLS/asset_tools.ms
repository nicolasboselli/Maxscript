/*
maj:
x- créer fonction remove empty Layer
- assigner les id objets selon post IT
x- dissocier ggx de roughness
x- collecter les textures dans un dossier au nom de l'asset, dans la biblio texture, relinké les mapButton
	x- prendre en charge les vray bitmap
	
/- renommer les nodes en plus des vray mtl
  
- outil pour assigner des couleur de RAL sur le picker ouvert/sur la diffuse du material selectionné

- outil pour conformer les fenetres: reset xform, position pivot, tag windows template, group orienter en x pour object replacer

x- importer un personnage
"M:\Biblio\VISIOLAB\2-Assets3D\Travail_en_cours\Nico\perso_gabarit.max"
*/


fn deleteEmptyLayer = 
(
	

	_total_layers = layerManager.count - 1

	for i = _total_layers  to 0 by -1 do
	(
		l = layerManager.getLayer i
		l.nodes &test
	-- 	format "objects: %\n" test
-- 		format "i: % l: % getNumNodes: % getNumChildren: %\n" i l.name (l.getNumNodes()) (l.getNumChildren())
		if l.getNumNodes() == 0 and l.getNumChildren() == 0 then 
		(
-- 			format "delete: %\n" l.name
			LayerManager.deleteLayerByName l.name
		)
	)
)	
-- deleteEmptyLayer()

	

fn renameAssetByLayer l =
(
	/*
	tmp = SceneExplorerManager.GetActiveExplorer()
	tmpSel = tmp.SelectedItems()
	sel = for s in tmpSel where iskindof s Base_LayerBase_Layer collect s 
	l = LayerManager.getLayerFromName sel[1].name
	*/
	
	-- collecte des calques enfants des calques selectionnés
	j = 0
	lAr = #(l)
	for l in lAr do
	(
		for i = 1 to (l.getNumChildren ()) do
		(
			l2 = l.getChild i
			format "layer: %\n" l2.name
			append lAr l2
		)
		-- 
		j+=1
		if j > 500 then exit
	)
	lAr.count

	-- renommage des objets des layer par calques
	local grpAr = #()
	local rcAr = #()
	local fpAr = #()
	
	for l in lAr do
	(
		l.nodes &tmpNodes
		for o in tmpNodes do
		(
			if isKindof o.baseobject AvizstudioToolsATiles then 
			(
				o.name = uniquename(l.name + "_Aviz_")
-- 				format "ignore: %\n" o.name
			)
			else if isKindof o point then
			(
				if (matchpattern o.name pattern: "Point*") then o.name = uniquename(l.name + "_PT_")
			)
			else if isKindof o.baseobject Forest_Pro then
			(
				if not matchpattern o.name pattern: (l.name + "_FP_*") then o.name = uniquename(l.name + "_FP_")
				append fpAr o
			)
			else if isKindof o.baseobject RailClone_Pro then 
			(
				if not matchpattern o.name pattern: (l.name + "_RC_*") then o.name = uniquename(l.name + "_RC_")
				append rcAr o
			)
			else if iskindof o dummy and isgrouphead o then
			(
				format "o.name: %\n" o.name
				
				if not matchpattern o.name pattern: (l.name + "_GRP_*") then o.name = uniquename(l.name + "_GRP_")
				
/* 				local res
				try(res = (getUserProp o "windowsTemplate")as booleanClass)catch(res = false)
				if res then append grpAr o */
								
			)
			else if isKindof o SplineShape then 
			(
-- 				o.name = uniquename(l.name + "_SP_")
				if not matchpattern o.name pattern: (l.name + "_SP_*") then o.name = uniquename(l.name + "_SP_")
			)
			else if isKindOf o VrayProxy then
			(
				if not matchpattern o.name pattern: (l.name + "_VRM_*") then o.name = uniquename(l.name + "_VRM_")
			)
			else
			(
				if not matchpattern o.name pattern: (l.name + "_MDL_*") then o.name = uniquename(l.name + "_MDL_")
			)
		)
	)

-- 	traitement pour les railclones
	for rc in rcAr do
	(
		for g in rc.banode do
		(
			if not isvalidnode g then continue
			if isKindOf g.baseobject editable_poly then continue
			g.name = uniquename(rc.name + "_guide_")
			rc.layer.addnode g
		)
	)
	
	-- traitement des forest pack
	for fp in fpAr do
	(
		for g in fp.distpathnodes do
		(
			if isKindOf g.baseobject editable_poly then continue
			g.name = uniquename(fp.name + "_guide_")
			fp.layer.addnode g
		)
	)
)

-- #### file settings cleaning
-- vray

fn cleanFile =
(
	-- delete sun
	for l in lights where iskindof l vraysun do delete l
	environmentMap = undefined
	backgroundColor = color 0 0 0
	fileOutGamma = 2.2
	IDisplayGamma.colorCorrectionMode = #gamma

	-- units
	format "Configure Units done.\n"
	units.DisplayType = #metric
	units.MetricType  = #Centimeters 
	units.SystemType =  #Centimeters 
	units.SystemScale = 1.0

	-- supprimer les xrefs

	-- clean du medit material
	format "Clean Material editor.\n"
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
)


-- #### materiaux
-- refs.dependents sceneMaterials["BOITES_AUX_LETTRES_002_VRMLT_3"]
-- tout en vray mat
fn convertToVrBitmap =
(
	-- tous les bitmaps en vray bitmap
	bmpAr = getClassInstances Bitmaptexture

	for oneBmp in bmpAr where doesFileExist oneBmp.filename do
	(
		vrBmp = VRayBitmap HDRIMapName: oneBmp.filename
		
		propNamesAr = #( #mapping , #mapChannel, #mappingType, #UVW_Type, #U_Mirror, 
			#V_Mirror, #U_Tile, #V_Tile, #showMapOnBack, #Noise_On, 
			#Noise_Animate, #realWorldScale, #realWorldHeight, 
			#realWorldWidth, #phase, #U_Offset, #V_Offset, #U_Tiling, #V_Tiling, 
			#W_angle, #V_Angle, #U_Angle, #Blur_Offset, 
			#Noise_Amount, #Noise_Size, #Noise_Levels)
			
-- 				copie des propriétés de coordonnées ignore: #UVTransform, #blur
-- 				propNamesAr = getPropNames smeNode.reference.coords
		for p in propNamesAr do 
		(
-- 			format "p: % vrBmp.coords p: % smeNode.reference.coords p: %\n" p (getProperty vrBmp.coords p)  (getProperty oneBmp.coords p)
			setProperty vrBmp.coords p (getProperty oneBmp.coords p)
		)
		
		
		replaceInstances oneBmp vrBmp
	)
)

-- tous les BRDF en ggx et roughness
fn convertToGGX =
(
	allVr = getClassInstances vraymtl
	for m in allVr do 
	(
		m.brdf_type = 4
/* 		if m.brdf_useRoughness == false then
		(
			m.reflection_IOR = 1.6
			m.brdf_useRoughness = true
-- 			m.Reflection = color 255 255 255
			m.reflection_glossiness = 1.0 - m.reflection_glossiness
			m.reflection_fresnel = true
		) */
	)
)

-- ##### collecter toutes les textures dans un fichier adjacent
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

-- ### geometry
-- reset xform sur les objets
-- placer les objets au centre de la scene (mettre le pivot à [0,0,0])
-- supprimer les objets nuls
--#### RENOMMAGE
fn renameAsset daddyName: "02_BAT" daddyCoolName: "00_ELTS_BAT" renameByLayer: true =
(
	local layersToolsRLT
	assetName = getFilenameFile  maxFileName
	-- DaddyL
-- 	daddyName = "02_BAT"
	if not iskindof (layermanager.getlayerfromname daddyName) MixinInterface then layermanager.newlayerfromname daddyName
	daddyL = layermanager.getlayerfromname daddyName

	-- daddy cool
-- 	dassyCoolName = "00_ELTS_BAT"
	if not iskindof (layermanager.getlayerfromname daddyCoolName) MixinInterface then layermanager.newlayerfromname daddyCoolName
	daddyCool = layermanager.getlayerfromname daddyCoolName

	-- creation du calque au nom de l'asset
	if not iskindof (layermanager.getlayerfromname assetName) MixinInterface then layermanager.newlayerfromname assetName
	assetLayer = layermanager.getlayerfromname assetName

	assetLayer.setParent daddyCool
	daddyCool.setParent daddyL

	for o in objects do assetLayer.addnode o
	-- renommage des objets
-- 	filein @"N:/Ressources_Nico/github/00_wip/Maxscript/LAYERS_TOOLS/000/layers_tools.ms"
	if renameByLayer then renameAssetByLayer assetLayer
-- 	try(destroy layersToolsRLT)catch()
)

fn renameAsset3 daddyName: "02_BAT" daddyCoolName: "00_ELTS_BAT" renameByLayer: true =
(
	local layersToolsRLT
	assetName = getFilenameFile  maxFileName
	-- DaddyL
-- 	daddyName = "02_BAT"
	if not iskindof (layermanager.getlayerfromname daddyName) MixinInterface then layermanager.newlayerfromname daddyName
	daddyL = layermanager.getlayerfromname daddyName

	-- daddy cool
-- 	dassyCoolName = "00_ELTS_BAT"
	if not iskindof (layermanager.getlayerfromname daddyCoolName) MixinInterface then layermanager.newlayerfromname daddyCoolName
	daddyCool = layermanager.getlayerfromname daddyCoolName

	-- creation du calque au nom de l'asset
/* 	if not iskindof (layermanager.getlayerfromname assetName) MixinInterface then layermanager.newlayerfromname assetName
	assetLayer = layermanager.getlayerfromname assetName */

-- 	assetLayer.setParent daddyCool
	daddyCool.setParent daddyL

	for o in objects do daddyCool.addnode o
	-- renommage des objets
-- 	filein @"N:/Ressources_Nico/github/00_wip/Maxscript/LAYERS_TOOLS/000/layers_tools.ms"
-- 	if renameByLayer then renameAssetByLayer assetLayer
-- 	try(destroy layersToolsRLT)catch()
)



fn renameAsset2 daddyName: "02_BAT"  =
(
	local layersToolsRLT
	assetName = getFilenameFile  maxFileName
	-- DaddyL
-- 	daddyName = "02_BAT"
	if not iskindof (layermanager.getlayerfromname daddyName) MixinInterface then layermanager.newlayerfromname daddyName
	daddyL = layermanager.getlayerfromname daddyName

	-- daddy cool
-- 	dassyCoolName = "00_ELTS_BAT"
-- 	if not iskindof (layermanager.getlayerfromname dassyCoolName) MixinInterface then layermanager.newlayerfromname dassyCoolName
-- 	daddyCool = layermanager.getlayerfromname dassyCoolName

	-- creation du calque au nom de l'asset
	if not iskindof (layermanager.getlayerfromname assetName) MixinInterface then layermanager.newlayerfromname assetName
	assetLayer = layermanager.getlayerfromname assetName

-- 	assetLayer.setParent daddyCool
	assetLayer.setParent daddyL

	for o in objects do assetLayer.addnode o
	-- renommage des objets
-- 	filein @"N:/Ressources_Nico/github/00_wip/Maxscript/LAYERS_TOOLS/000/layers_tools.ms"
	renameAssetByLayer assetLayer
-- 	try(destroy layersToolsRLT)catch()
)

-- renommage des materiaux
fn renameMat =
(
	assetName = getFilenameFile  maxFileName
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
	
	vrBmpAr = getClassInstances VRayBitmap target: sceneMaterials
	for m in vrBmpAr where not MatchPattern m.name pattern: (assetName + "_VRBMP*") do
	(
		m.name = (assetName + "_VRBMP_" + (k as string))
		k += 1
	)
	
	bmpAr = getClassInstances Bitmaptexture target: sceneMaterials
	for m in bmpAr where not MatchPattern m.name pattern: (assetName + "_BMPTXT*") do
	(
		m.name = (assetName + "_BMPTXT_" + (k as string))
		k += 1
	)
	
	colCorAr = getClassInstances Color_Correction target: sceneMaterials
	for m in colCorAr where not MatchPattern m.name pattern: (assetName + "_COLCOR*") do
	(
		m.name = (assetName + "_COLCOR_" + (k as string))
		k += 1
	)
	
	outPutAr = getClassInstances output target: sceneMaterials
	for m in outPutAr where not MatchPattern m.name pattern: (assetName + "_OUTPUT*") do
	(
		m.name = (assetName + "_OUTPUT_" + (k as string))
		k += 1
	)
	
	vrNmAr = getClassInstances VRayNormalMap target: sceneMaterials
	for m in vrNmAr where not MatchPattern m.name pattern: (assetName + "_VRNORM*") do
	(
		m.name = (assetName + "_VRNORM_" + (k as string))
		k += 1
	)
	
	MixAr = getClassInstances Mix target: sceneMaterials
	for m in MixAr where not MatchPattern m.name pattern: (assetName + "_MIX*") do
	(
		m.name = (assetName + "_MIX_" + (k as string))
		k += 1
	)
	
	VrColAr = getClassInstances VrayColor target: sceneMaterials
	for m in VrColAr where not MatchPattern m.name pattern: (assetName + "_VRCOL*") do
	(
		m.name = (assetName + "_VRCOL_" + (k as string))
		k += 1
	)
	
)

try(destroydialog assetToolsRLT)catch()
rollout assetToolsRLT "asset tools"
(
	button cleanFileBT "clean file"
	
	button importPeopleBT "import people"
	
	button convertToVrBmpBT "convert to vrBmp"
	button convertToGGXBT "convert to GGX"
	
	button saveTmpBT "save TMP file"
	
	button renameMatBT "rename mat"
	button copyTextBT "copy textures"
	
	group "rename asset:"
	(
		button renameAssetBT "for \"02_bat\""
		button renameAssetBT2 "for \"03_masse\""
		button renameAssetBT3 "for \"HAB\""
	)
		
	group "MaxTree:"
	(
		button MaxTreeBT "Go MaxTrees!" tooltip: "1 - création de la hiérarchie:\nHAB \n   > ARBRES\n     > [nom du fichier]\n     > objects renommés\n
2 - tous les objets de la scène sont déplacés dans le calque.
\n3 - Tous les objets sont passés en render properties bay layer et id de gbuffer 55"  
	)
	
	on cleanFileBT pressed do
	(
		cleanFile()
		deleteEmptyLayer()
	)
	
	on importPeopleBT pressed do
	(
		mergeMaxFile @"M:\Biblio\VISIOLAB\2-Assets3D\Travail_en_cours\Nico\perso_gabarit.max"
	)
	
	on saveTmpBT pressed do
	(
		local tmpMaxFile = @"M:\Biblio\VISIOLAB\2-Assets3D\Travail_en_cours\Nico\3d_sky\" + "TMP_" + maxFileName 
-- 		maxFileName
-- 		maxFilePath 
 		local res = saveMaxFile tmpMaxFile
		if res then
		(
			format "save as done: %\n" tmpMaxFile
		)
		else
		(
			format "save as failed: %\n" tmpMaxFile
		)
		
	)
	
	on convertToVrBmpBT pressed do
	(
		convertToVrBitmap()
	)
	
	on convertToGGXBT pressed do
	(
		convertToGGX()
	)
	
	on copyTextBT pressed do
	(
		copyTextures ()
	)
	
	on renameAssetBT pressed do
	(
		renameAsset ()
		deleteEmptyLayer()
		try(destroy layersToolsRLT)catch()
	)
	
	
	on renameAssetBT2 pressed do
	(
		renameAsset daddyName: "03_MASSE" dassyCoolName: "00_VOIRIE"
		deleteEmptyLayer()
		try(destroy layersToolsRLT)catch()
	)
	
		
	on renameAssetBT3 pressed do
	(
		renameAsset2 daddyName: "HAB" 
		deleteEmptyLayer()
		try(destroy layersToolsRLT)catch()
	)
	
	on renameMatBT pressed do
	(
		renameMat ()
	)
	
	on MaxTreeBT pressed do
	(
		renameAsset3 daddyName: "HAB" daddyCoolName: "ARBRES"
		deleteEmptyLayer()
		
		for o in geometry do 
		(
			o.gbufferchannel = 55
			o.renderByLayer = true
		)
	)
)
createDialog assetToolsRLT





-- #### sanity check
-- supprimer les calques vides
-- vérifier que tous les objets suivent la nommenclature du nom du fichier
-- vérifier que tous les bitmaps ont été remplacé par des vray bitmap
-- vérifier que les textures pointent bien vers elements batiments
-- vérifier les noms de materiaux