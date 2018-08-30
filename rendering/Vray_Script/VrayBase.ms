-- amelioration: 
--x - récupérer le nom de la version de vray présente
--x rectifier les valeurs d IRmap en low, mettre 4000 en memoire
-- proposer d'activer le gamma de max


fn findVray  =
(
	for r in rendererClass.classes do
	(
		if matchPattern  (r as string)  pattern: "V_Ray_Adv*" do return r
		break
	)
)


-- 	functions
fn createInfiniteGround =
(
	local vrGround
	test = getnodebyname "vr_ground"
	
	if test == undefined then
	(
		solMat = vraymtl name: "sol_mat"
		vrGround = vrayplane name: "vr_ground" pos: [0,0,-50]
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
	local lcl
	if (LM.getLayerFromName "LetC") == undefined then lcl = LM.newLayerFromName "LetC"
	else lcl = LM.getLayerFromName "LetC"
	
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
			print "vray sun still exists"
			break
		)
	)
	
	if vraySunExist == false do
	(
	-- vray sun
-- 			dummy_target = dummy name: "vraysuntarget" 
		dummy_target = Targetobject wirecolor: yellow
		vraySunVar = VRaySun name:"VRaySun001" pos:[val,val,val] isSelected:on size_multiplier: 4 enabled:on turbidity: 2.5 ozone: 0.35 sky_model: 0 target: dummy_target
		-- enviraonnement
	)
	
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
	(findVray()) \
	imageSampler_type: 1 \
	filter_on: false \
	gi_on: true \
	gi_primary_type: 0 gi_irradmap_showCalcPhase: true  gi_irradmap_showDirectLight: true  gi_irradmap_minRate: -3  gi_irradmap_maxRate: -2 gi_irradmap_subdivs: 30  gi_irradmap_preset: 2\
	gi_secondary_type: 3  lightcache_subdivs: 400 lightcache_storeDirectLight: 0 lightcache_showCalcPhase: 1 \
	colorMapping_type: 0 colorMapping_darkMult: 1.0 colorMapping_brightMult: 1.0 colorMapping_gamma: 2.2 colorMapping_linearWorkflow: false --colorMapping_adaptationOnly: (colorMapTest())
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
	
	l = checkLetC()
	l.addnode newCam
	l.addnode newCam.target
	
	viewport.setCamera newCam
)

-- rollout
try(destroydialog VrayRenderRLT)catch()
rollout VrayRenderRLT "Vray Options"
(

-- 	vars
	local params = #("pos")
	local vrayClass = findVray()
	
	fn  colorMapTest =
	(
		return true
	)

-- 	local vrayBase = vrayBaseSetting () 
	/*
	local vrayBase = vrayClass \
	imageSampler_type: 1 \
	filter_on: false \
	gi_on: true \
	gi_primary_type: 0 gi_irradmap_showCalcPhase: true  gi_irradmap_showDirectLight: true  gi_irradmap_minRate: -3  gi_irradmap_maxRate: -2 gi_irradmap_subdivs: 30  gi_irradmap_preset: 2\
	gi_secondary_type: 3  lightcache_subdivs: 400 lightcache_storeDirectLight: 0 lightcache_showCalcPhase: 1 \
	colorMapping_type: 0 colorMapping_darkMult: 1.0 colorMapping_brightMult: 1.0 colorMapping_gamma: 2.2 colorMapping_linearWorkflow: false --colorMapping_adaptationOnly: (colorMapTest())
	*/

	local vrayExp = vray_exposure_control shutter: 150 f_number: 9 iso: 100 wb_preset: 1 white_balance: [1,1,1]

	
-- 	UI
	button VRScenebaseBT "Vray scene Basic" 
	
	group "Create:"
	(
		button vrayBaseSetBT "Vray base settings"
		button vraySunBT "vray sun and sky"
		button vrayExposureBT "vray exposure"
		button createVrayGroundBT "vray ground"
		button createVrayCamBT "vray cam from view"
	)

-- 	Actions
	on  VRScenebaseBT pressed do
	(
		vrayBaseSetBT.pressed()
		vraySunBT.pressed()
		vrayExposureBT.pressed()
		/*
		-- settings
		renderers.current = copy VrayBase
						
		-- vray sun
		createVraySun()
		
		-- exposure
		sceneExposureControl.exposureControl =  vrayExp
		*/
	)
	
	on vrayBaseSetBT pressed do
	(
		renderers.current = vrayBaseSetting ()
	)
	
	on vraySunBT pressed do
	(
		createVraySun()
	)
	
	on vrayExposureBT pressed do
	(
		sceneExposureControl.exposureControl =  vrayExp
	)
	
	on createVrayGroundBT pressed do
	(
		createInfiniteGround()
	)
	
	on createVrayCamBT pressed do
	(
		setVrayCamera ()
	)
)

createdialog VrayRenderRLT 







