-- extract shadow 

fn findVray  =
(
	for r in rendererClass.classes do
	(
		if matchPattern  (r as string)  pattern: "V_Ray_Adv*" do return r
		break
	)
)


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

-- backup
vrayClass = findVray()
vrayBak = copy renderers.current

-- shadow setup
shadowMat = vraymtl name: "shadow_mat" diffuse: (color 235 235 235)

VrayShadowPreset = vrayClass \
imageSampler_type: 1 \
filter_on: false \
options_maps: false \
gi_on: false \
options_lights: true options_defaultLights: 0 \
colorMapping_type: 0 colorMapping_darkMult: 1 colorMapping_brightMult: 1 colorMapping_gamma: 1  \

options_reflectionRefraction: false options_overrideMtl_on: false \

system_raycaster_memLimit: 0 system_region_x: 16 system_region_y: 16 \
options_overrideMtl_mtl: shadowMat options_overrideMtl_on: true

useEnvironmentMap = off
renderers.current = copy VrayShadowPreset


max quick render

-- restore setup

useEnvironmentMap = on
renderers.current = vrayBak
