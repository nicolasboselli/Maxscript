/*
((sme.getview 1).GetSelectedNodes())[1].reference

bmpFile = ((sme.getview 1).GetSelectedNodes())[1].reference.filename
vrBmp = VRayBitmap HDRIMapName: bmpfile
replaceinstances ((sme.getview 1).GetSelectedNodes())[1].reference vrBmp

classof ((sme.getview 1).GetSelectedNodes())[1].reference

show smeAr
*/

smeAr = ((sme.getview 1).GetSelectedNodes())

for smeNode in smeAr do
(
	format "smeNode: %\n" (smeNode.reference)
	if iskindof smeNode.reference Bitmaptexture then 
	(
		bmpFile = smeNode.reference.filename
		vrBmp = VRayBitmap HDRIMapName: bmpfile
		test = (sme.getview 1).CreateNode vrBmp [0,0]
		replaceinstances smeNode.reference vrBmp
-- 		replaceinstances smeNode test
	)
)

-- (sme.getview 1).CreateNode (VRayBitmap HDRIMapName: bmpfile) [0,0]