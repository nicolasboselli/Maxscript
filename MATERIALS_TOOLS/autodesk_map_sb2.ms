autodesk_map_ar = getClassInstances Autodesk_Map

-- autodesk_map_ar[1].Parameters_Source.filename
for am in autodesk_map_ar do
(
	
	vrBmp = VRayBitmap HDRIMapName: am.Parameters_Source.filename
	replaceInstances am vrBmp
	
)

/*
classof meditmaterials[activeMeditSlot]
showproperties autodesk_map_ar[1]
autodesk_map_ar[1].Parameters_Source

for c in cameras do
(
	if iskindof c Targetobject then continue
		
	c.f_number = 11
	c.shutter_speed = 150
	c.iso = 100
)
	

-- classof cameras[1].target
*/