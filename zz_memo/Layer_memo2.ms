Newlayer = layerManager.newlayer ()

newlayer.setname "blabla"

LayerManager.newLayerFromName "blabla"

LayerManager.deleteLayerByName "blabla"

showproperties $

fn FindLayerNameByObjectFN s =
(
	for i = 0 to (LayerManager.count - 1) do
	(
		-- recupere les objets d'un calque dans un array
		pdvLayer = LayerManager.getlayer i
		pdvLayer.nodes &test
			
		for o in test do
		(
			if ( s == o ) then print pdvLayer.Name
		)
	)
)

FindLayerNameByObjectFN $


-- recupere le calque d'un objet


test[1] == test

for i = 0 to layerManager.count-1 do

(

  ilayer = layerManager.getLayer i

  layerName = ilayer.name 

  layer = ILayerManager.getLayerObject i

  layerNodes = refs.dependents layer

  format "Layer: %; nodes: %\n" layerName layerNodes

)

 
ILayerManager.getLayerObject 1

refs.dependents (ILayerManager.getLayerObject 1)