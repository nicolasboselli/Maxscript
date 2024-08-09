fn convertAllAutodeskMapToVrBmp =
(
	autoDeskMapAr = getClassInstances Autodesk_Map
	for m in  autoDeskMapAr do
	(
		try
		(
		bmpFile = m.Parameters_Source.filename
		vrBmp = VRayBitmap HDRIMapName: bmpfile
		
		replaceinstances m vrBmp
		)
		catch(format "FAIL: %\n" m.Parameters_Source)
		

	)
)
convertAllAutodeskMapToVrBmp()