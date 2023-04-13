classof meditmaterials[activeMeditSlot]

autodesk_map_ar = getClassInstances Autodesk_Map
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