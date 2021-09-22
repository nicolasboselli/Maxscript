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
		
		if not iskindof (layermanager.getlayerfromname "PLAN") MixinInterface then layermanager.newlayerfromname "PLAN"
		planL = layermanager.getlayerfromname "PLAN"
		planL.setParent daddy		
)

/*
try(destroydialog  initLayersRLT)catch()
rollout initLayersRLT "init layers"
(
	local daddy
	
	button initLayersBT "Init" across: 2
	button destroyLayersBT "Destroy"
	
	on initLayersBT pressed do
	(
		initLayers()
	)
	
	on destroyLayersBT pressed do
	(
		-- destroy all dialog
		for i = layermanager.count - 1 to 1 by -1 do
		(
			l = layermanager.getlayer i
			layermanager.deleteLayerByName l.name 
		)
	)
)
createdialog initLayersRLT
*/