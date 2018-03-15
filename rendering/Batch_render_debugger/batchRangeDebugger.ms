Global VrayBatchRangeDebugPreset = V_Ray_Adv_2_10_01 ()

VrayBatchRangeDebugPreset.imageSampler_type = 1
VrayBatchRangeDebugPreset.filter_on = false

VrayBatchRangeDebugPreset.gi_on = false

VrayBatchRangeDebugPreset.options_lights = false
VrayBatchRangeDebugPreset.options_defaultLights = 0

VrayBatchRangeDebugPreset.colorMapping_type = 0
VrayBatchRangeDebugPreset.colorMapping_darkMult = 1
VrayBatchRangeDebugPreset.colorMapping_brightMult = 1
VrayBatchRangeDebugPreset.colorMapping_gamma = 1
VrayBatchRangeDebugPreset.colorMapping_linearWorkflow = false

VrayBatchRangeDebugPreset.options_reflectionRefraction = false
VrayBatchRangeDebugPreset.options_overrideMtl_on = false

-- bakup rendu
VrayStateBak = renderers.current
EnvironStateBak = useEnvironmentMap
ExpoStateBak = sceneExposureControl.exposureControl
RenderEltsStateBak = re.getElementsActive ()

-- preset rendu
renderers.current = VrayBatchRangeDebugPreset
useEnvironmentMap = false
sceneExposureControl.exposureControl = undefined
re.setElementsActive false

-- rendu
renderSceneDialog.close()
BakrendTimeType = rendTimeType
BakrendStart = rendStart
BakrendEnd = rendEnd

rendTimeType = 3
rendStart = 1
rendEnd = 1

rendSaveFile = false
renderSceneDialog.commit ()

-- max quick render

renderers.current = VrayStateBak
useEnvironmentMap = EnvironStateBak
sceneExposureControl.exposureControl = ExpoStateBak 
re.setElementsActive RenderEltsStateBak

-- batchRenderMgr.render ()	

-- rendTimeType = BakrendTimeType
-- rendStart = BakrendStart
-- rendEnd = BakrendEnd

-- renderSceneDialog.open()

-- recup rendu





