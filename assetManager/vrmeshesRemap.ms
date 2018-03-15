-- maj:
	-- make multi selection on list
	-- display only out of date assets
		-- make two array
	-- switch

filein "assetManagerDef.ms"
-- vraymeshes remapper

fn sortbyname v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( v1.name < v2.name) then
		d=-1
	else
		d=1
	
--compare les numeros entre eux et les classe	
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)


fn collectVrmeshesInScene =
(
	sel = geometry as array
	vrmeshes = for o in sel where classof o == vrayproxy collect o
	vrmeshes	
)

try(destroyDialog vrmeshesRemapRLT)catch()

rollout vrmeshesRemapRLT "asset update tools"
(
	
-- 	vars
	local allAssetsFolder 
	local root 
	
	local vrMeshesAr = #()
	local assetAr = #()
	local assetClassAr = #()
	local assetClassArToShow = #()
	
-- 	ui
	/*
	edittext allAssetsFolderET "all assets folder:" text: allAssetsFolder readonly: true
	edittext rootET "root:" text: root readonly: true
	button collectAssetBT "collect assets"
	*/
	
	group "vray proxies:"
	(
		button sortListBT "sort by name"
		multiListBox vrmeshesLB "vrmeshes paths:"
		button delVrMeshBT "delete selection"
	)
	

	-- ui fonctions relatives
	
-- 	actions
	
	on vrmeshesRemapRLT open do
	(
		-- vrmeshes collect
		vrMeshesAr = collectVrmeshesInScene()
		vrmeshesLB.items = for o in vrMeshesAr collect o.filename
		
	)
	
	on sortListBT pressed do
	(
		qsort vrMeshesAr sortbyname
		vrmeshesLB.items = for o in vrMeshesAr collect o.filename
	)
	
	on vrmeshesLB selectionEnd do
	(
		vrIdAr = vrmeshesLB.selection as array
		clearselection()
		for id in vrIdAr do selectmore vrMeshesAr[id]
	)		
	
	on delVrMeshBT pressed do
	(
		sel = selection as array
		delete sel 
		vrMeshesAr = collectVrmeshesInScene()
		vrmeshesLB.items = for o in vrMeshesAr collect o.filename
	)

)

createdialog vrmeshesRemapRLT width: 800