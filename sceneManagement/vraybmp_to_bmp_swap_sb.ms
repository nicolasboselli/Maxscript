((sme.getview 1).GetSelectedNodes())[1].reference

bmpFile = ((sme.getview 1).GetSelectedNodes())[1].reference.filename
vrBmp = VRayBitmap HDRIMapName: bmpfile
replaceinstances ((sme.getview 1).GetSelectedNodes())[1].reference vrBmp

classof ((sme.getview 1).GetSelectedNodes())[1].reference

show smeAr

smeAr = ((sme.getview 1).GetSelectedNodes())
for smeNode in smeAr do
(
	if iskindof smeNode.reference Bitmaptexture then 
	(
		format "m:%\n" (smeNode.reference)
	)
)

