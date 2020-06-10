LayerManager.count
repLayer = LayerManager.getLayerFromName "rep"
childNum = repLayer.getNumChildren()
for i = 1 to childNum do
(
-- 	format "%\n" (repLayer.getChild i).name
	Ltmp = repLayer.getChild i
	Ltmp.nodes &repsTmp
	format "%\n" repsTmp
	append repAr repsTmp
)