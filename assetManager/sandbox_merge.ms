fn mergeAsset2 fileStr mergeAsAsset: true ignoreVrSet: false ignoreCacheLay: false =
(
	if mergeAsAsset then assetCtrl = point name: (uniquename "assetCtrl") size: 200
	
	-- collect import names
	objStrArTmp = getMAXFileObjectNames fileStr
	
	objStrAr = #()
	for str in objStrArTmp do
	(
		if getnodebyname str != undefined then
		(
			uniquename str 
			appendifunique
		)
		else str
	)
	format "obj to import: %\n" objStrAr
	

	--import
	res = mergeMAXFile fileStr  #useSceneMtlDups #AutoRenameDups  -- #AutoRenameDups  -- #mergeDups -- #select
	print res
	
-- 	sel = selection as array
	
	for str in objStrAr do
	(
		o = getnodebyname str
		deletion = false
		
		-- suppresion des elemets vray
		if ignoreVrSet and classof o == vraysun or classof o == vrayplane or  classof o == targetcamera then deletion = true
			
		-- suppression des elements caches
		belongToCachLay = matchpattern o.layer.name pattern: "*cache_layer*"	
		if ignoreCacheLay and belongToCachLay then deletion = true
		
		-- parenter au ctrl asset
		else if mergeAsAsset and  o.parent == undefined and not isGroupMember o then o.parent = assetCtrl
		
		
		format "obj: %, deletion:% \n" o.name deletion
		
		if deletion == true then delete o
	)
)

fn mergeAsset3 fileStr mergeAsAsset: true ignoreVrSet: false ignoreCacheLay: false =
(
	if mergeAsAsset then assetCtrl = point name: (uniquename "assetCtrl") size: 200
	
	local objsCountBef = objects.count
	--import
	mergeMAXFile fileStr  #useSceneMtlDups #AutoRenameDups  -- #AutoRenameDups  -- #mergeDups -- #select
	
--	collect objects import
	objsImpAr = #()
	if objects.count > objsCountBef do
	(
		objsImpAr = for i = (objsCountBef + 1) to objects.count collect objects[i]
	)
	
	for o in objsImpAr do
	(
		if not isValidNode o do continue
			
-- 		o = getnodebyname str
		deletion = false
		
		-- suppresion des elemets vray
		local belongToVrSet = false
		if classof o == vraysun or classof o == vrayplane or  classof o == targetcamera then belongToVrSet = true
		if ignoreVrSet and belongToVrSet  then deletion = true

		-- suppression des elements caches
		belongToCachLay = matchpattern o.layer.name pattern: "*cache_layer*"	
		if ignoreCacheLay and belongToCachLay then deletion = true
		
		-- parenter au ctrl asset
		else if mergeAsAsset and  o.parent == undefined and not isGroupMember o then o.parent = assetCtrl
		
		
		format "obj: %, deletion:% \n" o.name deletion
		
		if deletion == true then delete o
	)
)

-- fileStr = @"J:\_svn\zz_ressources3D\ELEMENTS_IMMOBILIERS\fenetre_double\001\fenetre_double.max"
fileStr = @"J:\_svn\zz_ressources3D\PLANTES\AM_106_001\001\AM_106_001.max"
mergeAsset3 fileStr mergeAsAsset: true ignoreVrSet: true ignoreCacheLay: true



-- objsIWant = "select $Sphere001"
f = @"C:\test01.max"
getMAXFileObjectNames f
mergeMAXFile f #select

assetCtrl = undefined
lastVersionFile = @"J:\_svn\zz_ressources3D\ELEMENTS_IMMOBILIERS\fenetre_porte_double\003\fenetre_porte_double.max"

n =  getFilenameFile  lastVersionFile


assetCtrl = point name: (uniquename( n + "_ctrl")) size: 200

objStrAr = getMAXFileObjectNames lastVersionFile
res = mergeMAXFile lastVersionFile  #useSceneMtlDups	

LM = layermanager
assetsLayer = LM.getLayerFromName "assets_layer"
if assetsLayer == undefined do assetsLayer = LM.newLayerFromName "assets_layer"

for str in objStrAr do
(
	o = getnodebyname str
	deletion = false
	
	if classof o == vraysun or classof o == vrayplane or  classof o == targetcamera then deletion = true
	else if o.layer.name == "cache_layer" then deletion = true
		
	if deletion == true then delete o
	else
	(
		if  o.parent == undefined then 	o.parent = assetCtrl
	)
)

