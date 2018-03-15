filein "assetManagerDef.ms"

/*
maj create thumbnail:
	x-- check if there are in an asset folder
	-- add version on thumbnail
	-- clean wip folder
	
	-- remove map from texture unwrapper
*/

/*
sceneMaps = usedMaps()
for b in sceneMaps do print b
sceneMaps.count
retest = makeuniquearray sceneMaps
retest.count

objs = objects as array

allBmps = #()
for o in objs do
(
-- 	print (classof o)
	if o.material != undefined then
	(
		maps =usedmaps o
		for m in maps do
		(
			if findString m "S:" == 1 do print o
-- 			print m
			appendifunique allBmps m
		)
	)
)
allBmps.count

mBitmaps = getClassInstances BitmapTexture target: scenematerials
mBitmaps.count

-- f = @"S:\Groupe Carrere\2015\Visite Oculus_0315\Appartement_Crealys\Modelisation\Textures\KnittedFabric_displace.jpg"
-- findString f "S:" 

select (getnodebyname "Chaise Jardin 006")

maps =usedmaps $
for m in maps do print m


for m in sceneMaps do
(	
	index = findItem allBmps m
	if index >0 then 
	(
		print ("used map : " + m)
	)
	 else
	(	
-- 		result=1
		print ("garbage map : " + m)
-- 			replaceInstances m  tmpTex
		
	)

)
*/
-- enumerateFiles ()

fn RemoveGhostTex=
(	
	result=0
	fn allUsedMaps =
	
	(
	
		sceneMaps = usedMaps()
		
		for m in meditmaterials do join sceneMaps (usedMaps m)
		
		sceneMaps
	
	)
	
	
	local allUsedMaps = allUsedMaps ()
	
	mBitmaps = getClassInstances BitmapTexture
	
				
	tmpTex = createInstance BitmapTexture
	
	for m in mBitmaps do
	(	
		index = findItem allUsedMaps m.fileName
		if index >0 then 
		(
			print ("used map : " + m.fileName)
		)
		 else
		(	
			result=1
			print ("garbage map : " + m.fileName)
-- 			replaceInstances m  tmpTex
			
		)
	
	)
	 
 
result
)

-- test = @"S:\Groupe Carrere\2015\Visite Oculus_0315\Appartement_Crealys\Modelisation\Textures\mpm_vol.06_p20_03_Wallpaper_06_diff.JPG"


-- hjRemoveGhostTex()
-- sceneMaps = usedMaps()
-- print sceneMaps
-- collect vrmeshes
fn collectOneVrMesh o =
(
	res = false 
	
	assetFolder = getUpperFolder maxFilePath
	vrmeshesFolder = assetfolder + "vrmeshes"
	
	dir = getDirectories vrmeshesFolder
	if dir.count == 0 then res = makedir vrmeshesFolder
		
	vrmeshFile = o.filename
	vrmeshName = getFilenameFile vrmeshFile
	
	newFile = vrmeshesFolder + "\\" + vrmeshName + ".vrmesh"
	
	-- test if file already exist
	fileExist = doesfileexist newFile
	
	-- copy file if it doesn't exists
	if fileExist == false then 
	(
		res = copyfile vrmeshFile newFile
	)
	else res = true
	
	-- remap file
	if res == true then
	(
		o.filename = newFile
	)
)


fn collectOneVrMesh2 o vrmeshesFolder =
(
	res = false 
	
-- 	assetFolder = getUpperFolder maxFilePath
-- 	vrmeshesFolder = assetfolder + "vrmeshes"
	
	dir = getDirectories vrmeshesFolder
	if dir.count == 0 then res = makedir vrmeshesFolder
		
	vrmeshFile = o.filename
	vrmeshName = getFilenameFile vrmeshFile
	
	newFile = vrmeshesFolder + "\\" + vrmeshName + ".vrmesh"
	
	-- test if file already exist
	fileExist = doesfileexist newFile
	
	-- copy file if it doesn't exists
	if fileExist == false then 
	(
		res = copyfile vrmeshFile newFile
	)
	else res = true
	
	-- remap file
	if res == true then
	(
		o.filename = newFile
	)
)

-- sel = geometry as array
-- vrProxies = for o in geometry where classof o == vrayproxy collect o
-- vrPath = @"T:\Promologis\0917_Casselardit\Perspectives\Textures\vrmeshes"
-- for vr in vrProxies do collectOneVrMesh2 vr vrPath


fn checkAssetFolder =
(
	assetFolder = getUpperFolder maxFilePath
	test = doesfileexist (assetFolder + "assetInfo.ini")
	test2 = doesfileexist (maxFilePath + "assetInfo.ini")
	if test or test2 then true else false
)

fn createVrMeshesFolder =
(
	vrmeshesFolder = undefined
	vrmeshesFolderExist = False
	
	vrmeshesFolderTmp = ((getupperfolder maxFilePath) + "vrmeshes")
	print vrmeshesFolderTmp
	res = getDirectories vrmeshesFolderTmp
	if res.count == 0 then 
	(
		vrmeshesFolderExist = makedir vrmeshesFolderTmp
		if vrmeshesFolderExist == true do	vrmeshesFolder = vrmeshesFolderTmp
	)
	else vrmeshesFolder = vrmeshesFolderTmp

	vrmeshesFolder
)


