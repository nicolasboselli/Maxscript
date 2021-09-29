subLayersNames = #("dalles","fenetres","gc","murs","terrasses","toit","tuiles")

-- 
tmp = SceneExplorerManager.GetActiveExplorer()
sel = tmp.SelectedItems()
for s in sel where iskindof s Base_LayerBase_Layer do
(
	l = LayerManager.getLayerFromName s.name

	for n in subLayersNames do
	(
		if not iskindof (layermanager.getlayerfromname (l.name + "_" + n)) MixinInterface then layermanager.newlayerfromname (l.name + "_" + n)
		local tpL = layermanager.getlayerfromname (l.name + "_" + n)
		tpL.setParent l
	)
)
-- classof sel[1]