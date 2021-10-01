/*
maj:
	-- recréer un hierachie de calque en fonction d'une hierarchie de parents
	-- conserver un hierrarchie de calque exitants dans une reorganisation de calques par rapport aux parenté

*/


fn initLayers =
(
		if not iskindof (layermanager.getlayerfromname "01_CAM_LIGHT") MixinInterface then layermanager.newlayerfromname "01_CAM_LIGHT"
		if not iskindof (layermanager.getlayerfromname "02_BAT") MixinInterface then layermanager.newlayerfromname "02_BAT"
		if not iskindof (layermanager.getlayerfromname "HAB") MixinInterface then layermanager.newlayerfromname "HAB"
		
		if not iskindof (layermanager.getlayerfromname "OFF") MixinInterface then layermanager.newlayerfromname "OFF"
		daddy = layermanager.getlayerfromname "OFF"
		
		if not iskindof (layermanager.getlayerfromname "CORBEILLE") MixinInterface then layermanager.newlayerfromname "CORBEILLE"
		corbeilleL = layermanager.getlayerfromname "CORBEILLE"
		corbeilleL.setParent daddy
		
		if not iskindof (layermanager.getlayerfromname "plans") MixinInterface then layermanager.newlayerfromname "PLAN"
		planL = layermanager.getlayerfromname "plans"
		planL.setParent daddy		
)

-- l = LayerManager.getLayerFromName  "02_BAT"

-- LayerManager.current.name
fn renameByLayers =
(
	tmp = SceneExplorerManager.GetActiveExplorer()
	sel = tmp.SelectedItems()
	-- for s in sel where iskindof s Base_LayerBase_Layer do 
	l = LayerManager.getLayerFromName sel[1].name

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
	grpAr = #()
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
				o.name = uniquename(l.name + "_FP_")
-- 				format "ignore: %\n" o.name
				-- trouver les quides
			)
			else if isKindof o RailClone_Pro then 
			(
				o.name = uniquename(l.name + "_RC_")
-- 				format "ignore: %\n" o.name
				-- trouver les guides
			)
			else if iskindof o dummy and isgrouphead o then
			(
				format "g.name: %\n" o.name
				append grpAr o
				
			)
			else if isKindof o SplineShape then 
			(
				o.name = uniquename(l.name + "_SP_")
			)		
			else
			(
				o.name = uniquename(l.name + "_MDL_")
			)
		)
	)

	-- traitement des groupes
	for g in grpAr do
	(
		-- renommage des groupes standard	
		if (matchpattern g.name pattern: "Group*") then g.name = uniquename(l.name + "_GRP_")
		
		format "group start:%\n" g.name
		-- collecter les enfants du groupe
		grpChildrenAr = for c in g.children collect c
		for o in grpChildrenAr do
		(
			-- si un groupoe dans les enfants
			for c in o.children do appendifunique grpChildrenAr c
		)
		for s in grpChildrenAr where not iskindof s dummy  and not isgrouphead s do  s.name = uniquename (g.name + "_MDL_" )
		
		-- creation d'un calque pour le groupe
		if not (matchpattern g.layer.name pattern:g.name) then
		(
			local daddy = g.layer
			if not iskindof (layermanager.getlayerfromname g.name) MixinInterface then layermanager.newlayerfromname g.name
			local tpL = layermanager.getlayerfromname g.name
			tpL.setParent daddy
			
			tpL.addnode g
			for c in grpChildrenAr do tpL.addnode c
		)
	)
)
-- renommages des groups et de leurs enfant
-- distinguer les aviz tiles, les forest, les atiles, les fenetres
-- trouver et renommer les guides forest et railclone  


-- classof sel[1]
try(destroydialog layersToolsRLT)catch()
rollout layersToolsRLT "Layers Tools"
(
	
	local subLayersNames = #("dalles","fenetres","gc","murs","terrasses","toit","tuiles")
	
	group "base layers"
	(
		button initLayersBT "init layers"
	)
	
	group "sub layers"
	(
		multilistbox layersNamesMLB "layers names"
		edittext newNameET 
		button addnameBT "add name"
		button createSubLayerBT "create sub layers"
	)
	
	button createOneSbBT "create one sub"
		
	button renameByLayersBT "rename by layers"
	
	fn refreshUI =
	(
		layersNamesMLB.items = subLayersNames
	)
	
	on layersToolsRLT open do
	(
		refreshUI()
	)
	
	on initLayersBT pressed do
	(
		initLayers()
	)
	
	on addnameBT pressed do
	(
		append subLayersNames newNameET.text
		refreshUI()
	)
	
	on createSubLayerBT pressed do
	(
		tmp = SceneExplorerManager.GetActiveExplorer()
		sel = tmp.SelectedItems()
		for s in sel where iskindof s Base_LayerBase_Layer do
		(
			l = LayerManager.getLayerFromName s.name

			for n in subLayersNames do
			(
				if not iskindof (layermanager.getlayerfromname (l.name + "_" + n)) MixinInterface then layermanager.newlayerfromname (l.name + "_" + n)
				local tpL = layermanager.getlayerfromname (l.name + "_" + n)
				tpL.setParent l
			)
		)
	)
	
	on createOneSbBT pressed do
	(
		local sel = (SceneExplorerManager.GetActiveExplorer()).SelectedItems()
		
		local daddy
		for s in sel where iskindof s Base_LayerBase_Layer do 
		(	
			daddy = LayerManager.getLayerFromName s.name
			exit
		)
					
		local newName = uniqueName "new_layer"
		if not iskindof (layermanager.getlayerfromname newName) MixinInterface then layermanager.newlayerfromname newName
		local tpL = layermanager.getlayerfromname newName
		tpL.setParent daddy
		
		for s in sel where not iskindof s Base_LayerBase_Layer do tpL.addnode s 
	)
	
	on renameByLayersBT pressed do
	(
		renameByLayers ()
	)
)
createdialog layersToolsRLT