fn createTexturesFolder =
(
	texturesFolder = undefined
	texturesFolderExist = False
	
	texturesFolderTmp = ((getupperfolder maxFilePath) + "textures")
	format "texturesFolderTmp: %\n" texturesFolderTmp
	
	res = getDirectories texturesFolderTmp
	if res.count == 0 then 
	(
		texturesFolderExist = makedir texturesFolderTmp
		if texturesFolderExist == true do texturesFolder = texturesFolderTmp
	)
	else texturesFolder = texturesFolderTmp

	texturesFolder
)

-- create vrmeshes
-- collect map
fn createTexturesFolder2 =
(
	local texturesFolderTmp
	
	if doesfileexist (maxFilePath + "assetInfo.ini") then texturesFolderTmp =  maxFilePath + "textures"
	else if doesfileexist ((getupperfolder maxFilePath) + "assetInfo.ini") then texturesFolderTmp =  ((getupperfolder maxFilePath) + "textures")
	else()

	if not doesfileexist texturesFolderTmp then makedir texturesFolderTmp
		
	texturesFolderTmp
)
-- createTexturesFolder2()


fn copyTextures textFolder =
(
	
	-- apply on scene material
-- 	bitmapAr = getClassInstances  bitmaptex   processAllAnimatables:true
	bitmapAr = getClassInstances  bitmaptex   target: scenematerials

	for t in bitmapAr where t.filename !=  undefined do
	(
		if doesfileexist  t.filename == true then
		(
			f = t.filename 
			newFile = textFolder + "\\"+  (filenameFromPath f)
-- 			print (format "old: %\t\tnew:%\n" f newFile)
			
			if doesfileexist newFile == true then
			(
				t.filename = newFile
				if t.filename != newFile then print t
			)
			else 
			(
				res = copyfile f newFile
-- 				print res
				if res == true then t.filename = newFile
			)
		)
	)
)

-- create topnode


-- create thumbnail
fn createThumb =
(
	outPath =  ((getUpperFolder maxFilePath) + "assetThumb.jpg") 
	bmpTmp = bitmap 256 256 gamma: 0.2 filename: outPath
	render vfb: on to: bmpTmp 
	
	save bmpTmp
	close bmpTmp
		
	outPath =  ((getUpperFolder maxFilePath) + "assetPreviz.jpg") 
	bmpTmp = bitmap 1024 1024 gamma: 0.42 filename: outPath
	render vfb: on to: bmpTmp 

	save bmpTmp
	close bmpTmp
)


fn createOneVrmesh s folder =
(
	vrmeshFile = folder + "\\" +s.name
	vrayMeshExport meshFile: vrmeshFile  maxPreviewFaces:2000 exportMultiple: true autoCreateProxies: true exportPointClouds: false
)

fn patchMultimatName =
(
	local multiAr = getclassinstances multimaterial target: scenematerials
	
	local basename = (filterString maxfilename ".")[1]
	
	for m in multiAr do
	(
		if not matchpattern m.name pattern: (basename + "_*") then 
		(
			
			format "m.name: %\n" m.name
			m.name = basename + "_" + m.name
		)
	)
)
-- patchMultimatName()

fn deleteEmptyLayers =
(
	local num = LayerManager.count
	for i = 1 to (num - 1) do
	(
		l = LayerManager.getLayer i
		format "l.name: %, l.count: %\n" l.name (l.getNumNodes())
		if (l.getNumNodes()) == 0 then
		(
			
		)
	)
)
-- deleteEmptyLayers()

-- l = LayerManager.current 
-- LayerManager.doesLayerHierarchyContainNodes l.name
-- l.name


-- rollout
try(destroyDialog assetsToolsRLT)catch()
rollout assetsToolsRLT "asset tools"
(
	button collectVrayMeshesBT "collect vraymeshes" enabled: false
	button createVrayMeshesBT "create vrmeshes from selection" enabled: false
	
	button collectTexturesBT "collect textures" enabled: false
	button createThumbBT "create thumbnail" enabled: false
	
	on assetsToolsRLT open do
	(
		if checkAssetFolder() == true then
		(
			collectVrayMeshesBT.enabled = true
			createVrayMeshesBT.enabled = true
			collectTexturesBT.enabled = true
			createThumbBT.enabled = true
		)
		else
		(
			print "you are not in an asset folder"
		)
	)
	
	on collectVrayMeshesBT pressed do
	(
		sel = geometry as array
		local vrProxies = for o in sel where classof o == vrayproxy collect o
			
		local assetFolder = maxFilePath
		local vrmeshesFolder = assetfolder + "vrmeshes"
		
		for vr in vrProxies do collectOneVrMesh2 vr  vrmeshesFolder
		
-- 		vrmeshes	
-- 		vrProxies = for o in geometry where classof o == vrayproxy collect o
-- 		for vr in vrProxies do collectOneVrMesh vr
	)	
	
	on createVrayMeshesBT pressed do 
	(
		sel = selection as array
		vrmeshFolder = createVrMeshesFolder()
-- 		print vrmeshFolder
		if vrmeshFolder != undefined then
		(
			for s in sel do createOneVrmesh s vrmeshFolder
		)
	)
	
	on collectTexturesBT pressed do
	(
		textFolder = createTexturesFolder2 ()
		if textFolder != undefined then 
		(
			print "starting copy"
			copyTextures textFolder
		)
	)
	
	on createThumbBT pressed do createThumb()
)
createdialog assetsToolsRLT


