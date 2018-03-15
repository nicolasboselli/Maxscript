vr=renderers.current
showproperties vr

-- OverRider maquette
-- creation du material
sceneMaterials ["over_maquette"] = VRayMtl ()

OverVitreMat = sceneMaterials ["over_maquette"]
OverVitreMat.diffuse = color 230 230 230  
OverVitreMat.texmap_diffuse = VRayDirt ()
OverVitreMat.texmap_diffuse.radius = 50
OverVitreMat.texmap_diffuse.occluded_color = color 96 177 207 

-- vars
MatMaqDirt = VRayDirt radius: 50 occluded_color: (color 96 177 207)
OverMatMaquette = VRayMtl name: "over_maquette" diffuse:  (color 230 230 230 ) texmap_diffuse: MatMaqDirt

AtmosVRtoon =  VrayToon widthtype: 1 color: (color 106 149 174)	opacity: 0.8 lineworld: 1

-- application du materiau
vr.options_overrideMtl_on = true
vr.options_overrideMtl_mtl = OverVitreMat

-- desapplication du materiau
vr.options_overrideMtl_on = false
vr.options_overrideMtl_mtl = undefined

-- application du vray toon
addAtmospheric  AtmosVRtoon
setActive AtmosVRtoon true

-- desapplication du vray toon
setActive AtmosVRtoon false
deleteAtmospheric 1

	


