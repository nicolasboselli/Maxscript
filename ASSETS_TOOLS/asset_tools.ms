/*
maj:
x- cr�er fonction remove empty Layer
- assigner les id objets selon post IT
x- dissocier ggx de roughness
x- collecter les textures dans un dossier au nom de l'asset, dans la biblio texture, relink� les mapButton
	x- prendre en charge les vray bitmap
	
/- renommer les nodes en plus des vray mtl

---pour asset forest pack
- outil pour collecter les vrmeshes
x- laisser les sources fp dans un calque
- faire un refresh apr�s un renommage

x- importer un personnage
"M:\Biblio\VISIOLAB\2-Assets3D\Travail_en_cours\Nico\perso_gabarit.max"
*/
fn clusterAttach objArr =
(
	j = 1
	k = 0
	count = objArr.count

	undo off
	(
		while objArr.count > 1 do
		(
			
			
			if classof objArr[j].baseobject != editable_Mesh then converttoMesh objArr[j]
				
			-- DESINSTANCE
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j]) then
			(
-- 				format "desinstance: %\n" objArr[j].name
				InstanceMgr.MakeObjectsUnique objArr[j] #prompt
			)
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j+1]) then
			(
-- 				format "desinstance: %\n" objArr[j+1].name
				InstanceMgr.MakeObjectsUnique objArr[j+1] #prompt
			)
			
			-- ATTACH
			if k == 100 then 
			(
				windows.ProcessPostedMessages()
				format "rest: % objects. numface [j]: % [j+1]: % \n"  objArr.count objArr[j].numfaces objArr[j+1].numfaces
				k = 0
			)
			
			
			attach objArr[j] objArr[j+1]
			
			deleteItem objArr (j+1)

			j += 1
			k += 1

			if (j + 1) > objArr.count then j = 1
		)
	)
	objArr[1]
)

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
	
	-- collecte des calques enfants des calques selectionn�s
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
		
	-- remove missing dll
	filein (getroot() + @"sceneManagement/removeMissingDll.ms")
	
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
	while sme.GetNumViews() > 0 do sme.DeleteView 1 off
	sme.CreateView "View1"

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
	
	vr = renderers.current
	vr.output_splitfilename = ""
	
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
			
-- 				copie des propri�t�s de coordonn�es ignore: #UVTransform, #blur
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

	-- cr�er le dossier texture
