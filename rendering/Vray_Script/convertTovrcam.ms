selList = selection as array

for c in selList do
(
	if superclassof c == camera do
	(
		vrayCam = vrayCreateVRayPhysicalCamera ()
		
		vrayCam.f_number = 9
		vrayCam.shutter_speed = 150
		
-- 		vrayCam.whiteBalance_preset = 1
-- 		vrayCam.whiteBalance = color 255 255 255
		
		vrayCam.whiteBalance_preset = 2
		vrayCam.whiteBalance = color 191.25 226.023 255
		
		vrayCam.transform = c.transform.controller.value
		vrayCam.fov = c.fov
		
		vrayCam.name = c.name

		c.name = c.name +"_bak"
-- 		VRayPhysicalCamera  transform: transSel
	)
)

-- vrayCam = vrayCreateVRayPhysicalCamera ()
-- vrayCam.transform = $.transform.controller.value



select $VRayCam*