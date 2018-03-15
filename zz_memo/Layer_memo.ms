-- layermanager.count

-- layermanager.current

-- TestLayer = layermanager.getLayer 1

-- TestLayer.name



rollout LayerPlus "layerPlus"
(
	local layerList = #()
	local Layer2Hide = #()
	
	group "All Layer"
	(
	listbox AllLayerLB "Layer List" items: layerList
	button refreshLayerBT "refresh"
	)
	
	group "Layer to hide"
	(
	button AddLayerBT "add layer"
	button DelLayerBT "del layer"
	listbox Layer2HideLB "Layer2Hide" items: Layer2Hide
	checkbutton test "test"
	)
	
	on refreshLayerBT pressed do
	(
		for i = 0 to (layermanager.count - 1) do
		(
			TestLayer = layermanager.getLayer i
			append layerList (TestLayer.name)
			AllLayerLB.items = makeUniqueArray layerList
		)
	)
	
	on AddLayerBT pressed do
	(
		append Layer2Hide layerList[AllLayerLB.selection]
		Layer2HideLB.items = makeUniqueArray Layer2Hide
	)
	
	on DelLayerBT pressed do
	(
		deleteItem Layer2Hide Layer2HideLB.selection
		Layer2HideLB.items = makeUniqueArray Layer2Hide
	)
	
	on test changed state do
		if state == on then 
		(
			print "toto"
		)
		else 
		(
			print "tata"
		)
)

createdialog LayerPlus