-- 	textDir = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d\Elements_batiments\Maps"
	-- textDir = (maxFilePath + (getFilenameFile maxFileName) + "_TEXTURES")
	-- makeDir textDir
	
	assetPref = @"M:\Biblio\VISIOLAB\2-Assets3D"
	texturePref = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d"

	textDir = (substituteString maxFilePath  assetPref texturePref) + (getFilenameFile maxFileName)
	makeDir textDir

	-- copier toutes les textures dans un nouveau dossier
	for i = 2 to ATSOP_paths.count where not (matchpattern ATSOP_paths[i] pattern: "*.vrmesh") do
	(
		if not (doesFileExist ATSOP_paths[i]) then
		(
			format "% : File does not exist: %\n" i ATSOP_paths[i]
		)
		else if matchpattern ATSOP_paths[i] pattern: (texturePref+"*") then
		(	
			format "	% : Already good path: %\n" i ATSOP_paths[i]
		)
		else
		(
-- 			format "% : copy path: %\n" i ATSOP_paths[i]
			
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
)


fn copyVrmeshes = 
(
		-- collecter tous les chemin de textures
	ATSOps.Refresh() 
	ATSOP_paths_count = ATSOps.NumFiles() 
	ATSOps.GetFiles &ATSOP_paths
	ATSOP_paths

	-- cr�er le dossier texture
-- 	textDir = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d\Elements_batiments\Maps"
	-- textDir = (maxFilePath + (getFilenameFile maxFileName) + "_TEXTURES")
	-- makeDir textDir
	
	assetPref = @"M:\Biblio\VISIOLAB\2-Assets3D"
	texturePref = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d"

	textDir = (substituteString maxFilePath  assetPref texturePref) + (getFilenameFile maxFileName)
	makeDir textDir

	-- copier toutes les textures dans un nouveau dossier
	for i = 2 to ATSOP_paths.count where (matchpattern ATSOP_paths[i] pattern: "*.vrmesh") do
	(
		if not (doesFileExist ATSOP_paths[i]) then
		(
			format "% : File does not exist: %\n" i ATSOP_paths[i]
		)
		else if matchpattern ATSOP_paths[i] pattern: (texturePref+"*") or matchpattern ATSOP_paths[i] pattern: (assetPref+"*") then
		(
			format "	% : Already good path: %\n" i ATSOP_paths[i]
		)
		else 
		(
			-- 			format "% : copy path: %\n" i ATSOP_paths[i]
			
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
)	
-- copyVrmeshes()

-- ### geometry
-- reset xform sur les objets
-- placer les objets au centre de la scene (mettre le pivot � [0,0,0])
-- supprimer les objets nuls
--#### RENOMMAGE
fn createLayer layerName =
(
	if not iskindof (layermanager.getlayerfromname layerName) MixinInterface then layermanager.newlayerfromname layerName
	local l = layermanager.getlayerfromname layerName
	l
)	

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
	
	
	multimaterialArray = getClassInstances Multimaterial target: sceneMaterials
	k = 1
	for m in multimaterialArray do
	(
		m.name = (assetName + "_MULTI_" + (k as string))
		k += 1
	)
	
	vrBlendMtlArray = getClassInstances VRayBlendMtl target: sceneMaterials
	k = 1
	for m in vrBlendMtlArray do
	(
		m.name = (assetName + "_VRBLENDMTL_" + (k as string))
		k += 1
	)

	vrMtlArray = getClassInstances VRayMtl target: sceneMaterials
	k = 1
	for m in vrMtlArray do
	(
		m.name = (assetName + "_VRMLT_" + (k as string))
		k += 1
	)
	
	vrBitmapArray = getClassInstances VRayBitmap target: sceneMaterials
	k = 1
	for m in vrBitmapArray do
	(
		m.name = (assetName + "_VRBMP_" + (k as string))
		k += 1
	)
	
	bitmapTextureArray = getClassInstances Bitmaptexture target: sceneMaterials
	k = 1
	for m in bitmapTextureArray do
	(
		m.name = (assetName + "_BMPTXT_" + (k as string))
		k += 1
	)
	
	colorCorrectionArray = getClassInstances Color_Correction target: sceneMaterials
	k = 1
	for m in colorCorrectionArray do
	(
		m.name = (assetName + "_COLCOR_" + (k as string))
		k += 1
	)
	
	outputArray = getClassInstances output target: sceneMaterials
	k = 1
	for m in outputArray do
	(
		m.name = (assetName + "_OUTPUT_" + (k as string))
		k += 1
	)
	
	vrNormalMapArray = getClassInstances VRayNormalMap target: sceneMaterials
	k = 1
	for m in vrNormalMapArray do
	(
		m.name = (assetName + "_VRNORMALMAP_" + (k as string))
		k += 1
	)
	
	mixArray = getClassInstances Mix target: sceneMaterials
	k = 1
	for m in mixArray do
	(
		m.name = (assetName + "_MIX_" + (k as string))
		k += 1
	)
	
	vrColorArray = getClassInstances VrayColor target: sceneMaterials
	k = 1
	for m in vrColorArray do
	(
		m.name = (assetName + "_VRCOLOR_" + (k as string))
		k += 1
	)
	
	fallOffArray = getClassInstances Falloff target: sceneMaterials
	k = 1
	for m in fallOffArray do
	(
		m.name = (assetName + "_FALLOFF_" + (k as string))
		k += 1
	)
	
	vrDirtArray = getClassInstances VRayDirt target: sceneMaterials
	k = 1
	for m in vrDirtArray do
	(
		m.name = (assetName + "_VRDIRT_" + (k as string))
		k += 1
	)
	
	cellularArray = getClassInstances Cellular target: sceneMaterials
	k = 1
	for m in cellularArray do
	(
		m.name = (assetName + "_CELLULARS_" + (k as string))
		k += 1
	)
	
	compositeArray = getClassInstances CompositeTexturemap target: sceneMaterials
	k = 1
	for m in compositeArray do
	(
		m.name = (assetName + "_COMPOSITE_" + (k as string))
		k += 1
	)
	
	vrCompTexArray = getClassInstances VRayCompTex target: sceneMaterials
	k = 1
	for m in vrCompTexArray do
	(
		m.name = (assetName + "_COMPTEX_" + (k as string))
		k += 1
	)
	
	vrEdgesTex = getClassInstances VRayEdgesTex target: sceneMaterials
	k = 1
	for m in vrEdgesTex do
	(
		m.name = (assetName + "_VREDGESTEX_" + (k as string))
		k += 1
	)
	
	gradientRamp = getClassInstances Gradient_Ramp target: sceneMaterials
	k = 1
	for m in gradientRamp do
	(
		m.name = (assetName + "_GRADIENTRAMP_" + (k as string))
		k += 1
	)
	
	gradients = getClassInstances Gradient target: sceneMaterials
	k = 1
	for m in gradients do
	(
		m.name = (assetName + "_GRADIENT_" + (k as string))
		k += 1
	)
	
	vr2SidedMtl = getClassInstances VRay2SidedMtl target: sceneMaterials
	k = 1
	for m in vr2SidedMtl do
	(
		m.name = (assetName + "_VR2SIDEDMTL_" + (k as string))
		k += 1
	)
	
	vrLightMtl = getClassInstances VRayLightMtl target: sceneMaterials
	k = 1
	for m in vrLightMtl do
	(
		m.name = (assetName + "_VRLIGHTMTL_" + (k as string))
		k += 1
	)
	
	noises = getClassInstances Noise target: sceneMaterials
	k = 1
	for m in noises do
	(
		m.name = (assetName + "_NOISE_" + (k as string))
		k += 1
	)
	
	vrFastSSS2 = getClassInstances VRayFastSSS2 target: sceneMaterials
	k = 1
	for m in vrFastSSS2 do
	(
		m.name = (assetName + "_VRFASTSSS2_" + (k as string))
		k += 1
	)
	
	vrTriplanarTex = getClassInstances VRayTriplanarTex target: sceneMaterials
	k = 1
	for m in vrTriplanarTex do
	(
		m.name = (assetName + "_VRTRIPLANARTEX_" + (k as string))
		k += 1
	)

	vrCarPaintMtl = getClassInstances VRayCarPaintMtl target: sceneMaterials
	k = 1
	for m in vrCarPaintMtl do
	(
		m.name = (assetName + "_VRCARPAINTMTL_" + (k as string))
		k += 1
	)
	
	vertexColor = getClassInstances Vertex_Color target: sceneMaterials
	k = 1
	for m in vertexColor do
	(
		m.name = (assetName + "_VERTEXCOLOR_" + (k as string))
		k += 1
	)
	
	vrUVWRandomizer = getClassInstances VrayUVWRandomizer target: sceneMaterials
	k = 1
	for m in vrUVWRandomizer do
	(
		m.name = (assetName + "_VRUVWRANDOMIZER_" + (k as string))
		k += 1
	)
	
	-- multiSubObjects = getClassInstances Multi_Sub_Object target: sceneMaterials
	-- k = 1
	-- for m in multiSubObjects do
	-- (
	-- 	m.name = (assetName + "_MULTISUBOBJECT_" + (k as string))
	-- 	k += 1
	-- )
	
)

try(destroydialog assetToolsRLT)catch()
rollout assetToolsRLT "asset tools"
(
	local coreTextDir =  @"M:\Biblio\VISIOLAB\1-Textures\Assets3d\Pers-Films"
	
	group "pre saved functions:"
	(
		button cleanFileBT "clean file"
		button importPeopleBT "import people"
		
		button delModBT "del modifiers" enabled: false
		button resetXformBT "resetXform" enabled: false
		button scale1BT "scale1" enabled: false
		button pivotToOriginBT "pivot to zero"
	)
	button saveTmpBT "open saver"
	
	group "post saved functions:"
	(
		button convertToVrBmpBT "convert to vrBmp"
		button convertToGGXBT "convert to GGX"	
		
		button renameMatBT "rename mat"
		button copyTextBT "copy textures"
	)
	
	group "rename asset:"
	(
		button renameAssetBT "for \"02_bat\""
		button renameAssetBT2 "for \"03_masse\""
		button renameAssetBT3 "for \"HAB\""
		button renameAssetBT4 "for Forest Pack id 45"
	)
	
	group "proxy:"
	(
		button createProxyBT "create proxy" tooltip: "cr�e le proxy avec le mat, � la fa�on du project manager, sans les erreurs d'idMat"
		button createProxy2BT "create proxy v2" tooltip: "� utiliser quand le bouton au dessus a mal focntionn�"
	)
		
	group "MaxTree:"
	(
		button MaxTreeBT "Go MaxTrees!" tooltip: "1 - cr�ation de la hi�rarchie:\nHAB \n   > ARBRES\n     > [nom du fichier]\n     > objects renomm�s\n
2 - tous les objets de la sc�ne sont d�plac�s dans le calque.
\n3 - Tous les objets sont pass�s en render properties bay layer et id de gbuffer 55"  enabled: false
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
	
	on pivotToOriginBT pressed do
	(
		sel = selection as array
		for s in sel where isGroupHead s do s.pivot = point3 0 0 0
	)
	
	
	on saveTmpBT pressed do
	(
		filein "asset_saver.ms"
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
		renameAsset daddyName: "03_MASSE" daddyCoolName: "00_VOIRIE"
		deleteEmptyLayer()
		try(destroy layersToolsRLT)catch()
	)
	
		
	on renameAssetBT3 pressed do
	(
		renameAsset2 daddyName: "HAB" 
		deleteEmptyLayer()
		try(destroy layersToolsRLT)catch()
	)
	
	on renameAssetBT4 pressed do
	(	

		objID = 45
		-- cr�ation du layer de l'asset
		daddyL = createLayer "HAB"
		assetLayer = createLayer ((getFilenameFile  maxFileName) + "_id" + (objID as string))
		assetLayer.setParent daddyL
		
		for o in objects do assetLayer.addnode o
		
		-- cr�ation du layer des template de forest
		zLayer = createLayer "Z_OFF"
		fpLayer =  createLayer "Forest_Template"
		fpLayer.setParent zLayer
		
		for o in geometry where iskindof o Forest_Pro do
		(
			-- application de l'id object 45
			o.gbufferchannel = objID
			
			fpNodesListNames = o.conamelist
			fpNodesList = #()

			for n in fpNodesListNames do
			(
				nodeRC = getnodebyname n
-- 				format "nodeRC: %\n" nodeRC
				if isValidNode nodeRC then 
				(
					fpLayer.addnode nodeRC
					
					-- freeze du forest template 
					nodeRC.isFrozen = true
					
					-- rename des vrproxies par rapport au nom de l'asset
					testName = (matchPattern  nodeRC.name pattern: (o.name + "*"))
-- 					format "nodeRC.name: % res: %\n" nodeRC.name testName
					if not testName then nodeRC.name = o.name + "_" + nodeRC.name
					
				)
			) 
		)

		-- vray id 45 sur les materiaux
		
		deleteEmptyLayer()
		try(destroy layersToolsRLT)catch()
		
	)
	
	on renameMatBT pressed do
	(
		renameMat ()
	)
	
	on createProxyBT pressed do
	(
		sel = selection as Array
		maxOps.CloneNodes sel cloneType: #copy  newNodes: &copySel
		select copySel
		 
		meshFileName = maxFilePath  + (getFilenameFile maxFileName )
		vrayProxies = vrayMeshExport meshFile:meshFileName autoCreateProxies: true exportMultiple: false createMultiMtl: true condenseMultiMtl: true

		vrPoxyMat = materialLibrary  vrayProxies[1].material
		saveTempMaterialLibrary vrPoxyMat (meshFileName + ".vrmesh.mat")

		select vrayProxies
	)
	
	on createProxy2BT pressed do
	(
		sel = selection as Array
		maxOps.CloneNodes sel cloneType: #copy  newNodes: &copySel
		-- select copySel

		explodeGroup copySel
		copySel = for s in copySel where isValidNode s collect s
		meshToproxy = clusterAttach copySel

		meshToproxy.pivot = point3 0 0 0
		ResetXForm meshToProxy
		converttopoly meshToProxy

		meshFileName = maxFilePath  + (getFilenameFile maxFileName )
		vrayProxies = vrayMeshExport nodes: meshToProxy  meshFile:meshFileName autoCreateProxies: true -- exportMultiple: false -- createMultiMtl: true condenseMultiMtl: true

		vrPoxyMat = materialLibrary  meshToProxy.material
		saveTempMaterialLibrary vrPoxyMat (meshFileName + ".vrmesh.mat")

		select meshToProxy
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
-- v�rifier que tous les objets suivent la nommenclature du nom du fichier
-- v�rifier que tous les bitmaps ont �t� remplac� par des vray bitmap
-- v�rifier que les textures pointent bien vers elements batiments
-- v�rifier les noms de materiaux