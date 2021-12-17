	/*
	if classof mat == Standard then
	(
		vrMat = VRayMtl diffuse: mat.diffuse name: mat.name texmap_diffuse: mat.diffuseMap texmap_opacity: mat.opacityMap
		converted = true
		
	)
	*/
vrMatAr = getclassinstances VRayMtl
for vr in vrMatAr do
(
	std = standard diffuse: vr.diffuse name: vr.name diffuseMap: vr.texmap_diffuse opacityMap: vr.texmap_opacity
	replaceInstances vr std
)
