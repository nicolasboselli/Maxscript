-- clean layer

-- maj: baser la recherche du basename sur l'assetNode

-- get basename
 
matchpattern maxFileName pattern: "*_*_*"
splitBasename = filterString maxFileName "_"

splitBasename[1] == "P"

basename = splitBasename[1] + "_" + splitBasename[2]

-- tester les calques et créer les calques necessaire
if LayerManager.getLayerFromName basename == undefined then LayerManager.newLayerFromName basename
	
rigLayer = splitBasename[1] + "_" + splitBasename[2] + "_RIG"
mdlLayer = splitBasename[1] + "_" + splitBasename[2] + "_MDL"
ctrlLayer = splitBasename[1] + "_" + splitBasename[2] + "_CTRL"

if LayerManager.getLayerFromName rigLayer == undefined then LayerManager.newLayerFromName rigLayer else format "OK\n"
if LayerManager.getLayerFromName mdlLayer == undefined then LayerManager.newLayerFromName mdlLayer else format "OK\n"
if LayerManager.getLayerFromName ctrlLayer == undefined then LayerManager.newLayerFromName ctrlLayer else format "OK\n"


-- collecter les object dans la scene et placer les objects sur les calques appropriés
RL = LayerManager.getLayerFromName rigLayer
for o in objects where matchpattern o.name pattern: "*_RIG" do RL.addnode o
for o in objects where matchpattern o.name pattern: "*_AssetNode" do RL.addnode o


ML = LayerManager.getLayerFromName mdlLayer
for o in objects where matchpattern o.name pattern: "*_MDL" do ML.addnode o

CL = LayerManager.getLayerFromName ctrlLayer
for o in objects where matchpattern o.name pattern: "*_CTRL" do CL.addnode o
for o in objects where matchpattern o.name pattern: "*_ROOT" do CL.addnode o

