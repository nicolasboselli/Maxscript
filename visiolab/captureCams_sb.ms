
lname = "CAMS_NAMES"
if not iskindof (layermanager.getlayerfromname lname) MixinInterface then l = layermanager.newlayerfromname lname
else l = layermanager.getlayerfromname lname



for c in cameras where not (iskindof c Targetobject) do 
(
	format "%\n" c.name
	oneText = text name: c.name text: c.name position: c.position wirecolor: red size: 200 
	l.addnode oneText
)


-- if iskindof (getNodeByName c.name) text then doesTextExists = true
iskindof $.baseobject text

for t in objects  where iskindof t.baseobject text do
(
	
	t.size = 300
)
	

-- $.size = 500