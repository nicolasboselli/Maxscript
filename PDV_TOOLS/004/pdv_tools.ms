/*
maj:
enregistrer format
enregistrer calque visible
*/

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
			copyCam[1].name = cam.name + "_" + st
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

pdv_cam_RLT
camNameRLT
placeSun2RLT

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

global camsMLBHeight 
if camsMLBHeight == undefined then camsMLBHeight = 10

rollout pdv_cam_RLT "point de vue companion"
(
	local camsAr = #()
	local newCamName
	local oneCamSel
	
	group "Active view:"
	(
		button newcamBT "create new Cam" height: 50
		button duplicateBT "duplicate camera" height: 50 --enabled:false
-- 		button lockBT "lock/unlock"
		checkbutton lockCB "locked"
-- 		label fovET "focal:" 
		spinner fovSP "focal length (mm):" 
		button fov24BT "24" across: 4
		button fov30BT "30"
		button fov35BT "35"
		button fov50BT "50"
		button vertCamBT "vertical cam"
		button selTargetBT "select target" enabled: true
		
		label imageSizeLB "image size:"
		spinner widthSP "width:" type: #integer range: [0, 10000, 0] across: 2
		spinner heightSP "height:" type: #integer range: [0, 10000, 0]
	)
	
	group "Cams List:"
	(
		checkbox selCamCB "auto sel cam"
		multilistbox camsMLB "cams list:" height: camsMLBHeight
		button moreBT "+" across:2
		button lessBT "-"
		edittext camNameET "name:"
		button lockCamBT "lock cam" across: 2
		button delCamBT "del cam" --enabled: false
		button interCamBT "inbetween cam"
	)
		
	button convertBT "scene states to vray cams" height: 50
	
	fn initCams =
	(
		camsAr = for c in cameras where isKindOf c VRayPhysicalCamera collect c
		qsort camsAr sortbyname
	)
	
	fn refreshUI forceUI: false =
	(
		local camsNames = #()
		for c in camsAr where isvalidnode c do
		(
			if (getTransformLockFlags c)[1] then append camsNames (c.name + "__[LOCKED]")
			else append camsNames c.name
		)
		if camsNames.count != camsMLB.items.count or forceUI then camsMLB.items = camsNames
-- 			camsMLB.items = camsNames
		
		if isvalidnode oneCamSel then camNameET.text = oneCamSel.name else camNameET.text = "NONE"
			
		local cam = getActiveCamera()
		if isValidNode cam then 
		(
			lockCB.state = (getTransformLockFlags cam)[1]
			fovSP.value = cam.focal_length
		)
	)
	
	fn RefreshOtherUI =
	(
		placeSun2RLT.initSunNCam()
	)
	
	fn loadRenderSize =
	(
		local cam = getActiveCamera()
		try
		(	renderWidth = getUserProp cam "renderWidth"	)catch()
		try
		(	renderHeight = getUserProp cam "renderHeight")catch()
		
		widthSP.value = renderWidth
		heightSP.value = renderHeight
	)
	
	fn writeRenderSize =
	(
		local cam = getActiveCamera()
		try
		(
			setUserProp cam "renderWidth" renderWidth
			setUserProp cam "renderHeight" renderHeight
		)catch()
-- 		setUserProp cam "renderWidth" renderWidth
-- 		setUserProp cam "renderHeight" renderHeight
	)
	
	on pdv_cam_RLT open do
	(
		initCams()
		refreshUI()
		
		loadRenderSize()
	)
		
	on newcamBT pressed do
	(
		newCamName == undefined
		
		tmpCam = setVrayCamera ()
		tmpCam.targeted = true
		in coordsys tmpCam tmpCam.target.position = (point3 0 0 -500)
		
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
			writeRenderSize()
		)
	)
	

	on lockCB changed val do
	(
		format "locked: %\n" val
		local cam = getActiveCamera()
		if val then 
		(
			setTransformLockFlags cam #all
			if isvalidNode cam.target then setTransformLockFlags cam.target #all
		)
		else
		(
			setTransformLockFlags cam #none
			if isvalidNode cam.target then setTransformLockFlags cam.target #none
		)
		refreshUI forceUI: true
	)
	
	on fovSP changed val do
	(
		local cam = getActiveCamera()
		
		format "%\n" val
		if iskindof cam VRayPhysicalCamera then
		(
			cam.specify_fov = off
			cam.focal_length = val
		)
		else
		(
			viewport.SetFOV (2*atan((36.0/2)/(val)))
		)
		redrawViews()
	)
	
	on fov24BT pressed do
	(
		local cam = getActiveCamera()
		if iskindof cam VRayPhysicalCamera then
		(
			cam.specify_fov = off
			cam.focal_length = 24.
		)
		else viewport.SetFOV (2*atan((36.0/2)/(24.0)))
		redrawViews()
			
		fovSP.value = 24.
	)

	on fov30BT pressed do
	(
		local cam = getActiveCamera()
		
		if iskindof cam VRayPhysicalCamera then
		(
			cam.specify_fov = off
			cam.focal_length = 30.
		)
		else viewport.SetFOV (2*atan((36.0/2)/(30.0)))
		redrawViews()
			
		fovSP.value = 30.
	)

	on fov35BT pressed do
	(
		local cam = getActiveCamera()
		if iskindof cam VRayPhysicalCamera then
		(
			cam.specify_fov = off
			cam.focal_length = 35.
		)
		else viewport.SetFOV (2*atan((36.0/2)/(35.0)))
		redrawViews()
			
		fovSP.value = 35.
	)
	
	on fov50BT pressed do
	(
		local cam = getActiveCamera()
		if iskindof cam VRayPhysicalCamera then
		(
			cam.specify_fov = off
			cam.focal_length = 50.
		)
		else viewport.SetFOV (2*atan((36.0/2)/(50.0)))
		redrawViews()
			
		fovSP.value = 50.
	)
	
	
	on selTargetBT pressed do
	(
-- 		local cam = getActiveCamera()
		try(select (getActiveCamera()).target )catch(format "no target\n")
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
	
	on widthSP changed val do
	(
		renderWidth = val
		writeRenderSize()
	)
	
	on heightSP changed val do
	(
		renderHeight = val
		writeRenderSize()
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
	
	on moreBT pressed do
	(
		camsMLBHeight += 5
		pdv_cam_RLT.height += 65
		updateRolloutLayout pdv_cam_RLT forceUpdate: true
	)
	
	on lessBT pressed do
	(
		camsMLBHeight -= 5
		pdv_cam_RLT.height -= 65
		updateRolloutLayout pdv_cam_RLT forceUpdate: true
	)
	
	
	on camsMLB doubleClicked val do 
	(
		writeRenderSize()
		
		viewport.setCamera camsAr[val]
		initCams()
		refreshUI()
		placeSun2RLT.initSunNCam()
		
		loadRenderSize()

	)
	
	on camNameET entered val do
	(
		oneCamSel.name = val
		format "%\n" val
				
		initCams()
		refreshUI forceUI: true
		
		camsMLB.selectionend()
	)
	
	
	on lockCamBT pressed do
	(
		camsSel = camsMLB.selection as array
		format "camSel:%\n" camsSel
		
		for id in camsSel do
		(
			format "camAr[id]:%\n" camsAr[id]
			if (getTransformLockFlags camsAr[id])[1] then
			(	
				setTransformLockFlags camsAr[id] #none
				if isvalidNode camsAr[id].target then setTransformLockFlags camsAr[id].target #none
			)
			else 
			(
				setTransformLockFlags camsAr[id] #all
				if isvalidNode camsAr[id].target then setTransformLockFlags camsAr[id].target #all
			)
		)	
		refreshUI forceUI: true
	)
	
	
	on delCamBT pressed do
	(
		camsSel = camsMLB.selection as array
		format "camSel:%\n" camsSel
		
		for id in camsSel do
		(
			delete camsAr[id]
		)	
		initCams()
		refreshUI forceUI: true
	)
	
	on interCamBT pressed do
	(
		camsSel = camsMLB.selection as array
		
		local count = camsSel.count
		local posAr = [0,0,0]
		local posTargetAr = [0,0,0]
		
		for id in camsSel do
		(
			posAr += camsAr[id].position
			posTargetAr += camsAr[id].target.position
		)
		
		tmpCam = VRayPhysicalCamera pos: (posAr/count)
		tmpCam.targeted = true
		tmpCam.target.position = (posTargetAr/count)
		
-- 		format "count: % posAr: % posTargetAr: %\n" count posAr posTargetAr
		initCams()
		refreshUI forceUI: true
		
	)
	
	on convertBT pressed do
	(
		convertSceneStateToCameras()
	)
)
CreateDialog pdv_cam_RLT width: 200 -- lockHeight: false autoLayoutOnResize: true