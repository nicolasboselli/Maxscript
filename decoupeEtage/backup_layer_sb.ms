
sel = selection as array
for s in sel do 
(
	l = s.layer
	newLayerName =  l.name + "[sliced]"
	newL = LayerManager.getLayerFromName newLayerName
	if newL == undefined then 
	(
		newL = LayerManager.newLayerFromName newLayerName
		newL.setparent l
	)
	newL.addnode s
)
