/*
maj:
- créé les cem name sur selection de cameras
- créé un bouton pour selectionner les cams names
- mettre un interface pour changer la couleur des noms

*/


try(DestroyDialog captureCamRLT)catch()
rollout captureCamRLT "capture cam"
(
	local camNames = #()
	local lname = "CAMS_NAMES"
	local l
	
	button createCamNameTextBT "create cams names"
	spinner resizeSP "text size" range: [200, 10000, 200]
	button grabViewportBT "grab viewport"
	button cleanBT "clean"
	
	
	fn collectCamNames =
	(
		if not iskindof (layermanager.getlayerfromname lname) MixinInterface then l = layermanager.newlayerfromname lname
		else l = layermanager.getlayerfromname lname

		l.nodes &camNames
	)
	
	on createCamNameTextBT pressed do
	(
		collectCamNames()
		delete camNames

		for c in cameras where not (iskindof c Targetobject) do 
		(
			
			format "%\n" c.name
			oneText = text name: ("text_" + c.name) text: c.name position: (point3 c.position.x c.position.y 5000) wirecolor: white size: 200 
			addModifier oneText (edit_poly ())
			l.addnode oneText
		)
		
		l.nodes &camNames
	)
	
	on resizeSP changed val do
	(
		collectCamNames()
		for cn in camNames where isvalidNode cn do cn.size = val
	)
	
	on grabViewportBT pressed do
	(
		clearselection()
		redrawViews()
		display (gw.getViewportDib())
	)
	
	on cleanBT pressed do
	(
		collectCamNames()
		delete camNames
		LayerManager.deleteLayerByName lname
	)
)
CreateDialog captureCamRLT


/* 
-- if iskindof (getNodeByName c.name) text then doesTextExists = true
-- iskindof $.baseobject text

for t in objects  where iskindof t.baseobject text do
(
	t.size = 500
)

-- resize
l.nodes &camNames
for cn in camNames do cn.size = 500
	 */