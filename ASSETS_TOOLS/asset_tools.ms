/*
maj:
- créer fonction remove empty Layer
- assigner les id objets selon post IT
- outil pour assigner des couleur de RAL sur le picker ouvert/sur la diffuse du material selectionné

- outil pour conformer les fenetres: reset xform, position pivot, tag windows template, group orienter en x pour object replacer
*/


fn deleteEmptyLayer = 
(
	
(
	_defaultlayer = layerManager.getLayer 0
	_defaultlayer.current = true

	try
	(	
		_total_layers = layerManager.count - 1
		_layercount = #()
		_layercount = for i = 1 to _total_layers collect i
		_revlayers = #()
		for i in _layercount.count to 1 by -1 do append _revlayers _layercount[i]

		for j in _revlayers do
		(
			_getlayer = layerManager.getlayer j
			LayerManager.deleteLayerByName _getlayer.name
		)		
	)
	catch()
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
			if isKindof o AvizstudioToolsATiles then 
			(
				o.name = uniquename(l.name + "_Aviz_")
-- 				format "ignore: %\n" o.name
			)
			else if isKindof o point then
			(
				if (matchpattern o.name pattern: "Point*") then o.name = uniquename(l.name + "_PT_")
			)
			else if isKindof o Forest_Pro then
			(
				if not matchpattern o.name pattern: (l.name + "_FP_*") then o.name = uniquename(l.name + "_FP_")
				append fpAr o
			)
			else if isKindof o RailClone_Pro then 
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
	for l in lights where iskindof l vraysun do delete l
	environmentMap = undefined
	backgroundColor = color 0 0 0
	fileOutGamma = 2.2
	IDisplayGamma.colorCorrectionMode = #gamma

	-- units
	units.DisplayType = #metric
	units.MetricType  = #Centimeters 
	units.SystemType =  #Centimeters 
	units.SystemScale = 1.0

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
		test = VRayHDRI HDRIMapName: oneBmp.filename
		replaceInstances oneBmp test
	)
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

-- ##### collecter toutes les textures dans un fichier adjacent
fn copyTextures =
(
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
)

-- ### geometry
-- reset xform sur les objets
-- placer les objets au centre de la scene (mettre le pivot à [0,0,0])
-- supprimer les objets nuls
--#### RENOMMAGE
fn renameAsset =
(
	local layersToolsRLT
	assetName = getFilenameFile  maxFileName
	-- DaddyL
	daddyName = "02_BAT"
	if not iskindof (layermanager.getlayerfromname daddyName) MixinInterface then layermanager.newlayerfromname daddyName
	daddyL = layermanager.getlayerfromname daddyName

	-- daddy cool
	dassyCoolName = "00_ELTS_BAT"
	if not iskindof (layermanager.getlayerfromname dassyCoolName) MixinInterface then layermanager.newlayerfromname dassyCoolName
	daddyCool = layermanager.getlayerfromname dassyCoolName

	-- creation du calque au nom de l'asset
	if not iskindof (layermanager.getlayerfromname assetName) MixinInterface then layermanager.newlayerfromname assetName
	assetLayer = layermanager.getlayerfromname assetName

	assetLayer.setParent daddyCool
	daddyCool.setParent daddyL

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
)

try(destroydialog assetToolsRLT)catch()
rollout assetToolsRLT "asset tools"
(
	button cleanFileBT "clean file"
	
	button convertToVrBmpBT "convert to vrBmp"
	button convertToGGXBT "convert to GGX"
	button copyTextBT "copy textures"
	
	button renameAssetBT "rename asset"
	button renameMatBT "rename mat"
	
	on cleanFileBT pressed do
	(
		cleanFile()
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
		try(destroy layersToolsRLT)catch()
	)
	
	on renameMatBT pressed do
	(
		renameMat ()
	)
)
createDialog assetToolsRLT


-- #### sanity check
-- supprimer les calques vides
-- vérifier que tous les objets suivent la nommenclature du nom du fichier
-- vérifier que tous les bitmaps ont été remplacé par des vray bitmap
-- vérifier que les textures pointent bien vers elements batiments
-- vérifier les noms de materiaux