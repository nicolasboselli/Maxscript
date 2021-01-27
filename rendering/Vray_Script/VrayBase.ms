-- amelioration: 
--x - récupérer le nom de la version de vray présente
--x rectifier les valeurs d IRmap en low, mettre 4000 en memoire
-- x fileout gamma 2.2
-- resize de l'image 1500*925
-- maj vray 5
	--x mettre en reihnard 0.6
	--x mettre le sun en improved
-- bouton pour creer des cameras bien settées

fn findVray  =
(
	local goodR
	for r in rendererClass.classes do
	(
-- 		format "r: %\n" r
		if matchPattern  (r as string)  pattern: "V_Ray_Adv*" then
		(
			goodR = r
			exit
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_Next*" then
		(
			goodR = r
			exit
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_5" then 
		(
			goodR = r
			exit
		)
		else()
	)
-- 	format "good r: %\n" goodR
	 goodR
)
-- findVray ()

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
		vraySunVar = VRaySun name:"VRaySun001" pos:[val, - val,val] isSelected:on size_multiplier: 4 enabled:on turbidity: 2.5 ozone: 0.35 sky_model: 4 target: dummy_target
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
	-- mettre le color mapping en reihnard à 0.35
	-- activer l'ambiant occlusion
	-- reprendre les reglages vray quick settings
 	(findVray())	imageSampler_type: 1 \
	filter_on: false \
	gi_on: true \
	adaptiveSubdivision_minRate: 1 adaptiveSubdivision_maxRate: 8 adaptiveSubdivision_threshold: 0.005\
	gi_primary_type: 0 gi_irradmap_showCalcPhase: true  gi_irradmap_showDirectLight: true  gi_irradmap_minRate: -4  gi_irradmap_maxRate: -3 gi_irradmap_subdivs: 37  gi_irradmap_preset: 2 \
	gi_secondary_type: 3  lightcache_subdivs: 875 lightcache_storeDirectLight: 0 lightcache_showCalcPhase: 1 \
	gi_ao_on: on gi_ao_radius: 50 \
	colorMapping_type: 6 colorMapping_darkMult: 1.0 colorMapping_brightMult: 0.65 colorMapping_gamma: 2.2 colorMapping_linearWorkflow: false colorMapping_adaptationOnly: 2
		--*/
)
-- vrayBaseSetting()

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
	newCamshutter_speed = 150
		
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
	local PhysExp = Physical_Camera_Exposure_Control use_physical_camera_controls: off global_ev: 14.5 
	
-- 	UI
	button VRScenebaseBT "Vray scene Basic" 
	
	group "Create:"
	(
		button vrayBaseSetBT "Vray base settings"
		button vraySunBT "vray sun and sky"
		button vrayExposureBT "vray exposure"
		button createVrayGroundBT "vray ground"
		button createVrayCamBT "vray cam from view"
		button gammaBT "fileoutgamma 2.2"
		button renderSizeBT "render size"
	)
	
	/*
	group "render thumbnail"
	(
		button renderBT "render"
		button delSunBT "delete sun"
	)
	
	button renderThumbBT "render thumbnail"
*/
-- 	Actions
	on  VRScenebaseBT pressed do
	(
		vrayBaseSetBT.pressed()
		vraySunBT.pressed()
		vrayExposureBT.pressed()
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
		sceneExposureControl.exposureControl =  PhysExp
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
		fileoutgamma = 2.2
	)
	
	on renderSizeBT pressed do
	(
		renderSceneDialog.close()
		
		renderWidth = 1500
		renderHeight = 925
		
		renderSceneDialog.open()
	)
	
	on renderBT pressed do
	(
-- 		vrayBaseSetBT.pressed()
-- 		vraySunBT.pressed()
-- 		vrayExposureBT.pressed()
		
		renderSceneDialog.close()
		
		renderWidth = 1500
		renderHeight = 1500
		
-- 		max quick render -- netrender: false
		
		img = render netrender: false
		
		-- Get the last Rendered image
-- 		img = getlastrenderedimage()
		
		-- Assign a filename
		img.filename = maxFilePath + (getFilenameFile maxfilename) + ".jpg"
		
		-- Save it
		save img gamma: 2.2
		
	)
	
	on delSunBT pressed  do
	(
		sun  = getnodebyname "VRaySun001"
		delete sun
	)
	
	on renderThumbBT pressed do
	(
		vrayBaseSetBT.pressed()
		vraySunBT.pressed()
		vrayExposureBT.pressed()
		renderBT.pressed()
		delSunBT.pressed()
		
	)
	
)
createdialog VrayRenderRLT 







