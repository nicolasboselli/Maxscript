vrayCreateVRayPhysicalCamera()

camsInst = getClassInstances  physical_camera 
cams = for cam in camsInst collect ( (refs.dependents cam) #nomap)
cams

vrcam = vrayCreateVRayPhysicalCamera()
vrcam.transform  =  $.transform