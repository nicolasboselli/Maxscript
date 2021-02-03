try(destroydialog selectCellLayerRLT)catch()
rollout selectCellLayerRLT "select cell layer"
(
	local layerList 
	local layerListDisplay 
	local layerListName 
	
	dropdownlist  sourceLayerCB "layer source:" -- height: 20 -- across: 2
	
	fn init =
	(	
		-- collecte des layers
		layerList = for i = 0 to (LayerManager.count - 1) collect (LayerManager.getLayer i)
		layerListDisplay = for l in layerList where matchpattern l.name pattern: "Cells*" collect l
		layerListName = for l in layerListDisplay collect l.name
	)
	
	fn refreshUI =
	(
		sourceLayerCB.items = layerListName
	)
	
	on selectCellLayerRLT open do
	(
		init()
		refreshUI()
	)
)
createdialog selectCellLayerRLT