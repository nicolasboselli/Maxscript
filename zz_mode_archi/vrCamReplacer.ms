/*
convert to vr cam
*/


fn convertToVrCam s =
(
	if classof s == TargetCamera or classof s == FreeCamera then
	(
		vrCam = VRayPhysicalCamera transform: s.transform name: s.name targeted: false specify_fov: true fov: s.fov vignetting: false shutter_speed: 350 
		s.name = s.name + "_bak"
		vrCam.specify_fov = false
	)
)	

/*
delVar = false
sel  = selection as array
for s in sel do convertToVrCam s
if delVar == true do delete sel
*/

for c in cameras where classof c != VRayPhysicalCamera collect  convertToVrCam c

-- showproperties $