-- maj:
-- a l alpha sur selection, prendre en compte les masque d'opacité des materiaux de la selection

-- find vray version functions
fn findVray  =
(
	local r
	for rc in rendererClass.classes do
	(
-- 		format "r: %\n" r
		if matchPattern  (rc as string)  pattern: "V_Ray_Adv*" or  matchPattern  (rc as string)  pattern: "V_Ray_Next_*" then
		(
			r = rc
-- 			format "exit\n"
-- 			format "r: %\n" r
-- 			exit
		)
		else()
	)
	format "r: %\n" r
	r
)

-- findVray()

-- fonction pour activer ou desactiver l'exposition des cameras vray
fn VrayCamExpStateFN TheState = 
(
	for o in cameras where iskindof o Vrayphysicalcamera do o.exposure = TheState
)

fn setVrayAlpha =
(
-- 	local vrayClass = findVray()
	
	(findVray()) \
	imageSampler_type: 1 \
	filter_on: false \
	options_maps: true \
	gi_on: false \
	options_lights: false options_defaultLights: 0 \
	colorMapping_type: 0 colorMapping_darkMult: 1 colorMapping_brightMult: 1 colorMapping_gamma: 1  \

	options_reflectionRefraction: false options_overrideMtl_on: false \

	system_raycaster_memLimit: 0 system_region_x: 16 system_region_y: 16
)
-- setVrayAlpha()


global vrayClass -- = findVray()

-- 	button VRScenebaseBT "Vray Sun Scene Creator" 
global AutoIllumMat = vraylightmtl twoSided: true name: (uniquename "autoIllum")
global re = maxOps.GetCurRenderElementMgr ()

global vrayBak --= renderers.current
global sunBak
global environBak = useEnvironmentMap 
global expBak = sceneExposureControl.exposureControl
global RenderEltsStateBak

global occluMap = vraydirt()
global occluMat = vraylightmtl texmap: occluMap twoSided: true


fn makeAutoIllumMat = vraylightmtl twoSided: true name: (uniquename "autoIllum")
-- makeAutoIllumMat()


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
-- 		renderers.current = copy VrayAlphaPreset
	renderers.current =  setVrayAlpha()
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

try(destroydialog VrayAlphaMaskRLT)catch()
-- rollout
rollout VrayAlphaMaskRLT "Vray passes render"
(
	/*
	local vrayClass -- = findVray()
	
-- 	button VRScenebaseBT "Vray Sun Scene Creator" 
	local AutoIllumMat = vraylightmtl twoSided: true
	local re = maxOps.GetCurRenderElementMgr ()
	
	local vrayBak --= renderers.current
	local sunBak
	local environBak = environmentMap 
	local expBak = sceneExposureControl.exposureControl
	local RenderEltsStateBak
	
	local occluMap = vraydirt()
	local occluMat = vraylightmtl texmap: occluMap twoSided: true
*/
	
-- functions vars dependant
	/*
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
-- 		renderers.current = copy VrayAlphaPreset
		renderers.current =  setVrayAlpha()
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
	*/
	
-- UI

-- 	/*
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
-- 	*/

	on VrayAlphaMaskRLT open do
	(
		backupRenderDef()
	)
	
	on VrayAlphaMaskRLT close do
	(
		restoreRenderDef()
	)
	
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
		
		try
		(
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
		catch(restoreRenderDef())
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
	
)

-- createdialog VrayAlphaMaskRLT