s= $


fn createLayer s = 
(
	Lname = s.name + "_fenetre_detach"
	-- Lname = "toto"
	daddyL = s.layer

	-- daddyName
	if not iskindof (layermanager.getlayerfromname Lname) MixinInterface then layermanager.newlayerfromname Lname
	L = layermanager.getlayerfromname Lname

	L.setParent daddyL
	L.current = true
	L.on = true
)
