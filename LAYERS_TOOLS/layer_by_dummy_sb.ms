helpers as array

for h in (helpers as array) where iskindof h Dummy do 
(
	layerChildren = h.children 
-- 	format "%\n" layerChildren
	
	if not iskindof (layermanager.getlayerfromname h.name) MixinInterface then layermanager.newlayerfromname h.name
	l = layermanager.getlayerfromname h.name
	
	for c in h.children do l.addnode c
)
