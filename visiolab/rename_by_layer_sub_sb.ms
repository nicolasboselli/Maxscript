subLayersNames = #("dalles","fenetres","gc","murs","terrasses","toit")

-- 
tmp = SceneExplorerManager.GetActiveExplorer()
sel = tmp.SelectedItems()
l = LayerManager.getLayerFromName sel[1].name

-- 
for n in subLayersNames do
(
	if not iskindof (layermanager.getlayerfromname (l.name + "_" + n)) MixinInterface then layermanager.newlayerfromname (l.name + "_" + n)
	local tpL = layermanager.getlayerfromname (l.name + "_" + n)
	tpL.setParent l
)