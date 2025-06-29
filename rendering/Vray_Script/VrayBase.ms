-- amelioration: 
--x - récupérer le nom de la version de vray présente
--x rectifier les valeurs d IRmap en low, mettre 4000 en memoire
-- x fileout gamma 2.2
-- xresize de l'image 1500*925
-- maj vray 5
	--x mettre en reihnard 0.6
	--x mettre le sun en improved
-- x bouton pour creer des cameras bien settées
-- ajouter passe denoiser


fn findVray  =
(
	local goodR
	for r in rendererClass.classes do
	(
-- 		format "r: %\n" r
		if matchPattern  (r as string)  pattern: "V_Ray_Adv*" then
		(
			goodR = r
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_Next*" then
		(
			goodR = r
			exit
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_5*" then 
		(
			goodR = r
			exit
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_6*" then 
		(
			goodR = r
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_7*" then 
		(
			goodR = r
		)
		else()
	)
-- 	format "good r: %\n" goodR
	 goodR
)


-- 	functions
fn createInfiniteGround =
(
	local vrGround
	test = getnodebyname "vr_ground"
	
	if test == undefined then
	(
		solMat = vraymtl name: "sol_mat"
		vrGround = vrayplane name: "vr_ground" pos: [0,0,0]
		vrGround.material = solMat
	)
	else 
	(
		vrGround = test
	)
	vrGround
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

fn createVraySun =
(
	local dummy_target
	local vraySunVar = undefined
	local val = 2000
	local vraySunExist = false
	
	for o in lights do
	(
		if classof o == vraysun then
		(
			vraySunExist = true
			vraySunVar = o
			format "vray sun still exists\n"
			exit
		)
	)
	
	if vraySunExist == false do
	(
	-- vray sun
		dummy_target = Targetobject wirecolor: yellow name:"VRaySun001.target"
		vraySunVar = VRaySun name:"VRaySun001" pos:[val, - val,val] isSelected:on size_multiplier: 1 enabled:on turbidity: 2.5 ozone: 0.35 sky_model: 4 target: dummy_target
		
	)
	
	-- enviraonnement
	if (classof environmentMap) != vraysky do
	(
		environmentMap = vraysky ()
	)
	
	useEnvironmentMap = true
	
	l = checkLetC()
	l.addnode vraySunVar
	l.addnode dummy_target
	
	vraySunVar
)

fn vrayBaseSetting =
(
	-- vray bucket render
	
 	(findVray())	imageSampler_type: 1 \
	filter_on: false \
	gi_on: true \
	twoLevel_baseSubdivs: 1 twoLevel_fineSubdivs: 8 \	
	gi_primary_type: 2 \
	gi_secondary_type: 3  lightcache_subdivs: 875 lightcache_storeDirectLight: 0 lightcache_showCalcPhase: 1 \
	gi_ao_on: off  \
	colorMapping_type: 6 colorMapping_darkMult: 1.0 colorMapping_brightMult: 0.65 colorMapping_gamma: 2.2 colorMapping_linearWorkflow: false colorMapping_adaptationOnly: 2
		
		
	-- 	gi_primary_type: 0 gi_irradmap_showCalcPhase: true  gi_irradmap_showDirectLight: true  gi_irradmap_minRate: -4  gi_irradmap_maxRate: -3 gi_irradmap_subdivs: 37  gi_irradmap_preset: 2 \
		--*/
)


fn vrayBaseSetting2 =
(
	-- VRAY progressive render
	
 	(findVray())	imageSampler_type: 3 \
	filter_on: false \
	gi_on: true \
	twoLevel_baseSubdivs: 1 twoLevel_fineSubdivs: 8 \
	progressive_max_render_time: 3.0 \
	gi_primary_type: 2 \
	gi_secondary_type: 3  lightcache_subdivs: 875 lightcache_storeDirectLight: 0 lightcache_showCalcPhase: 1 \
	gi_ao_on: off \
	colorMapping_type: 0 colorMapping_darkMult: 1.0 colorMapping_brightMult: 1 colorMapping_gamma: 2.2 colorMapping_linearWorkflow: false colorMapping_adaptationOnly: 2
)

-- renderers.current.colorMapping_adaptationOnly 
-- showproperties renderers.current

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
	
-- 	viewport.setCamera newCam
)
-- viewport.SetFOV 50
-- redrawViews()

-- load layers_tools.ms
onePath = getroot() + @"LAYERS_TOOLS/000/layers_tools.ms"
filein onepath
DestroyDialog layersToolsRLT


fn initLayers =
(
		if not iskindof (layermanager.getlayerfromname "01_CAM_LIGHT") MixinInterface then layermanager.newlayerfromname "01_CAM_LIGHT"
		if not iskindof (layermanager.getlayerfromname "02_BAT") MixinInterface then layermanager.newlayerfromname "02_BAT"
		if not iskindof (layermanager.getlayerfromname "03_MASSE") MixinInterface then layermanager.newlayerfromname "03_MASSE"
	
		if not iskindof (layermanager.getlayerfromname "HAB") MixinInterface then layermanager.newlayerfromname "HAB"
		
		if not iskindof (layermanager.getlayerfromname "Z_OFF") MixinInterface then layermanager.newlayerfromname "Z_OFF"
		daddy = layermanager.getlayerfromname "Z_OFF"
		
		if not iskindof (layermanager.getlayerfromname "CORBEILLE") MixinInterface then layermanager.newlayerfromname "CORBEILLE"
		corbeilleL = layermanager.getlayerfromname "CORBEILLE"
		corbeilleL.setParent daddy
		
		if not iskindof (layermanager.getlayerfromname "PLANS") MixinInterface then layermanager.newlayerfromname "PLANS"
		planL = layermanager.getlayerfromname "PLANS"
		planL.setParent daddy		
)


-- rollout
try(destroydialog VrayRenderRLT)catch()
rollout VrayRenderRLT "Vray Render Tools"
(

-- 	vars
	local params = #("pos")
	local vrayClass = findVray()

-- 	local vrayBase = vrayBaseSetting () 

-- 	local vrayExp = vray_exposure_control shutter: 150 f_number: 9 iso: 100 wb_preset: 1 white_balance: [1,1,1]
-- 	local PhysExp = Physical_Camera_Exposure_Control use_physical_camera_controls: off global_ev: 14.5 
	
-- 	UI
	button VRScenebaseBT "Init Scene" 
	
	group "Init:"
	(
		button initLayersBT "Init Layers"

		button vraySunBT "vray sun and sky"
		button vrayExposureBT "vray exposure"
		button createVrayGroundBT "vray ground"
-- 		button createVrayCamBT "vray cam from view"
		button gammaBT "fileoutgamma 2.2"
		button renderSizeBT "render size"
		
		button vrayBaseSetBT "Vray render settings 1" tooltip: "IR/LC - Bucket - Reinhard"
		button vrayBaseSetBT2 "Vray render settings 2" tooltip: "BF/LC - Prog - Linear"
	)
	
	group "Render mode settings:"
	(
		button progBT "PROGRESSIVE"
		button bucketBT "BUCKET"
	)
	
	group "Cameras settings:"
	( 
		button fixCam1BT "M1" tooltip: "iso: 50 f_num: 7 sh: 1/350°" across: 3
		button fixCam2BT "M2" tooltip: "iso: 100 f_num: 11 sh: 1/250°"
		button fixCam3BT "M3" tooltip: "iso: 100 f_num: 8 sh: 1/200°"
		
		spinner isoSP "iso" range: [0,20000,100]
		spinner f_numSP "f-number" range: [0,100,8]
		spinner shutSpeedSP "shuter Speed (s^-1):" range: [0,10000,200]		
		
		checkbox allCamsCB "all cams" -- across: 2
		button applyCamSetBT "apply"
	)
	
	group "Color map settings"
	(
		dropdownList colMapTypeDDL "color mapping type" items: #("Linear Multiply","Exponential","HSV exponential","Intensity exponential", "Gamma correction", "Intensity Gamma", "Reinhard")
		spinner burnValSP "burn value" range: [0,1,1]
		button applyColMapSetBT "apply"
	)

-- 	Actions
	on  VRScenebaseBT pressed do
	(
-- 		vrayBaseSetBT2.pressed()
		-- progressive rendering
		renderers.current = vrayBaseSetting2 ()
		
		-- add denoiser
		rem =MaxOps.GetCurRenderElementMgr ()
		
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt VRayDenoiser then rem.RemoveRenderElement elt
		)
		
		rem.AddRenderElement (VRayDenoiser())	
		
		-- color mapping reihnard
		colMapTypeDDL.selection = 7
		burnValSP.value = 0.35
		applyColMapSetBT.pressed()
		
		vraySunBT.pressed()
		vrayExposureBT.pressed()
		initLayersBT.pressed()
		renderSizeBT.pressed()
	)
	
	on initLayersBT pressed do
	(
		initLayers()
	)
	
	
	on vraySunBT pressed do
	(
		createVraySun()
	)
	
	on vrayExposureBT pressed do
	(
		sceneExposureControl.exposureControl =  vray_exposure_control shutter: 350 f_number: 7 iso: 50 wb_preset: 1 white_balance: [1,1,1]
	)
	
	on createVrayGroundBT pressed do
	(
		createInfiniteGround()
	)
	
	on createVrayCamBT pressed do
	(
		setVrayCamera ()
	)
	
	on gammaBT pressed do
	(
		format "fileoutgamma: %\n" fileoutgamma
		fileoutgamma = 2.2
	)
	
	on renderSizeBT pressed do
	(
		renderSceneDialog.close()
		
		renderWidth = 1500
		renderHeight = 925
		
		renderSceneDialog.open()
	)
	
	
	on vrayBaseSetBT pressed do
	(
		renderers.current = vrayBaseSetting ()
		
		colMapTypeDDL.selection = 7
		burnValSP.value = 0.35
		applyColMapSetBT.pressed()
	)
	
	on vrayBaseSetBT2 pressed do
	(
		renderers.current = vrayBaseSetting2 ()
		
		colMapTypeDDL.selection = 1
		burnValSP.value = 1.0
		applyColMapSetBT.pressed()
		
		-- add denoiser
		rem =MaxOps.GetCurRenderElementMgr ()
		
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt VRayDenoiser then rem.RemoveRenderElement elt
		)
		
		rem.AddRenderElement (VRayDenoiser())	
	)
	
	on progBT pressed do
	(
		renderers.current.imageSampler_type = 3 
		renderers.current.twoLevel_baseSubdivs = 1
		renderers.current.twoLevel_fineSubdivs = 8
		renderers.current.progressive_max_render_time = 3.0
	)
	
	on bucketBT pressed do
	(
		renderers.current.imageSampler_type = 1
		renderers.current.twoLevel_baseSubdivs = 1
		renderers.current.twoLevel_fineSubdivs = 16
-- 		renderers.current.progressive_max_render_time = 3.0
	)
		
	on fixCam1BT pressed do
	(
		isoSP.value = 50
		f_numSP.value = 7
		shutSpeedSP.value = 350
		
		colMapTypeDDL.selection = 1
		burnValSP.value = 1.0
	)
	
	on fixCam2BT pressed do
	(
		isoSP.value = 100
		f_numSP.value = 11
		shutSpeedSP.value = 150
		
		colMapTypeDDL.selection = 1
		burnValSP.value = 1.0
	)
	
	on fixCam3BT pressed do
	(
		isoSP.value = 100
		f_numSP.value = 8
		shutSpeedSP.value = 200
		
		colMapTypeDDL.selection = 7
		burnValSP.value = 0.35
	)
	
	on selAllCamsBT pressed do
	(
		select cameras
		
		for s in selection do format "%\n" s.name
		
	)
	
	on applyCamSetBT pressed do
	(
		local sel
		
		if allCamsCB.checked then
		(
			sel = cameras as array
		)
		else
		(
			sel = selection as Array
		)
		
		for s in sel where iskindof s VRayPhysicalCamera do
		(
			setProperty s #ISO isoSP.value
			setProperty s #f_number f_numSP.value 
			setProperty s #shutter_speed shutSpeedSP.value
		)
	)
	
	on applyColMapSetBT pressed do
	(
		format "%\n" colMapTypeDDL.selection
		renderers.current.colorMapping_type = colMapTypeDDL.selection - 1 
		renderers.current.colorMapping_brightMult = burnValSP.value
	)
)
createdialog VrayRenderRLT 



/* 
renderers.current.colorMapping_type = 0

"Linear Multiply" = 0
"Exponential" = 1
"HSV exponential" = 2
"Intensity exponential" = 3
"Gamma correction" = 4
"Intensity Gamma" = 5
"Reinhard" = 6 */


