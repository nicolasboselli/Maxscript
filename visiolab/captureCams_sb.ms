

for c in cameras where not (iskindof c Targetobject) do 
(
	format "%\n" c.name
	text text: c.name position: c.position wirecolor: red size: 200 
)

