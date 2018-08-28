-- camTM =  getViewTM() 
-- camFov = getViewFOV() 
-- inverse(camTM)
-- $cam001.transform

fn setVrayCamera =
(
	newCam = vrayCreateVRayPhysicalCamera()
	newCam.transform = ( inverse(getViewTM()) )
	newCam.fov = (getViewFOV())
	newCam.specify_fov = true
	newCam.targeted = false
		
	viewport.setCamera newCam
)
setVrayCamera ()

