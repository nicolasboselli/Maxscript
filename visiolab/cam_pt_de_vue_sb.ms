fn setVrayCamera =
(
	newCam = vrayCreateVRayPhysicalCamera()
	newCam.transform = ( inverse(getViewTM()) )
	newCam.fov = (getViewFOV())
	newCam.specify_fov = true
	newCam.targeted = true
	move newCam.target [1,0,0]
	move newCam.target [-1,0,0]
-- 	redrawviews ()
-- 	newCam.targeted = true
-- 	redrawviews ()
	newCam.f_number = 11
	newCam.shutter_speed = 150
		
	l = checkLetC()
	l.addnode newCam
	l.addnode newCam.target
		
	newCam

)
-- viewport.SetFOV 50
-- redrawViews()

try(destroydialog pdv_cam_RLT )catch()
rollout pdv_cam_RLT "point de vue companion"
(
	button newcamBT "create new Cam"
	button lockBT "lock/unlock"
	label fovET "fov:" across: 4
	button fov24BT "24"
	button fov30BT "30"
	button fov35BT "35"
	
	button vertCamBT "vertical cam"
	
	on newcamBT pressed do
	(
		tmpCam = setVrayCamera ()
		format "new cam: %\n" tmpCam
		viewport.setCamera tmpCam
		setTransformLockFlags tmpCam #all
		setTransformLockFlags tmpCam.target #all
	)
	
	on lockBT pressed do
	(
		local tmpcam = viewport.getCamera ()
		if tmpcam != undefined then 
		(
			format "lock: %\n"(getTransformLockFlags tmpcam)
			if not (getTransformLockFlags tmpcam)[1] then 
			(
				setTransformLockFlags tmpCam #all
				setTransformLockFlags tmpCam.target #all
-- 				lock = false
			)
			else
			(
				setTransformLockFlags tmpCam #none
				setTransformLockFlags tmpCam.target #none
-- 				lock = true
			)
		)
	)
	
	on fov24BT pressed do
	(
		viewport.SetFOV 74
		redrawViews()
	)

	on fov30BT pressed do
	(
		viewport.SetFOV 62
		redrawViews()
	)

	on fov35BT pressed do
	(
		viewport.SetFOV 54.4
		redrawViews()
	)
	
	on vertCamBT pressed do
	(
		local cam = getActiveCamera()
		if cam != undefined then
		(
			if classof cam == physical then
			(
				cam.auto_vertical_tilt_correction = on
				cam.auto_vertical_tilt_correction = off
			)
			else if iskindof cam VRayPhysicalCamera then
			(
				cam.lens_tilt_auto = on
				redrawviews()
				cam.lens_tilt_auto = off
			)
			else()
		)
		else()
	)
)
CreateDialog pdv_cam_RLT