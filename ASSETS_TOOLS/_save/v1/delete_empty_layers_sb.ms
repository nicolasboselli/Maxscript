_total_layers = layerManager.count - 1

for i = _total_layers  to 0 by -1 do
(
	l = layerManager.getLayer i
	l.nodes &test
-- 	format "objects: %\n" test
	format "i: % l: % getNumNodes: % getNumChildren: %\n" i l.name (l.getNumNodes()) (l.getNumChildren())
	if l.getNumNodes() == 0 and l.getNumChildren() == 0 then 
	(
		format "delete: %\n" l.name
		LayerManager.deleteLayerByName l.name
	)
)


-- l.getNumNodes()

                      