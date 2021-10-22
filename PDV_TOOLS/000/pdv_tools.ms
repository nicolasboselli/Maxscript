

fn convertSceneStateToCameras =
(
	num = sceneStateMgr.GetCount()   

	statesAr = for i = 1 to num collect sceneStateMgr.GetSceneState i

	for st in statesAr do
	(
		local cam = getActiveCamera()
		if isvalidnode cam then
		(
			sceneStateMgr.RestoreAllParts st
			maxOps.cloneNodes #(cam) cloneType: #copy newNodes:&copyCam
			copyCam[1].name = st
		-- 	format "cam: % st: %\n" cam st
		)
	)
)

fn sortbyname a b =
(
	if a.name > b.name then 1
	else if a.name < b.name then -1
	else 0
)


fn checkLetC =
(
	LM = layermanager	
	local lcName = "01_CAM_LIGHT"
	local lcl
	if (LM.getLayerFromName lcName) == undefined then lcl = LM.newLayerFromName lcName
	else lcl = LM.getLayerFromName lcName
	
	lcl
)

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
-- pdv_cam_RLT = undefined
pdv_cam_RLT
camNameRLT

rollout camNameRLT "camera name"
(
	local newName
	
	edittext camET "cam name:"
	button okBT "ok"
	
	on okBT pressed do
	(
		DestroyDialog camNameRLT
	)
	
	on camET entered val do
	(
-- 		format "%\n" val
		pdv_cam_RLT.newCamName = val
		DestroyDialog camNameRLT
	)
)

try(destroydialog pdv_cam_RLT )catch()
rollout pdv_cam_RLT "point de vue companion"
(
	local camsAr = #()
	local newCamName
	local oneCamSel
	
	group "Active view:"
	(
		button newcamBT "create new Cam"
		button duplicateBT "duplicate camera" --enabled:false
		button lockBT "lock/unlock"
		label fovET "fov:" 
		button fov24BT "24" across: 3
		button fov30BT "30"
		button fov35BT "35"
		button vertCamBT "vertical cam"
	)
	
	group "Cams List:"
	(
		checkbox selCamCB "auto sel cam"
		multilistbox camsMLB "cams list:"
		edittext camNameET "name:"
	)
		
	button convertBT "scene states to vray cams"
	
	fn initCams =
	(
		camsAr = for c in cameras where isKindOf c VRayPhysicalCamera collect c
		qsort camsAr sortbyname
	)
	
	fn refreshUI =
	(
		camsMLB.items = for c in camsAr where isvalidnode c collect c.name
-- 		format "camsMLB.selection:%\n"camsMLB.selection
		if isvalidnode oneCamSel then camNameET.text = oneCamSel.name else camNameET.text = "NONE"
	)
	
	on pdv_cam_RLT open do
	(
		initCams()
		refreshUI()
	)
		
	on newcamBT pressed do
	(
		newCamName == undefined
		
		tmpCam = setVrayCamera ()
		format "new cam: %\n" tmpCam
		
		tmpCam.wirecolor = blue
		tmpCam.specify_fov = false
-- 		viewport.getFOV()
		
		tmpCam.focal_length = (36.0/2)/(tan((viewport.getFOV())/2))
		
		viewport.setCamera tmpCam
		setTransformLockFlags tmpCam #all
		setTransformLockFlags tmpCam.target #all
		
		CreateDialog camNameRLT modal: true
-- 		format "newCamName: %\n" newCamName
		if newCamName != undefined then tmpCam.name = newCamName
		
		initCams()
		refreshUI()
	)
	
	on duplicateBT pressed do
	(
		local cam = getActiveCamera()
		if isvalidnode cam then
		(
			maxOps.cloneNodes #(cam) cloneType: #copy newNodes:&copyCam
			viewport.setCamera copyCam[1]
-- 			copy cam
-- 			format "%\n" copyCam
			initCams()
			refreshUI()
		)
	)
	
	on camsMLB selectionend do
	(
		camsSel = camsMLB.selection as array
		format "%\n" camsSel
		if camsSel.count == 1 then 
		(
			oneCamSel = camsAr[camsSel[1]]
			if selCamCB.state then select oneCamSel
		)
		else
		(
			oneCamSel = undefined
		)
		initCams()
		refreshUI()
	)
	
	on camsMLB doubleClicked val do 
	(
		viewport.setCamera camsAr[val]
	)
	
	on camNameET entered val do
	(
		oneCamSel.name = val
		format "%\n" val
		refreshUI()
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
-- 		afov = 2*atan((36/2)/(24) )
		viewport.SetFOV (2*atan((36.0/2)/(24.0)))
		
-- 		viewport.SetFOV 74
		redrawViews()
	)

	on fov30BT pressed do
	(
		viewport.SetFOV (2*atan((36.0/2)/(30.0)))
		redrawViews()
	)

	on fov35BT pressed do
	(
		viewport.SetFOV (2*atan((36.0/2)/(35.0)))
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
	
	
	on convertBT pressed do
	(
		convertSceneStateToCameras()
	)
)
CreateDialog pdv_cam_RLT