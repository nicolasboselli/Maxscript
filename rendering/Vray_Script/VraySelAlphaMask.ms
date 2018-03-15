-- maj:
-- a l alpha sur selection, prendre en compte les masque d'opacité des materiaux de la selection

-- find vray version functions
fn findVray  =
(
	for r in rendererClass.classes do
	(
		if matchPattern  (r as string)  pattern: "V_Ray_Adv*" do return r
		break
	)
)

-- fonction pour activer ou desactiver l'exposition des cameras vray
fn VrayCamExpStateFN TheState = 
(
	for o in cameras do
	(
		if classof o == Vrayphysicalcamera then
		(
			o.exposure = TheState
		)
	)
)

try(destroydialog VrayAlphaMaskRLT)catch()
-- rollout
rollout VrayAlphaMaskRLT "Vray passes render"
(
	
	local vrayClass = findVray()
	
-- 	button VRScenebaseBT "Vray Sun Scene Creator" 
	local AutoIllumMat = vraylightmtl twoSided: true
	local re = maxOps.GetCurRenderElementMgr ()
	
	local vrayBak = renderers.current
	local sunBak
	local environBak = environmentMap 
	local expBak = sceneExposureControl.exposureControl
	local RenderEltsStateBak
	
	local occluMap = vraydirt()
	local occluMat = vraylightmtl texmap: occluMap twoSided: true
	
	local VrayAlphaPreset = vrayClass \
	imageSampler_type: 1 \
	filter_on: false \
	options_maps: true \
	gi_on: false \
	options_lights: false options_defaultLights: 0 \
	colorMapping_type: 0 colorMapping_darkMult: 1 colorMapping_brightMult: 1 colorMapping_gamma: 1  \

	options_reflectionRefraction: false options_overrideMtl_on: false \

	system_raycaster_memLimit: 0 system_region_x: 16 system_region_y: 16
	
	-- set color mapping 
	/*
	try
	(
		VrayAlphaPreset.colorMapping_linearWorkflow =  false
	)
	catch
	(
		VrayAlphaPreset.colorMapping_linearWorkflow =  0
	)
	*/
	
	
-- functions vars dependant
	-- backup des parametres de rendu
	fn backupRenderDef =
	(
		vrayBak = copy renderers.current
		environBak = useEnvironmentMap
		expBak = sceneExposureControl.exposureControl
		RenderEltsStateBak = re.getElementsActive ()
	)
	
	-- applications des params de rendus alpha
	fn setVrayNight =
	(
		-- applications des params de rendus alpha
		renderers.current = copy VrayAlphaPreset
		useEnvironmentMap = false
		sceneExposureControl.exposureControl = undefined 
		re.setElementsActive false
		VrayCamExpStateFN false	
	)
	
	fn restoreRenderDef =
	(
		-- recup des preset de rendu
		renderers.current = copy vrayBak
		useEnvironmentMap = environBak
		sceneExposureControl.exposureControl = expBak 
		re.setElementsActive RenderEltsStateBak
		VrayCamExpStateFN true
	)
	
-- UI
	group "preset"
	(
		checkbutton VRAlphaPresetCB "Vray Alpha Preset" 
-- 		button VRbasePresetBT "Restore Vray Preset" enabled: false --across: 2

	)
	
	group "Render Alpha:"
	(
		button AlphaSelRenderBT "Object Selected" -- across: 2
		button MatSelRenderBT "Material Selected" -- across: 2
-- 		button BatchAlphaSelRenderBT "On Selected BatchRender"
	)
	
	/*
	group "render occlu:"
	(
		button OccluRenderBT "Set Render"
		button CleanRenderBT "Clean Render"
	)
	*/
	
	on VRAlphaPresetCB changed state do
	(
		if state == true do
		(
			-- backup des parametres de rendu
			backupRenderDef()
			-- applications des params de rendus alpha
			setVrayNight()
		)
		if state == false do
		(
			-- recup des preset de rendu
			restoreRenderDef()
		)
	)
	
	on AlphaSelRenderBT pressed do
	(
		-- backup material selection
		local SelToAlpha = selection as array
		
		Material_Bak = for o in SelToAlpha collect o.material
		for o in SelToAlpha do o.material = copy AutoIllumMat
		
		-- backup des parametres de rendu
		backupRenderDef()
		-- applications des params de rendus alpha
		setVrayNight()
		backgroundColor = color 0 0 0
		
		-- rendus
		max quick render
		
		-- recup des materiaux originaux de la selection
		for i = 1 to SelToAlpha.count do SelToAlpha[i].material = Material_Bak[i]
		
		-- recup des preset de rendu
		restoreRenderDef()
	)
	
	on MatSelRenderBT pressed do
	(
		try
		(
			Material_Bak = meditMaterials[activeMeditSlot]
			AutoIllumMatTmp = copy AutoIllumMat
			if Material_Bak.texmap_opacity != undefined then
			(
	-- 			format "AutoIllumMatTmp: %\n" AutoIllumMatTmp
				AutoIllumMatTmp.opacity_texmap = copy Material_Bak.texmap_opacity
				AutoIllumMatTmp.opacity_multiplyColor = on
				AutoIllumMatTmp.opacity_texmap_on = on
			)
	-- 		meditMaterials[1] = copy AutoIllumMatTmp
			replaceinstances meditMaterials[activeMeditSlot] AutoIllumMatTmp
			
			-- backup des parametres de rendu
			backupRenderDef()
			-- applications des params de rendus alpha
			setVrayNight()
			backgroundColor = color 0 0 0
			-- rendus
			max quick render
			
			replaceinstances meditMaterials[activeMeditSlot] Material_Bak
			
			-- recup des preset de rendu
			restoreRenderDef()
		)
		catch
		(
			restoreRenderDef()
		)
	)
	
	
	on OccluRenderBT pressed do
	(
		vr=renderers.current

		MatMaqDirt = VRayDirt radius: 100 
		autoIllumMtl = VRayLightMtl texmap: MatMaqDirt name: "occluMat" twoSided: true

		backgroundColor = color 255 255 255
		renderers.current.options_overrideMtl_mtl = autoIllumMtl
		renderers.current.options_overrideMtl_on = true
	)
	
	on CleanRenderBT pressed do
	(
		vr=renderers.current
		
		backgroundColor = color 0 0 0
		renderers.current.options_overrideMtl_mtl = undefined
		renderers.current.options_overrideMtl_on = false
	)
	
	on VrayAlphaMaskRLT close do
	(
		if VRAlphaPresetCB.state == true do
		(
			print "restore parameters"
			restoreRenderDef()
		)
	)
	
)

createdialog VrayAlphaMaskRLT