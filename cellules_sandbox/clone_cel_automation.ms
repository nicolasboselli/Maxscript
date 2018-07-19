-- dupliquer structure de calque
-- dupliquer les objets en renommant les variantes
(
	--//SUFFIX TO ADD TO NEW LAYERS
	suffix = "_LP"
	
	--//FUNCTION TO GET OR CREATE A LAYER FROM A NAME
	fn getOrCreateLayerFromName layerName =
	(
		newLayer = layermanager.getLayerFromName layerName
		
		if newLayer == undefined do
		(
			newLayer = layermanager.newLayerFromName layerName
		)
		
		newLayer
	)
	
	--//GET THE CURRENT SELECTION
	selObjs = getCurrentSelection()
	
	--//CLONE THE NODES
	maxOps.cloneNodes selObjs cloneType:#copy actualNodeList:selObjs newNodes:&newObjs
	
	--//ITERATE THE SELECTION TO ORGANIZE THE NEW NODES INTO NEW LAYERS
	for o = 1 to selObjs.count do
	(
		--//CREATE THE LAYER IF NEEDED
		oldLayer = selObjs[o].layer
		
		newLayer = getOrCreateLayerFromName (oldLayer.name + suffix)
		
		--//ADD THE CLONED OBJECT TO THE NEW LAYER
		newLayer.addNode newObjs[o]
		
		--//CHECK THE PARENT OF THE OLD LAYER
		pLayer = oldLayer.getParent()
		
		if pLayer != undefined do
		(
			newParent = getOrCreateLayerFromName (pLayer.name + suffix)
			newLayer.setParent newParent
		)
	)
	
	select newObjs
)